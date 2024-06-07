import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:point_of_sale/models/users.dart';
import 'package:point_of_sale/providers/login_provider.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/screens/setup_screen.dart';
import 'package:point_of_sale/utils/activator.dart';
import 'package:provider/provider.dart';

import '../utils/app_data.dart';
import '../widget/theme_btn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userPasswordController = TextEditingController();

  void isSetuppedApplication() async {
    bool isSettuped = await Activator().isSetupped();
    if (!isSettuped) {
      Navigator.of(context).push(FluentPageRoute(
        builder: (context) => SetupScreen(),
      ));
    } else {
      await AppData.loadSetupData();
    }
  }

  void showSetup(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => Center(
        child: SizedBox(
          height: 250,
          width: 500,
          child: ContentDialog(
            title: const Text('Warning !'),
            content: Container(
              child: Column(
                children: [
                  Text("You can't access this Setup. Please Contact the Agent for more details.",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(color: Colors.red)),
                  const SizedBox(height: 10,),
                  PasswordBox(
                    placeholder: "Developer Code",
                    controller: controller,
                  )
                ],
              ),

            ),
            actions: [
              Button(
                child: const Text('Show Setup'),
                onPressed: () {
                  if(controller.text == "6jfmd672@V"){
                    Navigator.of(context).push(FluentPageRoute(
                      builder: (context) => SetupScreen(),
                    ));
                  }else{
                    displayInfoBar(context, builder: (context, close) {
                      return InfoBar(
                        title: const Text('OOPS..!'),
                        content: const Text('Invalid Code'),
                        action: IconButton(
                          icon: const Icon(FluentIcons.clear),
                          onPressed: close,
                        ),
                        severity: InfoBarSeverity.error,
                      );
                    });
                    // Delete file here
                  }
                },
              ),
              FilledButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context, 'User canceled dialog'),
              ),
            ],
          ),
        ),
      ),
    );
    setState(() {});
  }

  void showSetup2() {

    Navigator.of(context).push(FluentPageRoute(
      builder: (context) => SetupScreen(),
    ));
  }

  void login() async {
    setState(() {
      isLoading = true;
    });

    Users? user =await Users.login(_userEmailController.text,_userPasswordController.text);

    // if (AppData.userEmail == _userEmailController.text &&
    //     AppData.userPassword == _userPasswordController.text) {
    if(user != null){
      await displayInfoBar(context, builder: (context, close) {
        return InfoBar(
          title: const Text('Success!'),
          content: const Text('Successfully Logging!'),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.success,
        );
      });

      Provider.of<LoginProvider>(context,listen: false).setUser(user);

      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pushReplacement(FluentPageRoute(
        builder: (context) => HomeScreen(),
      ));
    } else {

      // check other user

      await displayInfoBar(context, builder: (context, close) {
        return InfoBar(
          title: const Text('OOPS..!'),
          content: const Text('Invalid Email or password'),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.error,
        );
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    if (mounted) {
      isSetuppedApplication();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: Container(
          width: 500,
          height: 500,
          decoration: BoxDecoration(
            color: FluentTheme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Hero(
                tag: "LOGO",
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Lottie.asset("assets/lottie/logo-lottie.json",
                      reverse: true),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${AppData().appName} Login",
                style: FluentTheme.of(context)
                    .typography
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 300,
                child: InfoLabel(
                  label: "Email",
                  child: TextBox(
                    controller: _userEmailController,
                    placeholder: "Ex : abc@gmail.com",
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                child: InfoLabel(
                  label: "Password",
                  child: PasswordBox(
                    controller: _userPasswordController,
                    placeholder: "password",
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              FilledButton(
                onPressed: login,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: ProgressRing(
                          activeColor: Colors.white,
                        ))
                    : Text(
                        "Next >",
                        style: FluentTheme.of(context)
                            .typography
                            .bodyStrong!
                            .copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                      ),
              ),
              const SizedBox(
                height: 15,
              ),
              // const Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //       padding: const EdgeInsets.only(left: 30),
              //       child: ThemeBtn()),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: ThemeBtn()),
                  Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: IconButton(
                        icon: Icon(FluentIcons.settings),
                        onPressed: () {
                          showSetup( context);
                        },
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
