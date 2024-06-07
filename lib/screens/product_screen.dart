import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/constrollers/product_search_controller.dart';
import 'package:point_of_sale/models/users.dart';
import 'package:point_of_sale/screens/stock_screen.dart';
import 'package:point_of_sale/widget/product_card.dart';
import 'package:point_of_sale/widget/view_product_sales_widget.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/main_category.dart';
import '../models/product.dart';
import '../models/sub_category.dart';
import '../models/unit.dart';
import '../widget/ProductStockViewWidget.dart';
import 'add_product_screen.dart';

class ProductScreen extends StatefulWidget {
  static UserAccess access = UserAccess.VIEWPRODUCTS;
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isTableView = true;
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
  final ScrollController _tableScrollController = ScrollController();
  final ScrollController _cardScrollController = ScrollController();
  ProductSearchController productSearchController = ProductSearchController();
  void loadProducts() async {
    products = await Product.getAllWithLimit();
    searchedProducts.addAll(products);
    if (mounted) {
      setState(() {});
    }
  }
  void loadMoreProduct()async{
    int limit = products.length+10;
    products.clear();
    searchedProducts.clear();
    products = await Product.getAllWithLimit(limit:limit );
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

  void _onScroll() {
    if (_tableScrollController.position.atEdge) {
      bool isBottom = _tableScrollController.position.pixels == _tableScrollController.position.maxScrollExtent;
      if (isBottom) {
        loadMoreProduct();
      }
    }
  }
  void _onScrollCard() {
    if (_cardScrollController.position.atEdge) {
      bool isBottom = _cardScrollController.position.pixels == _cardScrollController.position.maxScrollExtent;
      if (isBottom) {
        loadMoreProduct();
      }
    }
  }

  @override
  void initState() {
    loadProducts();
    loadMainCat();
    loadSubCat();
    loadUnit();
    _tableScrollController.addListener(_onScroll); // Add scroll listener
    _cardScrollController.addListener(_onScrollCard);
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
    productSearchController.conditions.clear();
    setState(() {});
  }

  void search() async {

    searchedProducts.clear();
    if (_barcodeController.text.isNotEmpty) {
      productSearchController.searchByBarcode(_barcodeController.text);
    }
    if (_productNameController.text.isNotEmpty) {
      productSearchController.searchByName(_productNameController.text);
    }
    if(selectedMainCategory != null){
      productSearchController.searchByCategory(selectedMainCategory!);
    }
    if(selectedSubCategory != null){
      productSearchController.searchBySubCategory(selectedSubCategory!);
    }
    if(selectedUnit != null){
      productSearchController.searchByUnit(selectedUnit!);
    }
    searchedProducts.addAll(await productSearchController.search());

    // for (Product p in products) {
    //
    //   if (_barcodeController.text.isNotEmpty && p.barcode == _barcodeController.text) {
    //       searchedProducts.add(p);
    //   }
    //   else if (_productNameController.text.isNotEmpty && p.name.toLowerCase().contains(_productNameController.text.toLowerCase())) {
    //     searchedProducts.add(p);
    //   }else if(selectedMainCategory != null && p.mainCategory.id == selectedMainCategory!.id){
    //     searchedProducts.add(p);
    // }else if(selectedSubCategory != null && p.subCategory.id == selectedSubCategory!.id){
    //     searchedProducts.add(p);
    //   }else if(selectedUnit != null && p.unit.id == selectedUnit!.id){
    //     searchedProducts.add(p);
    //   }
    //
    //
    // }
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

  void viewStock(Product product)async{
    await Navigator.push(context, FluentDialogRoute(builder: (context) => ProductStockViewWidget(product: product), context: context,));
    refresh();
  }

  void viewProductSales(Product product){
    Navigator.of(context).push(FluentDialogRoute(builder: (context) =>ViewProductSalesWidget(product: product,) , context: context));

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
              height: 80,
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
                      ),

                    ],
                  ),

                ],
              ),
            ),
            ToggleSwitch(
              checked: isTableView,

              content: Text(isTableView ? 'Table View' : 'Card View'),
              onChanged: (bool value) {
                setState(() {
                  isTableView = value;
                });
              },
            )
          ],
        ),
      ),
      content:AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
                child: child,
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation),
            );

            // return ScaleTransition(
            //   scale: animation,
            //   child: child,
            // );
            // return SizeTransition(
            //   sizeFactor: animation,
            //   axis: Axis.vertical,
            //   child: child,
            // );
            // return FadeTransition(
            //   opacity: animation,
            //   child: ScaleTransition(
            //     scale: animation,
            //     child: child,
            //   ),
            // );
          },
        child:isTableView ?
        ListView(
          key: ValueKey<bool>(isTableView),
          controller: _tableScrollController,
          children: [
            Row(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: _tableHead(context,"ID"),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: _tableHead(context,"Barcode"),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: _tableHead(context,"Main Category"),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: _tableHead(context,"Sub Category"),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: _tableHead(context,"Unit"),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: _tableHead(context,"#"),
                )
              ],
            ),
            SizedBox(height: 10,),
            ...searchedProducts.map((e) => Container(
              height: 75,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: FluentTheme.of(context).cardColor
              ),
              child: Column(
                children: [
                  // 1st row
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(width: 20,),
                        Expanded(
                          child: Text(e.name,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 18)),
                          flex: 5,
                        ),
                        Expanded(
                          child: Text(e.siName,style: TextStyle(fontFamily:"NotoSansSinhala"),),
                          flex: 4,
                        ),
                        Expanded(
                          flex: 1,
                          child: FilledButton(child: Text("Update"), onPressed: ()async{
                            await Navigator.of(context).push(FluentDialogRoute(builder: (context) => AddProductScreen(product: e,isEditingMode: true), context: context));
                            refresh();
                          }),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: _tableBodyCell(context,e.id.toString()),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: _tableBodyCell(context,e.barcode),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: _tableBodyCell(context,e.mainCategory.name),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: _tableBodyCell(context,e.subCategory.name),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: _tableBodyCell(context,e.unit.name),
                        ),
                        Expanded(
                          flex: 3,
                          // fit: FlexFit.tight,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Button(child: Text("View Stock"), onPressed: () {
                                  viewStock(e);
                                },),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                flex: 1,
                                child: Button(child: Text("View Sales"), onPressed: (){
                                  viewProductSales(e);
                                }),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  )

                ],
              ),
            ))
          ],
        ):
        ResponsiveGridList(
          minItemWidth: 300,
          listViewBuilderOptions: ListViewBuilderOptions(
            controller: _cardScrollController,
          ),
          children: searchedProducts
              .map((e) => ProductCard(product: e,refresh:refresh ,viewStock: viewStock,viewProductSales: viewProductSales,))
              .toList(),
        ) ,
      )


    );
  }
}


Widget _tableHead(BuildContext context,String text){
  return Container(
    padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
    decoration: BoxDecoration(
      color: FluentTheme.of(context).accentColor.withOpacity(0.2)
    ),
    child: Text(text,textAlign: TextAlign.center,style:FluentTheme.of(context).typography.bodyStrong,),
  );
}

Widget _tableBodyCell(BuildContext context,String text){
  return Container(
    padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
    child: Text(text,textAlign: TextAlign.center,),
  );
}
