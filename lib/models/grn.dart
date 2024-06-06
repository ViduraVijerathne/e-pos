import 'package:mysql_client/mysql_client.dart';
import 'package:point_of_sale/models/product.dart';
import 'package:point_of_sale/models/sub_category.dart';
import 'package:point_of_sale/models/supplier.dart';
import 'package:point_of_sale/models/unit.dart';

import '../utils/app_data.dart';
import '../utils/database.dart';
import 'main_category.dart';

class GRN{
   int id;
  final String barcode;
  final Product product;
  final Supplier supplier;
  final double quantity;
  final double wholesalePrice;
  final double retailPrice;
  final double value;
  final double paidAmount;
  final double douedAmount;
  final DateTime mnfDate;
  final DateTime expDate;
  final String description;
  final DateTime grnDate;

  GRN({required this.id,required this.barcode,required this.product,required this.supplier,required this.quantity,
  required this.wholesalePrice,required this.retailPrice,required this.value,required this.paidAmount,required this.douedAmount,
  required this.mnfDate,required this.expDate,required this.description,required this.grnDate
  });


  static const String COLNAME_ID = "grn_id";
  static const String COLNAME_BARCODE = "barcode";
  static const String COLNAME_PRODUCT = "product_product_id";
  static const String COLNAME_SUPPLIER = "suppliers_supplier_id";
  static const String COLNAME_QUANTITY = "grnqty";
  static const String COLNAME_WHOLESALE_PRICE = "wholesale_price";
  static const String COLNAME_RETAIL_PRICE = "retail_price";
  static const String COLNAME_VALUE = "value";
  static const String COLNAME_PAID_AMOUNT = "paid_amount";
  static const String COLNAME_DOUED_AMOUNT = "doue_amount";
  static const String COLNAME_MNF_DATE = "mnf_date";
  static const String COLNAME_EXP_DATE = "exp_date";
  static const String COLNAME_DESCRIPTION = "description";
  static const String COLNAME_GRN_DATE = "grn_date";
  static const String TABLE_NAME = "grn";
  static const String INSERTQUERY= "INSERT INTO `grn` (`barcode`, `product_product_id`, `suppliers_supplier_id`, `grnqty`, `wholesale_price`, `retail_price`, `value`, `paid_amount`, `doue_amount`, `mnf_date`, `exp_date`, `description`, `grn_date`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
  static const String SELECTQUERY = "SELECT * FROM grn INNER JOIN product ON product.product_id = grn.product_product_id INNER JOIN suppliers ON suppliers.supplier_id = grn.suppliers_supplier_id INNER JOIN main_category ON main_category.main_cat_id = product.main_category_main_cat_id INNER JOIN sub_category ON sub_category.sub_cat_id = product.sub_category_sub_cat_id INNER JOIN units ON units.unit_id = product.units_unit_id ORDER BY grn.grn_id DESC ";
  static const String SELECTBYIDQUERY = "SELECT * FROM grn INNER JOIN product ON product.product_id = grn.product_product_id INNER JOIN suppliers ON suppliers.supplier_id = grn.suppliers_supplier_id INNER JOIN main_category ON main_category.main_cat_id = product.main_category_main_cat_id INNER JOIN sub_category ON sub_category.sub_cat_id = product.sub_category_sub_cat_id INNER JOIN units ON units.unit_id = product.units_unit_id WHERE grn.grn_id = :GRNid ";
  static const String SELECTBYSUPPLIERIDQUERY = "SELECT * FROM grn INNER JOIN product ON product.product_id = grn.product_product_id INNER JOIN suppliers ON suppliers.supplier_id = grn.suppliers_supplier_id INNER JOIN main_category ON main_category.main_cat_id = product.main_category_main_cat_id INNER JOIN sub_category ON sub_category.sub_cat_id = product.sub_category_sub_cat_id INNER JOIN units ON units.unit_id = product.units_unit_id WHERE suppliers.supplier_id = :id";
  static const String PAYQUERY = "UPDATE `grn` SET `paid_amount`=?, `doue_amount`=? WHERE  `grn_id`=?";

  Future<int> insert() async {
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );

    await conn.connect();
    var stmt = await conn.prepare(INSERTQUERY);
    IResultSet result = await stmt.execute([barcode,product.id,supplier.id,quantity,wholesalePrice,retailPrice,value,paidAmount,douedAmount,mnfDate,expDate,description,grnDate]);
    print("GRN ID : ${result.lastInsertID} : ${result.lastInsertID.toInt()}");
    await conn.close();
    return result.lastInsertID.toInt();


  }

  static Future<List<GRN>> getAll() async{
    List<GRN> grns = [];
    final conn = MySQLDatabase().pool;
    var results = await conn.execute(SELECTQUERY);
    for (var row in results.rows) {
      GRN grn = GRN(
        id:int.parse(row.colByName(COLNAME_ID) as String),
        barcode: row.colByName(COLNAME_BARCODE)as String,
        grnDate: DateTime.parse(row.colByName(COLNAME_GRN_DATE)as String),
        quantity: double.parse(row.colByName(COLNAME_QUANTITY)as String),
        description: row.colByName(COLNAME_DESCRIPTION)as String,
        mnfDate: DateTime.parse(row.colByName(COLNAME_MNF_DATE)as String),
        expDate: DateTime.parse(row.colByName(COLNAME_EXP_DATE)as String),
        wholesalePrice: double.parse(row.colByName(COLNAME_WHOLESALE_PRICE)as String),
        retailPrice: double.parse(row.colByName(COLNAME_RETAIL_PRICE)as  String),
        value: double.parse(row.colByName(COLNAME_VALUE)as  String),
        paidAmount: double.parse(row.colByName(COLNAME_PAID_AMOUNT)as String),
        douedAmount: double.parse(row.colByName(COLNAME_DOUED_AMOUNT)as String),
        product: Product(
          id: int.parse(row.colByName(Product.COLNAME_ID)as String),
          barcode: row.colByName(Product.COLNAME_BARCODE)as String,
          name: row.colByName(Product.COLNAME_NAME)as String,
          siName: row.colByName(Product.COLNAME_SI_NAME)as String,
          description: row.colByName(Product.COLNAME_DESCRIPTION)as String,
          mainCategory: MainCategory(
            id: int.parse(row.colByName(MainCategory.COLNAME_ID)as String),
            name: row.colByName(MainCategory.COLNAME_NAME)as String,
          ),
          subCategory: SubCategory(
            id: int.parse(row.colByName(SubCategory.COLNAME_ID)as  String),
            name: row.colByName(SubCategory.COLNAME_NAME)as String,
          ),
          unit: Unit(
            id: int.parse(row.colByName(Unit.COLNAME_ID)as String),
            name: row.colByName(Unit.COLNAME_NAME)as String,

          ),
        ),
        supplier: Supplier(
          id:  int.parse(row.colByName(Supplier.COLNAME_ID)as String),
          name: row.colByName(Supplier.COLNAME_NAME)as String,
          contact: row.colByName(Supplier.COLNAME_CONTACT)as String,
          bankDetails: row.colByName(Supplier.COLNAME_BANK_DETAILS)as String,
          email: row.colByName(Supplier.COLNAME_EMAIL)as String,
        ),
      );

      grns.add(grn);
    }
    conn.close();
    print(grns.length);
    return grns;
  }
   static Future<List<GRN>> getAllWithLimit({int limit = 3}) async{
     List<GRN> grns = [];
     final conn = MySQLDatabase().pool;
     var results = await conn.execute("$SELECTQUERY LIMIT $limit");
     for (var row in results.rows) {
       GRN grn = GRN(
         id:int.parse(row.colByName(COLNAME_ID) as String),
         barcode: row.colByName(COLNAME_BARCODE)as String,
         grnDate: DateTime.parse(row.colByName(COLNAME_GRN_DATE)as String),
         quantity: double.parse(row.colByName(COLNAME_QUANTITY)as String),
         description: row.colByName(COLNAME_DESCRIPTION)as String,
         mnfDate: DateTime.parse(row.colByName(COLNAME_MNF_DATE)as String),
         expDate: DateTime.parse(row.colByName(COLNAME_EXP_DATE)as String),
         wholesalePrice: double.parse(row.colByName(COLNAME_WHOLESALE_PRICE)as String),
         retailPrice: double.parse(row.colByName(COLNAME_RETAIL_PRICE)as  String),
         value: double.parse(row.colByName(COLNAME_VALUE)as  String),
         paidAmount: double.parse(row.colByName(COLNAME_PAID_AMOUNT)as String),
         douedAmount: double.parse(row.colByName(COLNAME_DOUED_AMOUNT)as String),
         product: Product(
           id: int.parse(row.colByName(Product.COLNAME_ID)as String),
           barcode: row.colByName(Product.COLNAME_BARCODE)as String,
           name: row.colByName(Product.COLNAME_NAME)as String,
           siName: row.colByName(Product.COLNAME_SI_NAME)as String,
           description: row.colByName(Product.COLNAME_DESCRIPTION)as String,
           mainCategory: MainCategory(
             id: int.parse(row.colByName(MainCategory.COLNAME_ID)as String),
             name: row.colByName(MainCategory.COLNAME_NAME)as String,
           ),
           subCategory: SubCategory(
             id: int.parse(row.colByName(SubCategory.COLNAME_ID)as  String),
             name: row.colByName(SubCategory.COLNAME_NAME)as String,
           ),
           unit: Unit(
             id: int.parse(row.colByName(Unit.COLNAME_ID)as String),
             name: row.colByName(Unit.COLNAME_NAME)as String,

           ),
         ),
         supplier: Supplier(
           id:  int.parse(row.colByName(Supplier.COLNAME_ID)as String),
           name: row.colByName(Supplier.COLNAME_NAME)as String,
           contact: row.colByName(Supplier.COLNAME_CONTACT)as String,
           bankDetails: row.colByName(Supplier.COLNAME_BANK_DETAILS)as String,
           email: row.colByName(Supplier.COLNAME_EMAIL)as String,
         ),
       );

       grns.add(grn);
     }
     conn.close();
     print(grns.length);
     return grns;
   }

  Future<void> pay(double payAmount)async {
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );

    await conn.connect();
    var stmt = await conn.prepare(PAYQUERY);//paidAmount

    print("now Paid Amount ${payAmount}");
    print("value  ${value}");
    print("doue amount ${douedAmount}");
    print("after paiment payd amount ${payAmount+paidAmount}");
    print("after payment doued ${value-paidAmount}");
    double fullpayed = payAmount+paidAmount;
    IResultSet result = await stmt.execute([payAmount+paidAmount,value-fullpayed,id]);

    print("GRN ID : ${result.lastInsertID} : ${result.lastInsertID.toInt()}");
    await conn.close();
  }

  static Future<GRN> getByID(String ID)async{
    List<GRN> grns = [];
    final conn =MySQLDatabase().pool;

    var results = await conn.execute(SELECTBYIDQUERY,{"GRNid":ID});
    for (var row in results.rows) {
      GRN grn = GRN(
        id:int.parse(row.colByName(COLNAME_ID) as String),
        barcode: row.colByName(COLNAME_BARCODE)as String,
        grnDate: DateTime.parse(row.colByName(COLNAME_GRN_DATE)as String),
        quantity: double.parse(row.colByName(COLNAME_QUANTITY)as String),
        description: row.colByName(COLNAME_DESCRIPTION)as String,
        mnfDate: DateTime.parse(row.colByName(COLNAME_MNF_DATE)as String),
        expDate: DateTime.parse(row.colByName(COLNAME_EXP_DATE)as String),
        wholesalePrice: double.parse(row.colByName(COLNAME_WHOLESALE_PRICE)as String),
        retailPrice: double.parse(row.colByName(COLNAME_RETAIL_PRICE)as  String),
        value: double.parse(row.colByName(COLNAME_VALUE)as  String),
        paidAmount: double.parse(row.colByName(COLNAME_PAID_AMOUNT)as String),
        douedAmount: double.parse(row.colByName(COLNAME_DOUED_AMOUNT)as String),
        product: Product(
          id: int.parse(row.colByName(Product.COLNAME_ID)as String),
          barcode: row.colByName(Product.COLNAME_BARCODE)as String,
          name: row.colByName(Product.COLNAME_NAME)as String,
          siName: row.colByName(Product.COLNAME_SI_NAME)as String,
          description: row.colByName(Product.COLNAME_DESCRIPTION)as String,
          mainCategory: MainCategory(
            id: int.parse(row.colByName(MainCategory.COLNAME_ID)as String),
            name: row.colByName(MainCategory.COLNAME_NAME)as String,
          ),
          subCategory: SubCategory(
            id: int.parse(row.colByName(SubCategory.COLNAME_ID)as  String),
            name: row.colByName(SubCategory.COLNAME_NAME)as String,
          ),
          unit: Unit(
            id: int.parse(row.colByName(Unit.COLNAME_ID)as String),
            name: row.colByName(Unit.COLNAME_NAME)as String,

          ),
        ),
        supplier: Supplier(
          id:  int.parse(row.colByName(Supplier.COLNAME_ID)as String),
          name: row.colByName(Supplier.COLNAME_NAME)as String,
          contact: row.colByName(Supplier.COLNAME_CONTACT)as String,
          bankDetails: row.colByName(Supplier.COLNAME_BANK_DETAILS)as String,
          email: row.colByName(Supplier.COLNAME_EMAIL)as String,
        ),
      );
      grns.add(grn);
    }
    return grns[0];
  }

  static Future<List<GRN>> getSupplierGRN(int id)async{
    List<GRN> grns = [];
    final conn = await MySQLConnection.createConnection(
      host: AppData.dbURL,
      port: AppData.dbPORT,
      userName: AppData.dbUser,
      password: AppData.dbPassword,
      databaseName: AppData.dbName, // optional
    );

    await conn.connect();
    var results = await conn.execute(SELECTBYSUPPLIERIDQUERY,{"id":id});
    for (var row in results.rows) {
      GRN grn = GRN(
        id:int.parse(row.colByName(COLNAME_ID) as String),
        barcode: row.colByName(COLNAME_BARCODE)as String,
        grnDate: DateTime.parse(row.colByName(COLNAME_GRN_DATE)as String),
        quantity: double.parse(row.colByName(COLNAME_QUANTITY)as String),
        description: row.colByName(COLNAME_DESCRIPTION)as String,
        mnfDate: DateTime.parse(row.colByName(COLNAME_MNF_DATE)as String),
        expDate: DateTime.parse(row.colByName(COLNAME_EXP_DATE)as String),
        wholesalePrice: double.parse(row.colByName(COLNAME_WHOLESALE_PRICE)as String),
        retailPrice: double.parse(row.colByName(COLNAME_RETAIL_PRICE)as  String),
        value: double.parse(row.colByName(COLNAME_VALUE)as  String),
        paidAmount: double.parse(row.colByName(COLNAME_PAID_AMOUNT)as String),
        douedAmount: double.parse(row.colByName(COLNAME_DOUED_AMOUNT)as String),
        product: Product(
          id: int.parse(row.colByName(Product.COLNAME_ID)as String),
          barcode: row.colByName(Product.COLNAME_BARCODE)as String,
          name: row.colByName(Product.COLNAME_NAME)as String,
          siName: row.colByName(Product.COLNAME_SI_NAME)as String,
          description: row.colByName(Product.COLNAME_DESCRIPTION)as String,
          mainCategory: MainCategory(
            id: int.parse(row.colByName(MainCategory.COLNAME_ID)as String),
            name: row.colByName(MainCategory.COLNAME_NAME)as String,
          ),
          subCategory: SubCategory(
            id: int.parse(row.colByName(SubCategory.COLNAME_ID)as  String),
            name: row.colByName(SubCategory.COLNAME_NAME)as String,
          ),
          unit: Unit(
            id: int.parse(row.colByName(Unit.COLNAME_ID)as String),
            name: row.colByName(Unit.COLNAME_NAME)as String,

          ),
        ),
        supplier: Supplier(
          id:  int.parse(row.colByName(Supplier.COLNAME_ID)as String),
          name: row.colByName(Supplier.COLNAME_NAME)as String,
          contact: row.colByName(Supplier.COLNAME_CONTACT)as String,
          bankDetails: row.colByName(Supplier.COLNAME_BANK_DETAILS)as String,
          email: row.colByName(Supplier.COLNAME_EMAIL)as String,
        ),
      );
      grns.add(grn);
    }
    return grns;

  }
}