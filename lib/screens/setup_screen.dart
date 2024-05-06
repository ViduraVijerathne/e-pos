import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:mysql_client/exception.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/screens/setup_add_shop_details.dart';
import 'package:point_of_sale/utils/app_data.dart';
import 'package:point_of_sale/widget/theme_btn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  TextEditingController _dbURLcontroller = TextEditingController();
  TextEditingController _dbPORTController = TextEditingController();
  TextEditingController _dbNameController = TextEditingController();
  TextEditingController _dbUserController = TextEditingController();
  TextEditingController _dbPasswordController = TextEditingController();
  bool isLoading = false;

  void loadData(){
    _dbURLcontroller.text = "localhost";
    _dbPORTController.text = "3306";
    _dbNameController.text = "pos";
    _dbUserController.text = "root";
    _dbPasswordController.text = "root";
    if(mounted){
      setState(() {});
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void showErrorMessage(String title, String body)async{
    await displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title:  Text(title),
        content:  Text(body),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: InfoBarSeverity.error,
      );
    });
  }

  void nextSetup()async{
    setState(() {
      isLoading = true;
    });
    try{
      final conn = await MySQLConnection.createConnection(
        host: _dbURLcontroller.text,
        port: int.parse(_dbPORTController.text),
        userName: _dbUserController.text,
        password: _dbPasswordController.text,
        databaseName:_dbNameController.text, // optional
      );
      await conn.connect();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("dbURL", _dbURLcontroller.text);
      prefs.setInt("port", int.parse(_dbPORTController.text));
      prefs.setString("user", _dbUserController.text);
      prefs.setString("password", _dbPasswordController.text);
      prefs.setString("db", _dbNameController.text);

      Navigator.of(context).push(FluentPageRoute(builder: (context) => SetupAddShopDetailsScreen(),));
      
      
    }catch(ex){
      if(ex is SocketException){
        showErrorMessage("Database Connection Failed! ", ex.message);
      }else if(ex is MySQLServerException){
        showErrorMessage("Database Connection Failed! ", ex.message);
      }else{
        showErrorMessage("User Input Failed !", "Please check input again!");
      }
      print(ex);
    }

    setState(() {
      isLoading = false;
    });
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
                "${AppData().appName} Setup",
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
                  label: "Database URL",
                  child: TextBox(
                    controller: _dbURLcontroller,
                    placeholder: "Ex : localhost",
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                child: InfoLabel(
                  label: "Database PORT",
                  child: TextBox(
                    controller: _dbPORTController,
                    placeholder: "Ex : 3306",
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                child: InfoLabel(
                  label: "Database Name",
                  child: TextBox(
                    controller: _dbNameController,
                    placeholder: "Ex : pos_db",
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                child: InfoLabel(
                  label: "Database username",
                  child: TextBox(
                    controller: _dbUserController,
                    placeholder: "Ex : root",
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 300,
                child: InfoLabel(
                  label: "Database password",
                  child: TextBox(
                    controller: _dbPasswordController,
                    placeholder: "Ex : root",
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
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
              ),
              Align(
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







