import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:point_of_sale/screens/home_screen.dart';
import 'package:point_of_sale/screens/setup_screen.dart';
import 'package:point_of_sale/utils/activator.dart';

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

  void login() async{
    setState(() {
      isLoading = true;
    });

    if(AppData.userEmail == _userEmailController.text && AppData.userPassword == _userPasswordController.text){
      await displayInfoBar(context, builder: (context, close) {
        return InfoBar(
          title: const Text('Success!'),
          content: const Text(
              'Successfully Logging!'),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.success,
        );
      });

      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pushReplacement(FluentPageRoute(builder: (context) => HomeScreen(),));
    }else{
      await displayInfoBar(context, builder: (context, close) {
        return InfoBar(
          title: const Text('OOPS..!'),
          content: const Text(
              'Invalid Email or password'),
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
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: ThemeBtn()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
