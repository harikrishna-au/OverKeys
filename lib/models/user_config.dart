import 'keyboard_layouts.dart';

class UserConfig {
  String? defaultUserLayout;
  String? altLayout;
  String? customFont;
  List<KeyboardLayout>? userLayouts;
  Map<String, String> customShiftMappings;
  String? kanataHost;
  int? kanataPort;

  UserConfig({
    this.defaultUserLayout,
    this.altLayout,
    this.customFont,
    this.userLayouts,
    Map<String, String>? customShiftMappings,
    this.kanataHost,
    this.kanataPort,
  }) : customShiftMappings = customShiftMappings ?? {};

  factory UserConfig.fromJson(Map<String, dynamic> json) {
    List<KeyboardLayout> userLayouts = [];
    if (json['userLayouts'] != null) {
      for (var userLayout in json['userLayouts']) {
        userLayouts.add(KeyboardLayout(
          name: userLayout['name'],
          keys: List<List<String>>.from(
            userLayout['keys'].map((row) => List<String>.from(row)),
          ),
          trigger: userLayout['trigger'],
          type: userLayout['type'],
        ));
      }
    }

    Map<String, String> customShiftMappings = {};
    if (json['customShiftMappings'] != null) {
      customShiftMappings =
          Map<String, String>.from(json['customShiftMappings']);
    }

    return UserConfig(
      defaultUserLayout: json['defaultUserLayout'],
      altLayout: json['altLayout'],
      customFont: json['customFont'],
      userLayouts: userLayouts,
      customShiftMappings: customShiftMappings,
      kanataHost: json['kanataHost'],
      kanataPort: json['kanataPort'] != null ? json['kanataPort'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> userLayoutsJson = userLayouts != null
        ? userLayouts!
            .map((userLayout) => {
                  'name': userLayout.name,
                  'keys': userLayout.keys,
                  if (userLayout.trigger != null) 'trigger': userLayout.trigger,
                  if (userLayout.type != null) 'type': userLayout.type,
                })
            .toList()
        : [];

    return {
      if (defaultUserLayout != null) 'defaultUserLayout': defaultUserLayout,
      if (altLayout != null) 'altLayout': altLayout,
      if (customFont != null) 'customFont': customFont,
      if (userLayoutsJson.isNotEmpty) 'userLayouts': userLayoutsJson,
      if (customShiftMappings.isNotEmpty) 'customShiftMappings': customShiftMappings,
      if (kanataHost != null) 'kanataHost': kanataHost,
      if (kanataPort != null) 'kanataPort': kanataPort,
    };
  }
}
