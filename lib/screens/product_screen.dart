import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/widget/product_card.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/main_category.dart';
import '../models/product.dart';
import '../models/sub_category.dart';
import '../models/unit.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> products = [];
  List<Product> searchedProducts = [];
  List<MainCategory> mainCategories = [];
  List<SubCategory> subCategories = [];
  List<Unit> units = [];

  MainCategory? selectedMainCategory;
  SubCategory? selectedSubCategory;
  Unit? selectedUnit;
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();

  void loadProducts() async {
    products = await Product.getAll();
    searchedProducts.addAll(products);
    if (mounted) {
      setState(() {});
    }
  }

  void loadMainCat() async {
    mainCategories = await MainCategory.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  void loadSubCat() async {
    subCategories = await SubCategory.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  void loadUnit() async {
    units = await Unit.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    loadProducts();
    loadMainCat();
    loadSubCat();
    loadUnit();
    super.initState();
  }

  void clear() {
    selectedUnit = null;
    selectedSubCategory = null;
    selectedMainCategory = null;
    _barcodeController.text = "";
    _productNameController.text = "";
    searchedProducts.clear();
    searchedProducts.addAll(products);
    setState(() {});
  }

  void search() async {
    searchedProducts.clear();
    print(products.length);
    for (Product p in products) {

      if (_barcodeController.text.isNotEmpty && p.barcode == _barcodeController.text) {
          searchedProducts.add(p);
      }
      else if (_productNameController.text.isNotEmpty && p.name.toLowerCase().contains(_productNameController.text.toLowerCase())) {
        searchedProducts.add(p);
      }else if(selectedMainCategory != null && p.mainCategory.id == selectedMainCategory!.id){
        searchedProducts.add(p);
    }else if(selectedSubCategory != null && p.subCategory.id == selectedSubCategory!.id){
        searchedProducts.add(p);
      }else if(selectedUnit != null && p.unit.id == selectedUnit!.id){
        searchedProducts.add(p);
      }


    }
    setState(() {

    });
  }

  void refresh(){
    products.clear();
    searchedProducts.clear();
    mainCategories.clear();
    subCategories.clear();
    units.clear();

    loadProducts();
    loadMainCat();
    loadSubCat();
    loadUnit();
    if(mounted){
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      padding: const EdgeInsets.all(10),
      header: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: FluentTheme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(
              "Products",
              style: FluentTheme.of(context).typography.title,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 100,
              child: ResponsiveGridList(
                minItemWidth: 150,
                rowMainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoLabel(
                    label: "Product Barcode",
                    child: TextBox(
                      placeholder: "Barcode",
                      controller: _barcodeController,
                    ),
                  ),
                  InfoLabel(
                    label: "Product Name",
                    child: TextBox(
                        placeholder: "Product Name",
                        controller: _productNameController),
                  ),
                  InfoLabel(
                    label: "Main Category",
                    child: ComboBox<MainCategory>(
                      isExpanded: true,
                      value: selectedMainCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedMainCategory = value;
                        });
                      },
                      items: mainCategories
                          .map((e) => ComboBoxItem<MainCategory>(
                                child: Text(e.name),
                                value: e,
                              ))
                          .toList(),
                    ),
                  ),
                  InfoLabel(
                    label: "Sub Category",
                    child: ComboBox<SubCategory>(
                      isExpanded: true,
                      value: selectedSubCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedSubCategory = value;
                        });
                      },
                      items: subCategories
                          .map((e) => ComboBoxItem<SubCategory>(
                                child: Text(e.name),
                                value: e,
                              ))
                          .toList(),
                    ),
                  ),
                  InfoLabel(
                    label: "Unit",
                    child: ComboBox<Unit>(
                      isExpanded: true,
                      value: selectedUnit,
                      onChanged: (value) {
                        setState(() {
                          selectedUnit = value;
                        });
                      },
                      items: units
                          .map((e) => ComboBoxItem<Unit>(
                                child: Text(e.name),
                                value: e,
                              ))
                          .toList(),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 32,
                        child: FilledButton(
                            onPressed: search,
                            child: Text(
                              "Search",
                              style: FluentTheme.of(context)
                                  .typography
                                  .bodyStrong!
                                  .copyWith(color: Colors.white),
                            )),
                      ),
                      const SizedBox(width: 10,),
                      SizedBox(
                        height: 32,
                        child: FilledButton(
                            onPressed: clear,
                            style: ButtonStyle(
                                backgroundColor: ButtonState.all(Colors.red)),
                            child: Text(
                              "Clear",
                              style: FluentTheme.of(context)
                                  .typography
                                  .bodyStrong!
                                  .copyWith(color: Colors.white),
                            )),
                      )
                    ],
                  ),

                ],
              ),
            )
          ],
        ),
      ),
      content: ResponsiveGridList(
        minItemWidth: 300,
        children: searchedProducts
            .map((e) => ProductCard(product: e,refresh:refresh ,))
            .toList(),
      ),
    );
  }
}


