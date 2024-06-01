import 'package:point_of_sale/utils/database.dart';

import '../models/supplier.dart';

class SupplierSearchController{
  List<String> conditions = [];
  void clear(){
    conditions.clear();
  }

  void searchByName(String name){
    conditions.add(" ${Supplier.TABLE_NAME}.${Supplier.COLNAME_NAME} LIKE '$name%'");
  }

  void searchByEmail(String email){
    conditions.add(" ${Supplier.TABLE_NAME}.${Supplier.COLNAME_EMAIL} LIKE '$email%'");
  }

  void searchByContact(String contact) {
    conditions.add(" ${Supplier.TABLE_NAME}.${Supplier.COLNAME_CONTACT} LIKE '$contact%'");
  }


  Future<List<Supplier>> getAll()async{
    var conn = MySQLDatabase().pool;
    var result = await conn.execute("SELECT * FROM `suppliers` WHERE ${conditions.join(" AND ")}");

    List<Supplier> suppliers = [];
    for (var row in result.rows) {
      int id = int.parse(row.colByName(Supplier.COLNAME_ID)!);
      String name = row.colByName(Supplier.COLNAME_NAME)!;
      String contact = row.colByName(Supplier.COLNAME_CONTACT)!;
      String email = row.colByName(Supplier.COLNAME_EMAIL)!;
      String bankDetails = row.colByName(Supplier.COLNAME_BANK_DETAILS)!;

      suppliers.add(Supplier(id: id,name: name,contact: contact,email: email,bankDetails: bankDetails));
    }
    return suppliers;
  }


}