import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:point_of_sale/constrollers/activation_controller.dart';
import 'package:point_of_sale/main.dart';
import 'package:point_of_sale/providers/theme_provider.dart';
import 'package:provider/provider.dart';

import '../utils/method_response.dart';
import '../utils/pc_info.dart';
import '../widget/theme_btn.dart';

class ActivationScreen extends StatefulWidget {
  const ActivationScreen({super.key});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  String deviceId = "";
  TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  void loadDeviceID() async {
    deviceId = await PCInfo().getDeviceID();
    setState(() {});
  }

  @override
  void initState() {
    if (mounted) {
      loadDeviceID();
    }
    super.initState();
  }

  void activateAccount()async{
    setState(() {
      isLoading = true;
    });
    MethodResponse<dynamic> result =await ActivationController().activate(deviceID: deviceId,code: _controller.text);
    if(result.isSuccess){
      await displayInfoBar(context, builder: (context, close) {
        return InfoBar(
          title: const Text('Successful Activation'),
          content: const Text(
              'Activation is successfull! '),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.success,
        );
      });
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pushReplacement(FluentPageRoute(builder: (context) => MainWrapper(),));
    }else{
      await displayInfoBar(context, builder: (context, close) {
        return InfoBar(
          title: const Text('Activation Failed'),
          content:  Text(
              result.message),
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
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FluentTheme.of(context).cardColor,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Hero(
                  tag: "HERO",
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
                  "Please Activate Your Account",
                  style: FluentTheme.of(context)
                      .typography
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Your Device ID is ",
                  style: FluentTheme.of(context)
                      .typography
                      .bodyStrong!
                      .copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                SelectableText(
                  deviceId,
                  style: FluentTheme.of(context)
                      .typography
                      .bodyStrong!
                      .copyWith(fontWeight: FontWeight.w700, color: Colors.red),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  child: InfoLabel(
                    label: "Enter Your Activation Code",
                    child: TextBox(
                      controller: _controller,
                      placeholder: "Activation Code",
                    ),
                    labelStyle: FluentTheme.of(context)
                        .typography
                        .bodyStrong!
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FilledButton(
                  onPressed: activateAccount,
                  child: isLoading? const ProgressRing() : const Text("Activate"),
                ),
               const SizedBox(height: 70,),
               const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ThemeBtn()
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
