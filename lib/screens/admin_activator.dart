import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';

import '../constrollers/activation_controller.dart';
import '../widget/theme_btn.dart';
class AdminActivatorScreen extends StatefulWidget {
  const AdminActivatorScreen({super.key});

  @override
  State<AdminActivatorScreen> createState() => _AdminActivatorScreenState();
}

class _AdminActivatorScreenState extends State<AdminActivatorScreen> {
  String ActivationCode = "";
  final TextEditingController _deviceIDController = TextEditingController();
  final TextEditingController _emailCodeController = TextEditingController();
  DateTime expiredDate = DateTime.now();
  bool isLoading = false;
  ActivationController activationController = ActivationController();

  void generateActivationCode()async{
    setState(() {
      isLoading = true;
    });
    ActivationCode = await activationController.generateActivationCode(
      deviceID: _deviceIDController.text,
      Email: _emailCodeController.text,
      expiredDate: expiredDate
    );
    await Future.delayed(Duration(seconds: 3));

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
            height: 700,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FluentTheme.of(context).cardColor,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Lottie.asset("assets/lottie/logo-lottie.json",
                      reverse: true),
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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 250,
                  child: InfoLabel(
                    label: " Enter Device ID",
                    labelStyle: FluentTheme.of(context)
                        .typography
                        .bodyStrong!
                        .copyWith(fontWeight: FontWeight.w700),
                    child: TextBox(
                      placeholder: "Device ID",
                      controller: _deviceIDController,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  child: InfoLabel(
                    label: " Enter Email",
                    labelStyle: FluentTheme.of(context)
                        .typography
                        .bodyStrong!
                        .copyWith(fontWeight: FontWeight.w700),
                    child: TextBox(
                      placeholder: "Email",
                      controller: _emailCodeController,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 250,
                  child: InfoLabel(
                    label: "Activation Code Expired Date",
                    labelStyle: FluentTheme.of(context)
                        .typography
                        .bodyStrong!
                        .copyWith(fontWeight: FontWeight.w700),
                    child: DatePicker(
                      selected:expiredDate,
                      onChanged: (value) {
                        setState(() {
                          expiredDate = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                FilledButton(
                  onPressed:generateActivationCode,
                  child: isLoading ? const ProgressRing(): const Text("Generate Code"),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 250,
                  child: InfoLabel(
                    label: ActivationCode.isEmpty ? "" : "Activation Code",
                    labelStyle: FluentTheme.of(context)
                        .typography
                        .bodyStrong!
                        .copyWith(fontWeight: FontWeight.w700),
                    child: SelectableText(
                      ActivationCode,
                      style: FluentTheme.of(context).typography.bodyStrong!.copyWith(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
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
