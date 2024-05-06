import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(height: 100,width: 100,
      child: Lottie.asset("assets/lottie/loading-lottie.json")),
    );
  }
}
