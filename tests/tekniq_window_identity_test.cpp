#include "../flutter/windows/runner/tekniq_window_identity.h"
#include <cassert>
#include <iostream>

int main() {
  const auto instance = GetModuleHandleW(nullptr);
  const wchar_t* klass = L"TekniqHiddenWindowIdentityTest";
  WNDCLASSW wc{};
  wc.lpfnWndProc = DefWindowProcW;
  wc.hInstance = instance;
  wc.lpszClassName = klass;
  assert(RegisterClassW(&wc));
  // Hidden test window only; no customer session or running app is touched.
  const auto window = CreateWindowExW(0, klass, L"Tekniq Hulp", WS_OVERLAPPEDWINDOW,
      0, 0, 100, 100, nullptr, nullptr, instance, nullptr);
  assert(window);
  assert(FindTekniqMainWindow(L"Tekniq Hulp", klass) == window);
  SetWindowTextW(window, L"Tekniq Hulp \u00b7 test 8");
  assert(FindTekniqMainWindow(L"Tekniq Hulp", klass) == window);
  assert(FindTekniqMainWindow(L"Tekniq Beheer", klass) == nullptr);
  SetWindowTextW(window, L"Tekniq Hulp - Connection Manager");
  assert(FindTekniqMainWindow(L"Tekniq Hulp", klass) == nullptr);
  SetPropW(window, TekniqMainWindowProperty(L"Tekniq Hulp").c_str(), reinterpret_cast<HANDLE>(1));
  SetWindowTextW(window, L"Any future display title");
  assert(FindTekniqMainWindow(L"Tekniq Hulp", klass) == window);
  assert(FindTekniqMainWindow(L"Tekniq Hulp", L"DifferentClass") == nullptr);
  RemovePropW(window, TekniqMainWindowProperty(L"Tekniq Hulp").c_str());
  DestroyWindow(window);
  assert(FindTekniqMainWindow(L"Tekniq Hulp", klass) == nullptr);
  UnregisterClassW(klass, instance);
  std::cout << "7 window identity assertions passed\n";
}
