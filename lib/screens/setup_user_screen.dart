import 'package:firedart/auth/user_gateway.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:point_of_sale/main.dart';
import 'package:point_of_sale/models/users.dart';
import 'package:point_of_sale/utils/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_data.dart';
import '../widget/theme_btn.dart';

class SetupUserDetailsScreen extends StatefulWidget {
  const SetupUserDetailsScreen({super.key});

  @override
  State<SetupUserDetailsScreen> createState() => _SetupUserDetailsScreenState();
}

class _SetupUserDetailsScreenState extends State<SetupUserDetailsScreen> {
  bool isLoading = false;
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _userPasswordController = TextEditingController();

  void nextSetup()async{
    setState(() {
      isLoading = true;
    });
    List<UserAccess> access =UserAccess.values;
   Users u = Users(id: 0, username: _userNameController.text, email: _userEmailController.text, password: _userPasswordController.text, accesses: access);

   try{

     await AppData.loadSetupData();

     await u.add();

     final SharedPreferences prefs = await SharedPreferences.getInstance();
     // prefs.setString("userEmail", _userEmailController.text);
     // prefs.setString("userName", _userNameController.text);
     // prefs.setString("userPassword", _userPasswordController.text);
     prefs.setBool("isSetupped", true);
     Navigator.of(context).push(FluentPageRoute(builder: (context) => MainWrapper(),));
   }catch(ex){
     print(ex);
     await u.update();
     await displayInfoBar(context, builder: (context, close) {
       return InfoBar(
         title: const Text('User already exist! Updated user'),
         content: const Text('User already exist!'),
         action: IconButton(
           icon: const Icon(FluentIcons.clear),
           onPressed: close,
         ),
         severity: InfoBarSeverity.warning,
       );
     });
   }



    setState(() {
      isLoading = false;
    });

  }

  void prevSetup(){
    Navigator.of(context).pop();
  }

  void loadData()async{
    await AppData.loadSetupData();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userEmailController.text = prefs.getString("userEmail")?? "";
    _userNameController.text = prefs.getString("userName")?? "";
    _userPasswordController.text = prefs.getString("userPassword")?? "";
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Center(
        child: Container(
          width: 500,
          height: 600,
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
                "${AppData().appName} Shop Details Setup",
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
                  label: "User Email",
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
                  label: "Username ",
                  child: TextBox(
                    controller: _userNameController,
                    // controller: _dbPORTController,
                    placeholder: "Ex : John Doe",
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
                  child: TextBox(
                    controller: _userPasswordController,
                    placeholder: "Ex : xxxxxxxxx",
                  ),
                ),
              ),



              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: FilledButton(
                      onPressed: prevSetup,
                      style:ButtonStyle(
                          backgroundColor: ButtonState.all(Colors.red)
                      ),
                      child: isLoading ?  const SizedBox(height: 20,width:20,child:  ProgressRing( activeColor: Colors.white,)) : Text(
                        "< Prev",
                        style: FluentTheme.of(context)
                            .typography
                            .bodyStrong!
                            .copyWith(
                            fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: FilledButton(
                      onPressed: nextSetup,
                      child: isLoading ?  const SizedBox(height: 20,width:20,child:  ProgressRing( activeColor: Colors.white,)) : Text(
                        "Next >",
                        style: FluentTheme.of(context)
                            .typography
                            .bodyStrong!
                            .copyWith(
                            fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15,),
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
