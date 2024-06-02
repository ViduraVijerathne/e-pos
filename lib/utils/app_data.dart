import 'package:shared_preferences/shared_preferences.dart';

class AppData{
  String appName = "E-POS";
  String companyName = "Andromeda Software Solutions";
  String appVersion = "1.0.0 MainLine Offline Edition";
  
 static String firebaseApiKey=  "AIzaSyAeGloicMEC-9v3GP2BapRadtKsSy4J-L8";
  static String firebaseAuthDomain= "point-of-sales-66f61.firebaseapp.com";
  static String firebaseProjectId= "point-of-sales-66f61";
  static String firebaseStorageBucket= "point-of-sales-66f61.appspot.com";
  static String firebaseMessagingSenderId= "7732674388";
  static String firebaseAppId =  "1:7732674388:web:7009471ca46be43906d2c1";

  static String dbURL = "localhost";
  static int dbPORT = 3306;
  static String dbName = "pos_db";
  static String dbUser = "root";
  static String dbPassword = "root";

  static String shopName = "ABC";
  static String shopAddress = "ABC, XYZ, 12345";
  static String shopContact1 = "+94123456789";
  static String shopContact2 = "+94123456789";
  static String shopEmail = "abc@gmail.com";

  static String userName = "John Doe";
  static String userEmail = "abc@gmail.com";
  static String userPassword = "password";

  static Future<void> loadSetupData() async{
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   AppData.dbURL = prefs.getString("dbURL") ?? "localhost";
   AppData.dbPORT = prefs.getInt("port") ?? 3306;
   AppData.dbName = prefs.getString("db") ?? "pos_db";
   AppData.dbUser = prefs.getString("user") ?? "root";
   AppData.dbPassword = prefs.getString("password") ?? "root";

   AppData.shopName = prefs.getString("shopName") ?? "ABC";
   AppData.shopAddress = prefs.getString("shopAddress") ?? "ABC, XYZ, 12345";
   AppData.shopContact1 = prefs.getString("shopContact1") ?? "+94123456789";
   AppData.shopContact2 = prefs.getString("shopContact2") ?? "+94123456789";
   AppData.shopEmail = prefs.getString("shopEmail") ?? "abc@gmail.com";

   AppData.userName = prefs.getString("userName") ?? "John Doe";
   AppData.userEmail = prefs.getString("userEmail") ?? "abc@gmail.com";
   AppData.userPassword = prefs.getString("userPassword") ?? "password";

   print('dbURL: ${AppData.dbURL}');
   print('dbPORT: ${AppData.dbPORT}');
   print('dbName: ${AppData.dbName}');
   print('dbUser: ${AppData.dbUser}');
   print('dbPassword: ${AppData.dbPassword}');

   print('shopName: ${AppData.shopName}');
   print('shopAddress: ${AppData.shopAddress}');
   print('shopContact1: ${AppData.shopContact1}');
   print('shopContact2: ${AppData.shopContact2}');
   print('shopEmail: ${AppData.shopEmail}');

   print('userName: ${AppData.userName}');
   print('userEmail: ${AppData.userEmail}');
   print('userPassword: ${AppData.userPassword}');



  }

}