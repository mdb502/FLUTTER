// widgets/remote_layouts/receiver_layout.dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'buttons/round_button.dart';
import 'buttons/neumorphic_dpad.dart';

class ReceiverLayout extends StatelessWidget {
  final Function(String commandId, bool isMacro) onAction;

  const ReceiverLayout({super.key, required this.onAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- 1. SUPERIOR: POWER Y MUTE ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildRoundButton(
              label: "PWR",
              icon: Icons.power_settings_new,
              isLearned: true,
              onTap: () => onAction("power", false),
            ),
            buildRoundButton(
              label: "MUTE",
              icon: Icons.volume_off,
              isLearned: true,
              onTap: () => onAction("mute", false),
            ),
          ],
        ),
        const SizedBox(height: 25),

        // --- 2. D-PAD: VOLUMEN Y NAVEGACIÓN ---
        NeumorphicDPad(
          labelCenter: "PAUSE",
          onAction: (direccion) {
            if (direccion == "UP") onAction("vol_up", false);
            if (direccion == "DOWN") onAction("vol_down", false);
            if (direccion == "LEFT") onAction("previo", false);
            if (direccion == "RIGHT") onAction("siguiente", false);
            if (direccion == "CENTER") onAction("pausa", false);
          },
        ),
        const SizedBox(height: 25),

        // --- 3. REPRODUCCIÓN: MODE Y STOP ---
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRectButton("MODE", () => onAction("mode", false)),
            const SizedBox(width: 20),
            _buildRectButton(
              "STOP",
              () => onAction("stop", false),
              isAlert: true,
            ),
          ],
        ),
        const SizedBox(height: 20),

        // --- 4. RADIOS FM CHILE ---
        const Text(
          "RADIOS FM CHILE",
          style: TextStyle(
            fontSize: 10,
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 15),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPresetButton("DUNA", "897"),
            const SizedBox(width: 10),
            _buildPresetButton("PUDAHUEL", "905"),
            const SizedBox(width: 10),
            _buildPresetButton("ADN", "917"),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPresetButton("COOP.", "933"),
            const SizedBox(width: 10),
            _buildPresetButton("R&P", "941"),
            const SizedBox(width: 10),
            _buildPresetButton("B-BIO", "997"),
          ],
        ),

        const SizedBox(height: 30),

        // --- 5. TECLADO NUMÉRICO ---
        _buildNumericGrid(),
      ],
    );
  }

  Widget _buildPresetButton(String label, String sequence) {
    return _buildRectButton(
      label,
      () => onAction("MACRO_RADIO_$sequence", true),
      width: 105,
      fontSize: 10,
    );
  }

  Widget _buildNumericGrid() {
    return Column(
      children: [
        for (var row in [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9],
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: row
                  .map(
                    (n) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: buildRoundButton(
                        label: n.toString(),
                        isLearned: true,
                        onTap: () => onAction(n.toString(), false),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        // BOTÓN 0: Enuelto en Row para mantener su forma circular (60x60)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildRoundButton(
              label: "0",
              isLearned: true,
              onTap: () => onAction("0", false),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRectButton(
    String label,
    VoidCallback onTap, {
    double width = 100,
    double fontSize = 12,
    bool isAlert = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: const Offset(3, 3),
              blurRadius: 5,
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.5),
              offset: const Offset(-3, -3),
              blurRadius: 5,
            ),
          ],
          border: isAlert
              ? Border.all(color: Colors.redAccent.withValues(alpha: 0.3))
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: isAlert ? Colors.redAccent : AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }
}
