import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/constrollers/grn_search_controller.dart';
import 'package:point_of_sale/models/supplier.dart';
import 'package:point_of_sale/widget/grn_card.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/grn.dart';
import '../models/product.dart';
import '../widget/grn_date_filter_widget.dart';

class GRNScreen extends StatefulWidget {
  final List<GRN>? viewingGRNs;
  const GRNScreen({super.key,this.viewingGRNs});

  @override
  State<GRNScreen> createState() => _GRNScreenState();
}

class _GRNScreenState extends State<GRNScreen> {
  List<GRN> grns = [];
  List<GRN> searchedGRNs = [];

  List<Product> products = [];
  List<Supplier> suppliers = [];

  Product? selectedProduct;
  Supplier? selectedSupplier;
  double dueAmountLessThan = 0;
  double dueAmountGraterThan = 0;

  final TextEditingController _grnBarcodeController = TextEditingController();
  final TextEditingController _productBarcodeController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();


  DateTime? grnDate;


  void search() {
    searchedGRNs.clear();
    GRNSearchController controller = GRNSearchController(grns: grns);
    if(_productBarcodeController.text.isNotEmpty){
      controller.searchByProductBarcode(_productBarcodeController.text);
    }
    if(_grnBarcodeController.text.isNotEmpty){
      controller.searchByGRNBarcode(_grnBarcodeController.text);
    }
    if(selectedProduct != null){
      controller.searchByProduct(selectedProduct!);
    }else if(_productController.text.isNotEmpty){
      controller.searchByProductName(_productController.text);
    }

    if(selectedSupplier != null){
      controller.searchBySupplier(selectedSupplier!);
    }else if(_supplierController.text.isNotEmpty){
      controller.searchBySupplierName(_supplierController.text);
    }

    if(dueAmountGraterThan != 0){
      controller.searchByDueAmountGraterThan(dueAmountGraterThan);
    }
    if(dueAmountLessThan != 0){
      controller.searchByDueAmountLessThan(dueAmountLessThan);
    }


    searchedGRNs.addAll(controller.getGRNs());
    if (mounted) {
      setState(() {});
    }
  }

  void clear() {
    searchedGRNs.clear();
    searchedGRNs.addAll(grns);
    if (mounted) {
      setState(() {});
    }
  }

  void refresh() {
    print("Refreshing GRNS");
    searchedGRNs.clear();
    grns.clear();
    loadGRNs();
    setState(() {});
  }

  void loadGRNs() async {
   if(widget.viewingGRNs != null){
    grns = widget.viewingGRNs!;
   }else{
     grns = await GRN.getAll();
   }
    searchedGRNs.addAll(grns);
    if (mounted) {
      setState(() {});
    }
  }

  void loadSuppliers() async {
    suppliers = await Supplier.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  void loadProducts() async {
    products = await Product.getAll();
    if (mounted) {
      setState(() {});
    }
  }

  void supplierOtherGRNs(Supplier supplier) {
    searchedGRNs.clear();
    print(supplier.id);
    for (GRN grn in grns) {
      if (grn.supplier.id == supplier.id) {
        searchedGRNs.add(grn);
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  void productOtherGRNs(Product product) {
    searchedGRNs.clear();
    for (GRN grn in grns) {
      if (grn.product.id == product.id) {
        searchedGRNs.add(grn);
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    loadGRNs();
    loadSuppliers();
    loadProducts();

    super.initState();
  }


  double calculateSizeBoxHeight() {
    double headerSizeBoxHeight = 100;

    print(MediaQuery.of(context).size.width);
    if(MediaQuery.of(context).size.width < 520){
      headerSizeBoxHeight = 500;
    }else if(MediaQuery.of(context).size.width < 750){
      headerSizeBoxHeight = 250;
    }else if(MediaQuery.of(context).size.width < 950){
      headerSizeBoxHeight = 200;
    }else if(MediaQuery.of(context).size.width < 1600){
      headerSizeBoxHeight = 130;
    }else if(MediaQuery.of(context).size.width < 1700){
      headerSizeBoxHeight = 110;
    }

    return headerSizeBoxHeight;
  }

  void showMessageBox(
      String title, String body, InfoBarSeverity severity) async {
    await displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: Text(title),
        content: Text(body),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: severity,
      );
    });
  }

  void dateFilter()async{
    bool? result = await Navigator.push<bool>(context, FluentDialogRoute(builder: (context) => GrnDateFilterWidget(grns: searchedGRNs), context: context));

    if(result == null){
      showMessageBox("Notification","Date Filter Not Applied",InfoBarSeverity.warning);
    }else if(result){
      showMessageBox("Notification","Date Filter  Applied",InfoBarSeverity.warning);
    }else{
      showMessageBox("Notification","Date Filter Not Applied",InfoBarSeverity.warning);

    }
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: Align(
        alignment: Alignment.center,
        child: Text(
          "Good Receive Notes",
          textAlign: TextAlign.center,
          style: FluentTheme.of(context).typography.title,
        ),
      ),
      padding: const EdgeInsets.all(10),
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: FluentTheme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: calculateSizeBoxHeight(),
            child: ResponsiveGridList(
              minItemWidth: 200,
              rowMainAxisAlignment: MainAxisAlignment.center,
              children: [
                InfoLabel(
                  label: "Product Barcode",
                  child: TextBox(
                    controller: _productBarcodeController,
                    placeholder: "Barcode",
                    // controller: _barcodeController,
                  ),
                ),
                InfoLabel(
                  label: "GRN Barcode",
                  child: TextBox(
                    controller: _grnBarcodeController,
                    placeholder: "Barcode",
                    // controller: _barcodeController,
                  ),
                ),
                InfoLabel(
                  label: "Due Amount Less Than",
                  child: NumberBox<double>(
                    value: dueAmountLessThan,
                    onChanged: (double? value) {
                      if(value !=null){
                        dueAmountLessThan = value;
                        setState(() {

                        });
                      }else{
                        dueAmountLessThan = 0;
                      }
                    },
                    placeholder: "Due Amount",
                    // controller: _barcodeController,
                  ),
                ),
                InfoLabel(
                  label: "Grater Than",
                  child: NumberBox<double>(
                    value: dueAmountGraterThan,
                    onChanged: (double? value) {
                      if(value !=null){
                        dueAmountGraterThan = value;
                        setState(() {

                        });
                      }else{
                        dueAmountGraterThan = 0;
                      }
                    },
                    placeholder: "Due Amount",
                    // controller: _barcodeController,
                  ),
                ),
                InfoLabel(
                  label: "Product",
                  child: SizedBox(
                    height: 32,
                    child: AutoSuggestBox<Product>(
                      controller: _productController,
                      onChanged: (text, reason) {
                        if(text.isEmpty){
                          selectedProduct = null;
                        }
                      },
                      onSelected: (value) {
                        selectedProduct = value.value;
                      },
                      items: products
                          .map((e) => AutoSuggestBoxItem<Product>(
                                value: e,
                                label: "${e.name}",
                              ))
                          .toList(),
                    ),
                  ),
                ),
                InfoLabel(
                  label: "Supplier",
                  child: SizedBox(
                    height: 32,
                    child: AutoSuggestBox<Supplier>(
                      controller: _supplierController,
                      onChanged: (text, reason) {
                        if(text.isEmpty){
                          selectedSupplier = null;
                        }
                      },
                      onSelected: (value) {
                        selectedSupplier = value.value;

                      },
                      items: suppliers
                          .map((e) => AutoSuggestBoxItem<Supplier>(
                                value: e,
                                label: "${e.email}",
                              ))
                          .toList(),
                    ),
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
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 32,
                      child: FilledButton(
                          onPressed: dateFilter,
                          style: ButtonStyle(
                              backgroundColor: ButtonState.all(Colors.green)),
                          child: Text(
                            "Filter",
                            style: FluentTheme.of(context)
                                .typography
                                .bodyStrong!
                                .copyWith(color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
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
          ),
        ),
        ResponsiveGridList(
            minItemWidth: 300,
            listViewBuilderOptions: ListViewBuilderOptions(
              shrinkWrap: true,
            ),
            children: searchedGRNs
                .map((e) => GRNCard(
                      grn: e,
                      refresh: refresh,
                      supplierOtherGRNs: supplierOtherGRNs,
                      productOtherGRNs: productOtherGRNs,
                    ))
                .toList()),
      ],
    );
  }
}
