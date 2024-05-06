import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as winIcon;
class ThemeBtn extends StatelessWidget {
  const ThemeBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Provider.of<ThemeProvider>(context,listen: false).toggleTheme();
      },
      icon: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark ?
      Icon(winIcon.FluentIcons.weather_moon_20_regular,size: 24,color: Colors.yellow,) :
      Icon(FluentIcons.sunny,size: 24,color: Colors.black,),
    );
  }
}
