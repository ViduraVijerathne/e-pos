import 'package:point_of_sale/models/grn.dart';
import 'package:point_of_sale/models/product.dart';

import '../models/main_category.dart';
import '../models/sub_category.dart';
import '../models/supplier.dart';
import '../models/unit.dart';
import '../utils/database.dart';

class SearchGRNController{
  List<String> conditions = [];

  void searchByBarcode(String barcode){
    conditions.add("${GRN.COLNAME_BARCODE} = '$barcode'");
  }
  void searchByProductBarcode(String barcode){
    conditions.add("${Product.COLNAME_BARCODE} = '$barcode'");
  }

  void searchByProductID(int id){
    conditions.add("${GRN.COLNAME_PRODUCT} = '$id'");
  }

  void searchByDueAmountLessThan(double lessThan){
    conditions.add("${GRN.COLNAME_DOUED_AMOUNT} < '$lessThan'");
  }

  void searchByDueAmountGraterThan(double graterThan){
    conditions.add("${GRN.COLNAME_DOUED_AMOUNT} > '$graterThan'");
  }

  void searchBySupplierID(int id){
    conditions.add("${GRN.COLNAME_SUPPLIER} = '$id'");
  }

  void searchByGRNDateFrom(DateTime dateTime){
    conditions.add("${GRN.COLNAME_GRN_DATE} >= '${dateTime.toIso8601String()}'");
  }

  void searchByGRNDateTo(DateTime dateTime){
    conditions.add("${GRN.COLNAME_GRN_DATE} <= '${dateTime.toIso8601String()}'");
  }

  void searchByProductName(String name){
    conditions.add("${Product.COLNAME_NAME} = '$name'");
  }

  void searchBySupplierMobile(String mobile){
    conditions.add("${Supplier.COLNAME_CONTACT} = '$mobile'");
  }
  Future<List<GRN>> search({String operator = "AND"})async {
    List<GRN> grns = [];
    final pool = MySQLDatabase().pool;
    final q = "${GRN.SELECTQUERY} WHERE ${conditions.join(" $operator ")}";
    print(q);
    final results = await pool.execute(q);
    for (var row in results.rows) {
      GRN grn = GRN(
        id:int.parse(row.colByName(GRN.COLNAME_ID) as String),
        barcode: row.colByName(GRN.COLNAME_BARCODE)as String,
        grnDate: DateTime.parse(row.colByName(GRN.COLNAME_GRN_DATE)as String),
        quantity: double.parse(row.colByName(GRN.COLNAME_QUANTITY)as String),
        description: row.colByName(GRN.COLNAME_DESCRIPTION)as String,
        mnfDate: DateTime.parse(row.colByName(GRN.COLNAME_MNF_DATE)as String),
        expDate: DateTime.parse(row.colByName(GRN.COLNAME_EXP_DATE)as String),
        wholesalePrice: double.parse(row.colByName(GRN.COLNAME_WHOLESALE_PRICE)as String),
        retailPrice: double.parse(row.colByName(GRN.COLNAME_RETAIL_PRICE)as  String),
        value: double.parse(row.colByName(GRN.COLNAME_VALUE)as  String),
        paidAmount: double.parse(row.colByName(GRN.COLNAME_PAID_AMOUNT)as String),
        douedAmount: double.parse(row.colByName(GRN.COLNAME_DOUED_AMOUNT)as String),
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
    conditions.clear();
    return grns;
  }

}