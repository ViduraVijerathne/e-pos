import '../models/customer.dart';
import '../utils/database.dart';

class CustomerSearchController{
  List<String> conditions = [];
  void clear(){
    conditions.clear();
  }

  void searchByName(String name){
    conditions.add(" ${Customer.TABLE_NAME}.${Customer.COLNAME_NAME} LIKE '$name%'");
  }

  void searchByContact(String contact){
    conditions.add(" ${Customer.TABLE_NAME}.${Customer.COLNAME_CONTACT} = '$contact'");
  }

  Future<List<Customer>> getAll()async{
    List<Customer> customers = [];

    var conn = MySQLDatabase().pool;
    var results = await conn.execute("SELECT * FROM `customer` WHERE ${conditions.join(" AND ")}");
    for (var row in results.rows) {
      customers.add(Customer(
        id: int.parse(row.colByName(Customer.COLNAME_ID) as String),
        contact: row.colByName(Customer.COLNAME_CONTACT) as  String,
        name: row.colByName(Customer.COLNAME_NAME) as String,
        address: row.colByName(Customer.COLNAME_ADDRESS)as String,
      ));

    }

    return customers;
  }


}