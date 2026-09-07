import 'package:flutter/material.dart';

/// Presentation only: native connection handling remains in ServerModel.
class TekniqCustomerPanel extends StatelessWidget {
  const TekniqCustomerPanel(
      {super.key,
      required this.id,
      required this.ready,
      required this.awaitingApproval,
      required this.active,
      this.fromSwitch = false,
      this.error,
      required this.onAccept,
      required this.onReject,
      required this.onStop});
  final String id;
  final bool ready, awaitingApproval, active, fromSwitch;
  final String? error;
  final VoidCallback onAccept, onReject, onStop;
  @override
  Widget build(BuildContext context) {
    const background = Color(0xFF0B1120);
    const ink = Color(0xFFEEF3FB);
    const muted = Color(0xFF9AA8BA);
    const surface = Color(0xFF111827);
    const border = Color(0xFF334155);
    const brand = Color(0xFFF8BF00);
    return Container(
      color: background,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(42, 28, 42, 30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (error != null) ...[
                  Text(error!,
                      key: const Key('connection-error'),
                      style: const TextStyle(color: ink)),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Image.asset(
                      'assets/tekniq-mark.png',
                      width: 54,
                      height: 54,
                      filterQuality: FilterQuality.high,
                    ),
                    const SizedBox(width: 14),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tekniq Hulp',
                          style: TextStyle(
                            color: ink,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Veilige hulp op afstand',
                          style: TextStyle(color: muted, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                Text(
                  awaitingApproval
                      ? 'Een Tekniq-medewerker wil helpen'
                      : active
                          ? fromSwitch
                              ? 'Tekniq toont nu een scherm'
                              : 'Tekniq helpt nu mee'
                          : 'Geef alleen deze code door aan uw Tekniq-medewerker.',
                  style: TextStyle(
                    color: ink,
                    fontSize: awaitingApproval || active ? 22 : 17,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign:
                      awaitingApproval || active ? TextAlign.center : null,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: surface,
                    border: Border.all(color: border),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: awaitingApproval || active
                        ? CrossAxisAlignment.stretch
                        : CrossAxisAlignment.start,
                    children: [
                      if (awaitingApproval || active) ...[
                        Icon(
                          active
                              ? Icons.verified_user_rounded
                              : Icons.support_agent_rounded,
                          color: brand,
                          size: 42,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          awaitingApproval
                              ? 'Sta deze verbinding eenmalig toe. U houdt altijd zelf de controle.'
                              : 'De verbinding is actief. U kunt de hulp hieronder direct stoppen.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: muted,
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                      ] else ...[
                        const Text(
                          'UW CODE',
                          style: TextStyle(
                            color: muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          id.isEmpty ? 'Even geduld…' : id,
                          style: const TextStyle(
                            color: ink,
                            fontSize: 34,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (!awaitingApproval && !active) ...[
                  Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: ready ? const Color(0xFF12B76A) : brand,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        error != null
                            ? 'Verbinding niet beschikbaar'
                            : ready
                                ? 'Klaar voor verbinding'
                                : 'Verbinding voorbereiden…',
                        style: const TextStyle(color: muted, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                ],
                FilledButton(
                  onPressed: awaitingApproval ? onAccept : onStop,
                  style: FilledButton.styleFrom(
                    backgroundColor: active ? const Color(0xFF9F2424) : brand,
                    foregroundColor: active ? ink : const Color(0xFF17120A),
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    awaitingApproval ? 'Hulp toestaan' : 'Hulp beëindigen',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                if (awaitingApproval)
                  TextButton(
                      onPressed: onReject, child: const Text('Niet toestaan')),
                if (!awaitingApproval)
                  const Text(
                    'Sluit documenten die niet nodig zijn. U kunt de hulp altijd stoppen met de knop hierboven.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: muted, fontSize: 12, height: 1.4),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Gebaseerd op RustDesk · Broncode en privacy: help.tekniq.nl/hulp-op-afstand',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF6F7E93), fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
