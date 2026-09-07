//! Readiness belongs to our listener, not to an arbitrary process on the IPC endpoint.
use std::sync::{Condvar, Mutex};
use std::time::Duration;

#[derive(Clone, Copy, PartialEq, Eq)]
enum State {
    Starting,
    Ready,
    Stopped,
}

pub struct ListenerState {
    state: Mutex<State>,
    changed: Condvar,
}

impl ListenerState {
    pub const fn new() -> Self {
        Self {
            state: Mutex::new(State::Starting),
            changed: Condvar::new(),
        }
    }

    pub fn ready(&self) {
        *self.state.lock().unwrap() = State::Ready;
        self.changed.notify_all();
    }

    pub fn stopped(&self) {
        *self.state.lock().unwrap() = State::Stopped;
        self.changed.notify_all();
    }

    // Called on the FFI worker, never the Tokio event-loop thread.
    pub fn wait_ready(&self, timeout: Duration) -> bool {
        let (state, _) = self
            .changed
            .wait_timeout_while(self.state.lock().unwrap(), timeout, |state| {
                *state == State::Starting
            })
            .unwrap();
        *state == State::Ready
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn never_reports_ready_before_own_listener_starts() {
        assert!(!ListenerState::new().wait_ready(Duration::ZERO));
    }
    #[test]
    fn readiness_is_repeatable_and_stopping_revokes_it() {
        let state = ListenerState::new();
        state.ready();
        assert!(state.wait_ready(Duration::ZERO));
        assert!(state.wait_ready(Duration::ZERO));
        state.stopped();
        assert!(!state.wait_ready(Duration::ZERO));
    }
    #[test]
    fn failed_start_is_not_ready() {
        let state = ListenerState::new();
        state.stopped();
        assert!(!state.wait_ready(Duration::ZERO));
    }
    #[test]
    fn waiting_worker_is_woken_by_listener() {
        let state = std::sync::Arc::new(ListenerState::new());
        let worker_state = state.clone();
        let worker = std::thread::spawn(move || worker_state.wait_ready(Duration::from_secs(2)));
        state.ready();
        assert!(worker.join().unwrap());
    }
}
