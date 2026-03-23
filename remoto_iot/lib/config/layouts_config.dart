// lib/config/layouts_config.dart
class LayoutsConfig {
  static const List<Map<String, String>> receiverStandard = [
    {'id': 'power', 'label': 'POWER'},
    {'id': 'mute', 'label': 'MUTE'},
    {'id': 'mode', 'label': 'MODE'},
    {'id': 'previo', 'label': '<< PREV'},
    {'id': 'pausa', 'label': 'PAUSE'},
    {'id': 'siguiente', 'label': 'NEXT >>'},
    {'id': 'vol_down', 'label': 'VOL -'},
    {'id': 'stop', 'label': 'STOP'},
    {'id': 'vol_up', 'label': 'VOL +'},
    {'id': '1', 'label': '1'},
    {'id': '2', 'label': '2'},
    {'id': '3', 'label': '3'},
    {'id': '4', 'label': '4'},
    {'id': '5', 'label': '5'},
    {'id': '6', 'label': '6'},
    {'id': '7', 'label': '7'},
    {'id': '8', 'label': '8'},
    {'id': '9', 'label': '9'},
    {'id': '0', 'label': '0'},
  ];

  static const List<Map<String, String>> amplifierStandard = [
    // Fila 1: Energía y Silencio
    {'id': 'power', 'label': 'POWER'},
    {'id': 'mute', 'label': 'MUTE'},
    {'id': 'pure_direct', 'label': 'DIRECT'}, // Clásico en amplificadores
    // Fila 2: Volumen
    {'id': 'vol_up', 'label': 'VOL +'},
    {'id': 'vol_down', 'label': 'VOL -'},
    {'id': 'loudness', 'label': 'LOUD'},

    // Fila 3: Entradas Principales
    {'id': 'input_disc', 'label': 'DISC'},
    {'id': 'input_cd', 'label': 'CD'},
    {'id': 'input_video', 'label': 'VIDEO'},

    // Fila 4: Entradas Secundarias / Digitales
    {'id': 'input_aux', 'label': 'AUX'},
    {'id': 'input_tuner', 'label': 'TUNER'},
    {'id': 'input_tape1', 'label': 'TAPE1'},

    // Fila 5: Otros
    {'id': 'speaker_ab', 'label': 'SPKR A/B'},
    {'id': 'dimmer', 'label': 'DIMMER'},
    {'id': 'sleep', 'label': 'SLEEP'},
  ];
}
