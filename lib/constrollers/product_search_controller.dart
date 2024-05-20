import 'package:point_of_sale/models/main_category.dart';
import 'package:point_of_sale/models/product.dart';
import 'package:point_of_sale/models/sub_category.dart';
import 'package:point_of_sale/models/unit.dart';
import 'package:point_of_sale/utils/database.dart';

class ProductSearchController {
  List<String> conditions = [];

  void searchByBarcode(String barcode){
    String condition = "${Product.COLNAME_BARCODE} = '$barcode'";
    conditions.add(condition);
  }

  void searchByName(String name){
    String condition = "${Product.COLNAME_NAME} = '$name'";
    conditions.add(condition);
  }

  void searchByCategory(MainCategory mainCategory){
    String condition = "${Product.COLNAME_MAIN_CAT} = '${mainCategory.id}'";
    conditions.add(condition);
  }

  void searchBySubCategory(SubCategory subCategory){
    String condition = "${Product.COLNAME_SUB_CAT} = '${subCategory.id}'";
    conditions.add(condition);
  }

  void searchByUnit(Unit unit){
    String condition = "${Product.COLNAME_UNIT} = '${unit.id}'";
    conditions.add(condition);
  }

  Future<List<Product>> search({String operator = "AND"})async {
    List<Product> products = [];
    final pool = MySQLDatabase().pool;
    final results = await pool.execute(
        "${Product.SELECTQUERY} WHERE ${conditions.join(" $operator ")}");
    for (var row in results.rows) {
      String id = row.colByName(Product.COLNAME_ID) ?? "0";
      String barcode = row.colByName(Product.COLNAME_BARCODE) ?? "0";
      String name = row.colByName(Product.COLNAME_NAME) as String;
      String siName = row.colByName(Product.COLNAME_SI_NAME) as String;
      String description = row.colByName(Product.COLNAME_DESCRIPTION) as String;

      int mainCategoryId = int.parse(row.colByName(MainCategory.COLNAME_ID)!);
      int subCategoryId = int.parse(row.colByName(SubCategory.COLNAME_ID)!);
      int unitId = int.parse(row.colByName(Unit.COLNAME_ID)!);

      MainCategory mainCategory = MainCategory(
          id: mainCategoryId, name: row.colByName(MainCategory.COLNAME_NAME)!);
      SubCategory subCategory = SubCategory(
          id: subCategoryId, name: row.colByName(SubCategory.COLNAME_NAME)!);
      Unit unit = Unit(id: unitId, name: row.colByName(Unit.COLNAME_NAME)!);

      products.add(Product(id: int.parse(id),
          barcode: barcode,
          name: name,
          siName: siName,
          description: description,
          mainCategory: mainCategory,
          subCategory: subCategory,
          unit: unit));
    }
    return products;
  }



}