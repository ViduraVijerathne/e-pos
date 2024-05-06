import 'package:device_info_plus/device_info_plus.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/token_store.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/providers/theme_provider.dart';
import 'package:point_of_sale/screens/activation_screen.dart';
import 'package:point_of_sale/screens/admin_activator.dart';
import 'package:point_of_sale/screens/login_screen.dart';
import 'package:point_of_sale/screens/spash_screen.dart';
import 'package:point_of_sale/utils/activator.dart';
import 'package:point_of_sale/utils/app_colors.dart';
import 'package:point_of_sale/utils/app_data.dart';
import 'package:point_of_sale/utils/pc_info.dart';
import 'package:provider/provider.dart';

void main(){
  // runApp(const MyApp());
  Firestore.initialize(AppData.firebaseProjectId);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider(),)
    ],
    // child: AdminActivatorScreen(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      theme: FluentThemeData.light().copyWith(
        // scaffoldBackgroundColor: bgLightColor,
        // cardColor: secondaryLightColor,
        accentColor: Colors.blue,
      ),
      darkTheme: FluentThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgDarkColor,
        cardColor: secondaryDarkColor,
        accentColor: Colors.blue,

      ),
      themeMode: Provider.of<ThemeProvider>(context).themeMode,

      home: MainWrapper(),
      // home: AdminActivatorScreen(),
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  bool isActiveCopy = false;
  bool isLoadingIsActiveCopy = true;
  Widget body = const SplashScreen();

  void loadIsActiveCopyData()async{
    await Future.delayed(const Duration(seconds: 5));
    isActiveCopy = await Activator().isActive();
    if(isActiveCopy){
      body = const LoginScreen();
    }else{
      body = const ActivationScreen();
    }
    if(mounted){
      setState(() {
        isLoadingIsActiveCopy = false;
      });
    }
  }
  @override
  void initState() {
    loadIsActiveCopyData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return body;
  }
}
