import 'package:mysql_client/mysql_client.dart';

import '../utils/app_data.dart';

class Supplier{
  final int id;
   String name;
  String contact;
   String email;
  String bankDetails;

  Supplier({required this.id,required this.name,required this.contact,required this.email,required this.bankDetails});


  static const String COLNAME_ID = "supplier_id";
  static const String COLNAME_NAME = "name";
  static const String COLNAME_CONTACT = "contact";
  static const String COLNAME_EMAIL = "email";
  static const String COLNAME_BANK_DETAILS = "bank_acount_details";
  static const String TABLE_NAME = "suppliers";
 static const String SELECTQUERY = "SELECT * FROM $TABLE_NAME";
 static const String INSERTQUERY = "INSERT INTO `suppliers` (`name`, `contact`, `email`, `bank_acount_details`) VALUES (?,?,?, ?)";
static const String UPDATEQUERY = "UPDATE `suppliers` SET `name`=?, `contact`=?, `email`=?, `bank_acount_details`=? WHERE  `supplier_id`=?;";
  static Future<List<Supplier>> getAll()async {
    List<Supplier> suppliers = [];
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );
    await conn.connect();
    var results = await conn.execute(SELECTQUERY);
    for (var row in results.rows) {
      int id = int.parse(row.colByName(COLNAME_ID)!);
      String name = row.colByName(COLNAME_NAME)!;
      String contact = row.colByName(COLNAME_CONTACT)!;
      String email = row.colByName(COLNAME_EMAIL)!;
      String bankDetails = row.colByName(COLNAME_BANK_DETAILS)!;

      suppliers.add(Supplier(id: id,name: name,contact: contact,email: email,bankDetails: bankDetails));
    }
    conn.close();
    return suppliers;
  }

  Future<void> insert()async{
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );
    await conn.connect();
    var stmt = await conn.prepare(INSERTQUERY);
    await stmt.execute([name,contact,email,bankDetails]);
    await conn.close();


  }
  Future<void> update()async{
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );
    await conn.connect();
    var stmt = await conn.prepare(UPDATEQUERY);
    await stmt.execute([name,contact,email,bankDetails,id]);
    await conn.close();


  }


}