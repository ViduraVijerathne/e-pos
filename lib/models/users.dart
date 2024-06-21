import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/utils/app_data.dart';
import 'package:point_of_sale/utils/database.dart';

class Users{
  int id;
  String username;
  String email;
  String password;
  List<UserAccess> accesses;
  Users({required this.id,required this.username,required this.email,required this.password,required this.accesses});

// Convert UserAccess enum to list of strings
  static List<String> _accessesToJson(List<UserAccess> accesses) {
    return accesses.map((access) => access.toString().split('.').last).toList();
  }

  // Convert list of strings to UserAccess enum
  static List<UserAccess> _accessesFromJson(String x) {
    String cleanedString = x.substring(1, x.length - 1);

    // Split the string by commas and trim any extra whitespace
    List<String> accesses = cleanedString.split(',').map((s) => s.trim()).toList();
    return accesses.map((access) => UserAccess.values.firstWhere((e) => e.toString().split('.').last == access)).toList();
  }

  static Future<bool> isExist(Users user)async{
    var con = MySQLDatabase().pool;
    String q = "SELECT * FROM users WHERE users.email = '${user.email}' OR users.userName = '${user.username}'";

    var result= await con.execute(q);
    if(result.rows.isEmpty){
      return true;
    }
    return false;

  }

  Future<void> add()async{
    if(!await isExist(this)){
      var con = MySQLDatabase().pool;
      // final con = await MySQLConnection.createConnection(
      //   host: AppData.dbURL,
      //   port: AppData.dbPORT,
      //   userName: AppData.dbUser,
      //   password: AppData.dbPassword,
      //   databaseName: AppData.dbName, // op
      //   // secure: false,
      // );
      // con.connect();
      String q = "SELECT * FROM users WHERE users.email = '${email}' OR users.userName = '${username}'";

      var result= await con.execute(q);
      if(result.rows.isNotEmpty){
        id = int.parse(result.rows.first.colByName("id") as String);
      }

      print("EXIST");
      throw Exception("User already exists");
    }
    // final con = await MySQLConnection.createConnection(
    //   host: AppData.dbURL,
    //   port: AppData.dbPORT,
    //   userName: AppData.dbUser,
    //   password: AppData.dbPassword,
    //   databaseName: AppData.dbName, // op
    //   // secure: false,
    // );
    // con.connect();
    var con = MySQLDatabase().pool;
    print(AppData.dbUser);
    print(AppData.dbPassword);
    String q = "INSERT INTO users (userName, email, password, users.auths) VALUES ('${username}', '${email}', '${password}', '${_accessesToJson(accesses)}')";
    await con.execute(q);
  }


  Future<void> update()async{

    var con = MySQLDatabase().pool;
    String q = "UPDATE users SET users.userName = '${username}', users.email = '${email}', users.password = '${password}', users.auths = '${_accessesToJson(accesses)}' WHERE users.id = $id";
    await con.execute(q);
  }

 static Future<List<Users>> getAll()async{
    List<Users> users = [];
    var con = MySQLDatabase().pool;
    String q = "SELECT * FROM users";
    var result = await con.execute(q);
    if(result.rows.isNotEmpty){
      for(var row in result.rows){
        users.add(Users(
          id: int.parse(row.colByName("id") as String),
          username: row.colByName("userName") as String,
          email: row.colByName("email") as String,
          password: row.colByName("password") as String,
          accesses: _accessesFromJson(row.colByName("auths") as String),
        ));
      }
    }
    return users;
  }

 static Future<Users?> login(String email,String password)async{
   var con = MySQLDatabase().pool;
   String q = "SELECT * FROM users WHERE users.email = '${email}' AND users.password = '${password}'";
   var result = await con.execute(q);
   if(result.rows.isNotEmpty){
     return Users(
       id: int.parse(result.rows.first.colByName("id") as String),
       username: result.rows.first.colByName("userName") as String,
       email: result.rows.first.colByName("email") as String,
       password: result.rows.first.colByName("password") as String,
       accesses: _accessesFromJson(result.rows.first.colByName("auths") as String),
     );
   }
   return null;
 }

 bool hasAccess(UserAccess access){
   return accesses.contains(access);
 }

}

enum UserAccess{
  DASHBOARD,
  SELLPRODUCT,
  ADDPRODUCT,
  VIEWPRODUCTS,
  ADDGRN,
  VIEWGRN,
  STOCK,
  ADDSUPPLIER,
  VIEWSUPPLIERS,
  ADDCUSTOMERS,
  VIEWCUSTOMERS,
  VIEWINVOICE,
  USERMANAGEMENT,
}