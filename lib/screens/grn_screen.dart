import 'dart:ui';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/constrollers/grn_search_controller.dart';
import 'package:point_of_sale/constrollers/search_grn_controller.dart';
import 'package:point_of_sale/models/supplier.dart';
import 'package:point_of_sale/models/users.dart';
import 'package:point_of_sale/widget/grn_card.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/grn.dart';
import '../models/product.dart';
import '../utils/other_utils.dart';
import '../widget/grn_date_filter_widget.dart';

class GRNScreen extends StatefulWidget {
  final List<GRN>? viewingGRNs;
  static UserAccess access = UserAccess.VIEWGRN;
  const GRNScreen({super.key,this.viewingGRNs});

  @override
  State<GRNScreen> createState() => _GRNScreenState();
}

class _GRNScreenState extends State<GRNScreen> {
  List<GRN> grns = [];
  List<GRN> searchedGRNs = [];
  List<int> grnsIds = [];

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

  SearchGRNController searchGRNController = SearchGRNController();
  DateTime? grnDate;


  void search() async{
    searchedGRNs.clear();
    // GRNSearchController controller = GRNSearchController(grns: grns);
    if(_productBarcodeController.text.isNotEmpty){
      searchGRNController.searchByProductBarcode(_productBarcodeController.text);
    }
    if(_grnBarcodeController.text.isNotEmpty){
      searchGRNController.searchByBarcode(_grnBarcodeController.text);
    }
    if(selectedProduct != null){
      searchGRNController.searchByProductID(selectedProduct!.id);
    }else if(_productController.text.isNotEmpty){
      searchGRNController.searchByProductName(_productController.text);
    }

    if(selectedSupplier != null){
      searchGRNController.searchBySupplierID(selectedSupplier!.id);
    }else if(_supplierController.text.isNotEmpty){
      searchGRNController.searchBySupplierMobile(_supplierController.text);
    }

    if(dueAmountGraterThan != 0){
      searchGRNController.searchByDueAmountGraterThan(dueAmountGraterThan);
    }
    if(dueAmountLessThan != 0){
      searchGRNController.searchByDueAmountLessThan(dueAmountLessThan);
    }


    if(grnDate != null){
      searchGRNController.searchByGRNDateFrom(grnDate!);
    }
    if(grnDate != null){
      searchGRNController.searchByGRNDateTo(grnDate!);
    }

    searchedGRNs.clear();

    searchedGRNs.addAll(await searchGRNController.search());
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
    grnsIds.clear();
    loadGRNs();
    setState(() {});
  }

  void loadGRNs() async {
   if(widget.viewingGRNs != null){
    grns = widget.viewingGRNs!;
    searchedGRNs.addAll(grns);
   }else{
     final grnList = await GRN.getAllWithLimit(limit: grns.length + 5);
     for(var grn in grnList){
       if(!grnsIds.contains(grn.id)){
         grns.add(grn);
         searchedGRNs.add(grn);
         grnsIds.add(grn.id);
       }
     }
   }

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


  final _scrollController = ScrollController();

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      bool isBottom = _scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent;
      if (isBottom) {
        loadGRNs();
      }
    }
  }
  @override
  void initState() {
    _scrollController.addListener(_onScroll); // Add scroll listener
    if(widget.viewingGRNs !=null && widget.viewingGRNs!.isNotEmpty){
      _supplierController.text = widget.viewingGRNs![0].supplier.name;
      selectedSupplier = widget.viewingGRNs![0].supplier;
    }
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
      scrollController: _scrollController,
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
                      enabled: widget.viewingGRNs == null,
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
        Row(
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"GRN Barcode"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"GRN Date"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Qty"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"WholeSale Price"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Value"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Paid Amount"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Due Amount"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"#"),
            )
          ],
        ),
        ...searchedGRNs.map((e) => Container(
          height: 78,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: FluentTheme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10)
          ),
          child:  Column(
            children: [
              Row(
                children: [
                  Text(e.product.name,textAlign: TextAlign.start,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 20)),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,e.barcode),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,OtherUtils.formatDateTime(e.grnDate)),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,"${e.quantity } ${e.product.unit.name}"),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,"${e.wholesalePrice}"),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,"${e.value}"),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,"${e.paidAmount}"),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                    child: Text("${e.douedAmount}", textAlign: TextAlign.center,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(color: e.douedAmount > 0 ? Colors.red:Colors.green)),
                  )
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Button(
                      child: Text("View"),
                      onPressed: (){
                        Navigator.of(context).push(FluentDialogRoute(builder: (context) =>Center(
                          child: SizedBox(
                            width: 500,
                            child: GRNCard(
                              grn: e,
                              refresh: refresh,
                              supplierOtherGRNs: supplierOtherGRNs,
                              productOtherGRNs: productOtherGRNs,
                            ),
                          ),
                        ) , context: context));
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        )),
        // ResponsiveGridList(
        //     minItemWidth: 300,
        //     listViewBuilderOptions: ListViewBuilderOptions(
        //       shrinkWrap: true,
        //     ),
        //     children: searchedGRNs
        //         .map((e) => GRNCard(
        //               grn: e,
        //               refresh: refresh,
        //               supplierOtherGRNs: supplierOtherGRNs,
        //               productOtherGRNs: productOtherGRNs,
        //             ))
        //         .toList()),
      ],
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

Widget _tableBodyCell(BuildContext context,String text) {
  return Container(
    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
    child: Text(text, textAlign: TextAlign.center,),
  );
}