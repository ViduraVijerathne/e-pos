import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:point_of_sale/screens/setup_user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_data.dart';
import '../widget/theme_btn.dart';

class SetupAddShopDetailsScreen extends StatefulWidget {
  const SetupAddShopDetailsScreen({super.key});

  @override
  State<SetupAddShopDetailsScreen> createState() => _SetupAddShopDetailsScreenState();
}

class _SetupAddShopDetailsScreenState extends State<SetupAddShopDetailsScreen> {
  bool isLoading = false;
  TextEditingController _shopNameController = TextEditingController();
  TextEditingController _shopAddressController = TextEditingController();
  TextEditingController _shopEmailController = TextEditingController();
  TextEditingController _shopContact1Controller = TextEditingController();
  TextEditingController _shopContact2Controller = TextEditingController();

  void nextSetup()async{
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("shopName", _shopNameController.text);
    prefs.setString("shopAddress", _shopAddressController.text);
    prefs.setString("shopEmail", _shopEmailController.text);
    prefs.setString("shopContact1", _shopContact1Controller.text);
    prefs.setString("shopContact2", _shopContact2Controller.text);

    Navigator.of(context).push(FluentPageRoute(builder: (context) => SetupUserDetailsScreen(),));
    setState(() {
      isLoading = false;
    });

  }

  void prevSetup(){
    Navigator.of(context).pop();
  }

  void loadData()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _shopNameController.text = prefs.getString("shopName")?? "";
    _shopAddressController.text = prefs.getString("shopAddress")?? "";
    _shopEmailController.text = prefs.getString("shopEmail")?? "";
    _shopContact1Controller.text = prefs.getString("shopContact1")?? "";
    _shopContact2Controller.text = prefs.getString("shopContact2")?? "";
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
                  label: "Shop Name",
                  child: TextBox(
                    controller: _shopNameController,
                    // controller: _dbURLcontroller,
                    placeholder: "Ex : Abc Super Center",
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                child: InfoLabel(
                  label: "Shop Address",
                  child: TextBox(
                    controller: _shopAddressController,
                    // controller: _dbPORTController,
                    placeholder: "Ex : 123, ABC, XYZ, 12345",
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                child: InfoLabel(
                  label: "Shop Contact 1",
                  child: TextBox(
                    controller: _shopContact1Controller,
                    // controller: _dbURLcontroller,
                    placeholder: "Ex : +94123456789",
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                child: InfoLabel(
                  label: "Shop Contact 2",
                  child: TextBox(
                    controller: _shopContact2Controller,
                    // controller: _dbURLcontroller,
                    placeholder: "Ex : +94123456789",
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                child: InfoLabel(
                  label: "Email Address",
                  child: TextBox(
                    // controller: _dbURLcontroller,
                    controller: _shopEmailController,
                    placeholder: "Ex : abc@gmail.com",
                  ),
                ),
              ),



              SizedBox(height: 20,),
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
