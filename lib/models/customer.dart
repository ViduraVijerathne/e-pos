import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/utils/database.dart';

import '../utils/app_data.dart';

class Customer {
  final int id;
   String name;
   String contact;
   String address;

  Customer(
      {required this.id,
      required this.name,
      required this.contact,
      required this.address});

  static const String COLNAME_ID = "customer_id";
  static const String COLNAME_NAME = "name";
  static const String COLNAME_CONTACT = "mobile";
  static const String COLNAME_ADDRESS = "address";
  static const String TABLE_NAME = "customer";

  static const String INSERTQUERY =
      "INSERT INTO `e-pos`.`customer` (`name`, `mobile`, `address`) VALUES (?,?,?)";

  static const String UPDATEQUERY = "UPDATE `customer` SET `name`=?, `mobile`=?, `address`=? WHERE  `customer_id`=?";
  static const String SELECTQUERY = "SELECT * FROM `customer` ";
  static const String SELECTBYIDQUERY = "SELECT * FROM `customer` where `customer_id`=:ID";
  static const String SELECTBYMOBILEQUERY = "SELECT * FROM `customer` where `mobile`=:mobile";
  Future<void> insert() async {
    //   INSERT INTO `e-pos`.`customer` (`name`, `mobile`, `address`) VALUES ('s', 'm', 'a');

    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );
    await conn.connect();
    var stmt = await conn.prepare(INSERTQUERY);
    await stmt.execute([name, contact, address]);
    await conn.close();
  }
  Future<Customer> insertAndGetCustomer() async {
    //   INSERT INTO `e-pos`.`customer` (`name`, `mobile`, `address`) VALUES ('s', 'm', 'a');

    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );
    await conn.connect();
    var stmt = await conn.prepare(INSERTQUERY);
    var result  = await stmt.execute([name, contact, address]);
    await conn.close();
    var id =  result.lastInsertID;
    Customer customer = Customer(
      id: id.toInt(),
      contact: contact,
      name: name,
      address:address,
    );
    return customer;
  }

  Future<void> update() async {
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );
    await conn.connect();
    var stmt = await conn.prepare(UPDATEQUERY);
    await stmt.execute([name, contact, address,id]);
    await conn.close();
  }

  static Future<List<Customer>> getAll({int limit = 5})async{
    List<Customer> customers = [];
    final conn =MySQLDatabase().pool;
    var s =   "$SELECTQUERY LIMIT $limit";

    var results  = await conn.execute(s);
    for (var row in results.rows) {
      customers.add(Customer(
        id: int.parse(row.colByName(COLNAME_ID) as String),
        contact: row.colByName(COLNAME_CONTACT) as  String,
        name: row.colByName(COLNAME_NAME) as String,
        address: row.colByName(COLNAME_ADDRESS)as String,
      ));

    }
    return customers;

  }

  static Future<Customer> getByID(String id)async{
    final conn =MySQLDatabase().pool;
    var result = await conn.execute(SELECTBYIDQUERY,{"ID":id});
    Customer customer = Customer(
      id: int.parse(result.rows.first.colByName(COLNAME_ID) as String),
      contact: result.rows.first.colByName(COLNAME_CONTACT) as  String,
      name: result.rows.first.colByName(COLNAME_NAME) as String,
      address: result.rows.first.colByName(COLNAME_ADDRESS)as String,
    );
    return customer;

  }

  static Future<List<Customer>> search(String text)async{
    List<Customer> customers = [];
    final conn = MySQLDatabase().pool;
    var result = await conn.execute("SELECT * FROM customer WHERE name LIKE '%${text}%' OR mobile LIKE '%${text}%' OR address LIKE '%${text}%' LIMIT 5");

    for (var row in result.rows) {
      customers.add(Customer(
        id: int.parse(row.colByName(COLNAME_ID) as String),
        contact: row.colByName(COLNAME_CONTACT) as  String,
        name: row.colByName(COLNAME_NAME) as String,
        address: row.colByName(COLNAME_ADDRESS)as String,
      ));
    }

    return customers;
  }

  static Future<Customer?> getByMobile(String mobile)async{
    final conn =MySQLDatabase().pool;
    var result = await conn.execute(SELECTBYMOBILEQUERY,{"mobile":mobile});
    if(result.rows.isEmpty){
      print("null customer");
      return null;
    }
    print("not null");
    Customer customer = Customer(
      id: int.parse(result.rows.first.colByName(COLNAME_ID) as String),
      contact: result.rows.first.colByName(COLNAME_CONTACT) as  String,
      name: result.rows.first.colByName(COLNAME_NAME) as String,
      address: result.rows.first.colByName(COLNAME_ADDRESS)as String,
    );
    conn.close();
    return customer;
  }
}
