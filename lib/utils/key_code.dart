import 'package:win32/win32.dart';
import '../services/config_service.dart';

// https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
final Map<int, String> defaultKeyCodeMap = {
  VK_A: 'A',
  VK_B: 'B',
  VK_C: 'C',
  VK_D: 'D',
  VK_E: 'E',
  VK_F: 'F',
  VK_G: 'G',
  VK_H: 'H',
  VK_I: 'I',
  VK_J: 'J',
  VK_K: 'K',
  VK_L: 'L',
  VK_M: 'M',
  VK_N: 'N',
  VK_O: 'O',
  VK_P: 'P',
  VK_Q: 'Q',
  VK_R: 'R',
  VK_S: 'S',
  VK_T: 'T',
  VK_U: 'U',
  VK_V: 'V',
  VK_W: 'W',
  VK_X: 'X',
  VK_Y: 'Y',
  VK_Z: 'Z',
  VK_F1: 'F1',
  VK_F2: 'F2',
  VK_F3: 'F3',
  VK_F4: 'F4',
  VK_F5: 'F5',
  VK_F6: 'F6',
  VK_F7: 'F7',
  VK_F8: 'F8',
  VK_F9: 'F9',
  VK_F10: 'F10',
  VK_F11: 'F11',
  VK_F12: 'F12',
  VK_F13: 'F13',
  VK_F14: 'F14',
  VK_F15: 'F15',
  VK_F16: 'F16',
  VK_F17: 'F17',
  VK_F18: 'F18',
  VK_F19: 'F19',
  VK_F20: 'F20',
  VK_F21: 'F21',
  VK_F22: 'F22',
  VK_F23: 'F23',
  VK_F24: 'F24',
  VK_RETURN: 'Enter',
  VK_TAB: 'Tab',
  VK_BACK: 'Backspace',
  VK_ESCAPE: 'Escape',
  VK_DELETE: 'Delete',
  VK_INSERT: 'Insert',
  VK_HOME: 'Home',
  VK_END: 'End',
  VK_PRIOR: 'PageUp',
  VK_NEXT: 'PageDown',
  VK_LEFT: 'Left',
  VK_RIGHT: 'Right',
  VK_UP: 'Up',
  VK_DOWN: 'Down',
  VK_LSHIFT: 'LShift',
  VK_RSHIFT: 'RShift',
  VK_LCONTROL: 'LControl',
  VK_RCONTROL: 'RControl',
  VK_LMENU: 'LAlt',
  VK_RMENU: 'RAlt',
  VK_LWIN: 'Win',
  VK_RWIN: 'RWin',
  VK_CAPITAL: 'CapsLock',
  VK_NUMLOCK: 'NumLock',
  VK_SCROLL: 'ScrollLock',
  VK_SPACE: ' ',
  // Numpad keys share state with regular keys
  VK_NUMPAD0: '0',
  VK_NUMPAD1: '1',
  VK_NUMPAD2: '2',
  VK_NUMPAD3: '3',
  VK_NUMPAD4: '4',
  VK_NUMPAD5: '5',
  VK_NUMPAD6: '6',
  VK_NUMPAD7: '7',
  VK_NUMPAD8: '8',
  VK_NUMPAD9: '9',
  VK_MULTIPLY: '*',
  VK_ADD: '+',
  VK_SUBTRACT: '-',
  VK_DECIMAL: '.',
  VK_DIVIDE: '/',
};

Map<(int, bool), String> defaultKeyCodeShiftMap = {
  (0x30, false): '0',
  (0x30, true): ')',
  (0x31, false): '1',
  (0x31, true): '!',
  (0x32, false): '2',
  (0x32, true): '@',
  (0x33, false): '3',
  (0x33, true): '#',
  (0x34, false): '4',
  (0x34, true): '\$',
  (0x35, false): '5',
  (0x35, true): '%',
  (0x36, false): '6',
  (0x36, true): '^',
  (0x37, false): '7',
  (0x37, true): '&',
  (0x38, false): '8',
  (0x38, true): '*',
  (0x39, false): '9',
  (0x39, true): '(',
  (VK_OEM_COMMA, false): ',',
  (VK_OEM_COMMA, true): '<',
  (VK_OEM_PERIOD, false): '.',
  (VK_OEM_PERIOD, true): '>',
  (VK_OEM_1, false): ';',
  (VK_OEM_1, true): ':',
  (VK_OEM_2, false): '/',
  (VK_OEM_2, true): '?',
  (VK_OEM_4, false): '[',
  (VK_OEM_4, true): '{',
  (VK_OEM_6, false): ']',
  (VK_OEM_6, true): '}',
  (VK_OEM_5, false): '\\',
  (VK_OEM_5, true): '|',
  (VK_OEM_3, false): '`',
  (VK_OEM_3, true): '~',
  (VK_OEM_7, false): "'",
  (VK_OEM_7, true): '"',
  (VK_OEM_PLUS, false): '=',
  (VK_OEM_PLUS, true): '+',
  (VK_OEM_MINUS, false): '-',
  (VK_OEM_MINUS, true): '_',
};

Map<(int, bool), String> activeKeyCodeShiftMap =
    Map<(int, bool), String>.from(defaultKeyCodeShiftMap);

Future<void> loadCustomKeys() async {
  final config = await ConfigService().loadConfig();
  activeKeyCodeShiftMap = Map<(int, bool), String>.from(defaultKeyCodeShiftMap);
  if (config.customKeys != null && config.customKeys!['keyCodeMap'] != null) {
    final rawMap = config.customKeys!['keyCodeMap'] as Map;
    rawMap.forEach((key, value) {
      if (value is int) {
        activeKeyCodeShiftMap[(value, false)] = key.toString();
        activeKeyCodeShiftMap[(value, true)] = key.toString();
      }
    });
  }

  if (config.customKeys != null &&
      config.customKeys!['keyCodeShiftMap'] != null) {
    final rawMap = config.customKeys!['keyCodeShiftMap'] as Map;
    rawMap.forEach((key, value) {
      if (value is int) {
        activeKeyCodeShiftMap[(value, true)] = key.toString();
      }
    });
  }
}

String getKeyFromKeyCodeShift(int keyCode, bool isShiftDown) {
  return activeKeyCodeShiftMap[(keyCode, isShiftDown)] ??
      defaultKeyCodeMap[keyCode] ??
      '';
}
