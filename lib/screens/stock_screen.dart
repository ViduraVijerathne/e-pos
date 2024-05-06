import "package:fluent_ui/fluent_ui.dart";
import "package:point_of_sale/constrollers/stock_search_controller.dart";
import "package:point_of_sale/widget/stock_card.dart";
import "package:responsive_grid_list/responsive_grid_list.dart";

import "../models/product.dart";
import "../models/stock.dart";

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

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

  void search() {
    print(stocks.length);
    StockSearchController controller = StockSearchController(stock: stocks);

    if(_productBarcodeController.text.isNotEmpty){
      print("searchProductBarcode");
      controller.searchByProductBarcode(_productBarcodeController.text);
    }
    if(_stockBarcodeController.text.isNotEmpty){
      controller.searchByStockBarcode(_stockBarcodeController.text);
    }
    if(priceLessThan >0){
      controller.searchByPriceLessThan(priceGraterThan);
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
    searchStocks.addAll(controller.getStock());
    setState(() {

    });

  }

  void dateFilter() {}

  void clear() {}

  void loadStocks() async {
    searchStocks.addAll(await Stock.getAll());
    stocks.addAll(searchStocks);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    loadStocks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
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
        ResponsiveGridList(
          minItemWidth: 300,
          listViewBuilderOptions: ListViewBuilderOptions(
            shrinkWrap: true,
          ),
          children: searchStocks.map((e) =>  StockCardWidget(stock: e)).toList(),
        ),
      ],
    );
  }
}
