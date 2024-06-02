
import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:point_of_sale/dev/dev_home_screen.dart';

class DevLoginScreen extends StatefulWidget {
  const DevLoginScreen({super.key});

  @override
  State<DevLoginScreen> createState() => _DevLoginScreenState();
}

class _DevLoginScreenState extends State<DevLoginScreen> {
  TextEditingController controller = TextEditingController();
  void showMessage(String title,String body ,InfoBarSeverity severity)async{
    await displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title:  Text(title),
        content:  Text(body),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity:severity,
      );
    });
  }
  void login(){
    if(controller.text == "5685680"){
      Navigator.of(context).push(FluentPageRoute(builder: (context) => DevHomeScreen(),));
    }else{
      showMessage("Login Failed","Invalid Password",InfoBarSeverity.error);
      controller.text = "";
      setState(() {

      });
    }

  }
  Widget roundButton(String value ){
    return Button(
      style: ButtonStyle(
        shape: ButtonState.all(LinearBorder.none),
        backgroundColor: ButtonState.all(FluentTheme.of(context).cardColor),
      ),
      onPressed: (){
        if(value == "CLEAR"){
          controller.clear();
        }else if(value == "ENTER"){
          login();
        }else{
          controller.text = controller.text + value;
        }
        setState(() {

        });
      },
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          color: FluentTheme.of(context).accentColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100)
        ),
        child: Center(child: Text(value,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 20),)),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: Lottie.asset("assets/lottie/logo-lottie.json",
              reverse: true),
        ),
      ),
      content: Center(
        child: Container(
          height: 500,
          width: 500,
          decoration: BoxDecoration(
            color: FluentTheme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10)
          ),
          child:  Column(
            children: [
              SizedBox(height: 20,),
              Text("Developer Login",style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontWeight: FontWeight.w700),),
              SizedBox(height: 20,),
              SizedBox(
                width: 300,
                child: PasswordBox(
                  autofocus: true,
                  controller: controller,
                  onSubmitted: (value) {
                    login();
                  },
                  placeholder: "Enter Pin",
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Expanded(child:roundButton("7") ),
                    Expanded(child:roundButton("8") ),
                    Expanded(child:roundButton("9") ),

                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Expanded(child:roundButton("4") ),
                    Expanded(child:roundButton("5") ),
                    Expanded(child:roundButton("6") ),

                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Expanded(child:roundButton("1") ),
                    Expanded(child:roundButton("2") ),
                    Expanded(child:roundButton("3") ),

                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: Row(
                  children: [
                    Expanded(child:roundButton("CLEAR") ),
                    Expanded(child:roundButton("0") ),
                    Expanded(child:roundButton("ENTER") ),

                  ],
                ),
              )
            ],
          ),
          
        ),
      ),
    );
  }
}

