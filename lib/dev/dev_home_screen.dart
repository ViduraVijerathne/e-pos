import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as WindowsIcons;
import 'package:point_of_sale/dev/add_new_reseller_screen.dart';
import 'package:point_of_sale/dev/dev_login_screen.dart';
import 'package:point_of_sale/dev/dev_profile_screen.dart';
import 'package:point_of_sale/dev/resellers_screen.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/app_data.dart';

class DevHomeScreen extends StatefulWidget {
  const DevHomeScreen({super.key});

  @override
  State<DevHomeScreen> createState() => _DevHomeScreenState();
}

class _DevHomeScreenState extends State<DevHomeScreen> {

  int selectedIndex = 0;

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  PaneItem customPaneItem({required IconData icon,required String title,required Widget body}) {
    return PaneItem(
      icon:  Icon(icon,size: 24,color: FluentTheme.of(context).selectionColor,),
      title: Text(title,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontWeight: FontWeight.w500),),
      body: body,

    );
  }
  @override
  Widget build(BuildContext context) {
    return  NavigationView(
      appBar: NavigationAppBar(
        title: Hero(
          tag: "LOGO",
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Lottie.asset("assets/lottie/logo-lottie.json",),
              ),
              Text("${AppData().appName}",style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontWeight: FontWeight.w700),),
            ],
          ),
        ),


      ),
      pane: NavigationPane(
          displayMode: PaneDisplayMode.compact,
          selected: selectedIndex,
          onChanged: (value) {
            changeIndex(value);
          },
          items: [
            customPaneItem(
              icon: WindowsIcons.FluentIcons.grid_circles_28_filled,
              title: "Add New Resellers",
              body: AddNewResellerScreen(),
            ),
            customPaneItem(
                icon: WindowsIcons.FluentIcons.news_28_filled,
                title: "Resellers",
                body: ResellersScreen()
            ),


          ],
          size: NavigationPaneSize(
            openMaxWidth: 250,
            openMinWidth: 200,
          ),
          footerItems: [

            PaneItemSeparator(),
            customPaneItem(
                icon: WindowsIcons.FluentIcons.settings_24_filled ,
                title: "Profile",
                body: DevProfileScreen()
            ),
            PaneItemAction(
                icon: Icon(WindowsIcons.FluentIcons.sign_out_24_filled, size: 24,),
                title: Text("Logout"),
                onTap: (){
                  Navigator.of(context).pushReplacement(FluentPageRoute(builder: (context) => DevLoginScreen(),));
                }
            ),
            PaneItemAction(
                icon:Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark ?
                Icon(WindowsIcons.FluentIcons.weather_moon_20_regular,size: 24,color: Colors.yellow,) :
                Icon(FluentIcons.sunny,size: 24,color: Colors.black,),
                title: Text("Theme",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontWeight: FontWeight.w700),),
                onTap: (){
                  Provider.of<ThemeProvider>(context,listen: false).toggleTheme();
                }
            ),

          ]

      ),
    );
  }
}
