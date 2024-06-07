import "package:fluent_ui/fluent_ui.dart";
import "package:point_of_sale/constrollers/stock_search_controller.dart";
import "package:point_of_sale/models/users.dart";
import "package:point_of_sale/widget/stock_card.dart";
import "package:responsive_grid_list/responsive_grid_list.dart";

import "../models/product.dart";
import "../models/stock.dart";
import "../utils/other_utils.dart";

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});
  static UserAccess access = UserAccess.VIEWGRN;
  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<Product> products = [];
  List<Stock> searchStocks = [];
  List<Stock> stocks = [];
  bool showExpriredStocksOnly = false;
  Product? selectedProduct;
  final TextEditingController _productBarcodeController =
      TextEditingController();
  final TextEditingController _stockBarcodeController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  double priceLessThan = 0;
  double priceGraterThan = 0;

  double calculateSizeBoxHeight() {
    double headerSizeBoxHeight = 100;

    print(MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).size.width < 520) {
      headerSizeBoxHeight = 500;
    } else if (MediaQuery.of(context).size.width < 750) {
      headerSizeBoxHeight = 250;
    } else if (MediaQuery.of(context).size.width < 950) {
      headerSizeBoxHeight = 200;
    } else if (MediaQuery.of(context).size.width < 1600) {
      headerSizeBoxHeight = 130;
    } else if (MediaQuery.of(context).size.width < 1700) {
      headerSizeBoxHeight = 110;
    }

    return headerSizeBoxHeight;
  }

  void search()async {
    print(stocks.length);
    StockSearchController controller = StockSearchController();

    if(_productBarcodeController.text.isNotEmpty){
      print("searchProductBarcode");
      controller.searchByProductBarcode(_productBarcodeController.text);
    }
    if(_stockBarcodeController.text.isNotEmpty){
      controller.searchByStockBarcode(_stockBarcodeController.text);
    }
    if(priceLessThan >0){
      controller.searchByPriceLessThan(priceLessThan);
    }
    if(priceGraterThan > 0){
      controller.searchByPriceGraterThan(priceGraterThan);
    }
    if(selectedProduct != null){
      controller.searchByProduct(selectedProduct!);
    }
    if(showExpriredStocksOnly){
      controller.searchByStockExpired();
    }

    searchStocks.clear();
    searchStocks.addAll(await controller.getStock());
    setState(() {

    });

  }

  void dateFilter() {}

  void clear() {
    searchStocks.clear();
    searchStocks.addAll(stocks);
    if (mounted) {
      setState(() {});
    }
  }

  void loadStocks() async {
    int limit = searchStocks.length+6;
    searchStocks.clear();
    stocks.clear();
    searchStocks.addAll(await Stock.getAllWithLimit(limit: limit));
    stocks.addAll(searchStocks);
    print("loading");
    if (mounted) {
      print("stock count ${searchStocks.length}" );
      setState(() {});
    }
  }

  final _scrollController = ScrollController();

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      bool isBottom = _scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent;
      if (isBottom) {
        loadStocks();
      }
    }
  }

  @override
  void initState() {
    _scrollController.addListener(_onScroll); // Add scroll listener
    loadStocks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      scrollController: _scrollController,
      header: Align(
        alignment: Alignment.center,
        child: Text(
          "Stocks",
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
                  label: "Stock Barcode",
                  child: TextBox(
                    controller: _stockBarcodeController,
                    placeholder: "Barcode",
                    // controller: _barcodeController,
                  ),
                ),
                InfoLabel(
                  label: "Price Less Than",
                  child: NumberBox<double>(
                    value: priceLessThan,
                    onChanged: (double? value) {
                      if (value != null) {
                        priceLessThan = value;
                        setState(() {});
                      } else {
                        priceLessThan = 0;
                      }
                    },
                    placeholder: "Price",
                    // controller: _barcodeController,
                  ),
                ),
                InfoLabel(
                  label: "Grater Than",
                  child: NumberBox<double>(
                    value: priceGraterThan,
                    onChanged: (double? value) {
                      if (value != null) {
                        priceGraterThan = value;
                        setState(() {});
                      } else {
                        priceGraterThan = 0;
                      }
                    },
                    placeholder: "Price",
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
                        if (text.isEmpty) {
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
                Checkbox(
                  content:const Text("Show Expired Stocks Only"),
                  checked: showExpriredStocksOnly,
                  onChanged: (value) {
                    setState(() {
                      showExpriredStocksOnly = value??false;
                    });
                  },
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
              child: _tableHead(context,"Stock Barcode"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Mnf Date"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Exp Date"),
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
              child: _tableHead(context,"Retail Price"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"Discount"),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: _tableHead(context,"#"),
            )
          ],
        ),
        ...searchStocks.map((e) => Container(
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
                    child: _tableBodyCell(context,OtherUtils.getDate(e.mnf_date)),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,OtherUtils.getDate(e.exp_date)),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,"${e.availbleQty } ${e.product.unit.name}"),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,"${e.wholesalePrice}"),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,"${e.retailPrice}"),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: _tableBodyCell(context,"${e.defaultDiscount}"),
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
                            child:StockCardWidget(stock: e),
                          ),
                        ) , context: context));
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ) ),
        // ResponsiveGridList(
        //   minItemWidth: 300,
        //   listViewBuilderOptions: ListViewBuilderOptions(
        //     shrinkWrap: true,
        //   ),
        //   children: searchStocks.map((e) =>  StockCardWidget(stock: e)).toList(),
        // ),
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