import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:point_of_sale/utils/app_data.dart';

import '../utils/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: bgDarkColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: "LOGO",
              child: SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset("assets/lottie/logo-lottie.json",
                    reverse: true),
              ),
            ),
            Text(AppData().appName,style: FluentTheme.of(context).typography.title!.copyWith(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
