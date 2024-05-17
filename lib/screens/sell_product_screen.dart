import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:point_of_sale/models/customer.dart';
import 'package:point_of_sale/models/invoice_item.dart';
import 'package:point_of_sale/utils/barcodeGenerator.dart';
import 'package:point_of_sale/utils/printer.dart';
import 'package:point_of_sale/widget/stock_card.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:uuid/uuid.dart';

import '../models/invoice.dart';
import '../models/stock.dart';

class SellProductScreen extends StatefulWidget {
  const SellProductScreen({super.key});

  @override
  State<SellProductScreen> createState() => _SellProductScreenState();
}

class _SellProductScreenState extends State<SellProductScreen> {
  List<Stock> stocks = [];
  List<Stock> searchStock = [];
  List<InvoiceItem> invoiceItems = [];

  Stock? selectedStock;
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _itemDiscount = TextEditingController();
  final TextEditingController _itemValue = TextEditingController();
  final TextEditingController _itemGrandTotal = TextEditingController();
  final TextEditingController _itemTotal = TextEditingController();
  final TextEditingController _cashController = TextEditingController();
  double invoiceBalance = 0;

  void loadProducts() async {
    stocks.addAll(await Stock.getAll());
    searchStock.addAll(stocks);
    setState(() {});
  }

  void checkOut()async{

    if(invoiceItems.isNotEmpty){
      
      Customer customer = Customer(id: 1,address: "",name: "",contact: "");
      
      double discountTotal = 0;
      double grandTotal = 0; //total price without discount
      double paidAmount = double.parse(_cashController.text);
      double invoiceTotal = 0; //total price with discount
      
      for (InvoiceItem invoiceItem in invoiceItems){

        double unitPrice = invoiceItem.unitPrice;
        double unitDiscount = invoiceItem.discount;
        double unitFinalPrice = unitPrice - unitDiscount;
        double itemTotalPrice = unitFinalPrice* invoiceItem.quantity;


        grandTotal += invoiceItem.quantity * unitPrice;
        discountTotal += invoiceItem.quantity * unitDiscount;
      }

      invoiceTotal = grandTotal - discountTotal;
      Invoice invoice = Invoice(
        id: 0,
        barcode: BarcodeGenerator.generateRandomInvoiceBarcode(),
        customer: customer,
        items: invoiceItems,
        balance: invoiceBalance,
        invoiceDate: DateTime.now(),
        discountTotal: discountTotal,
        grandTotal: grandTotal,
        paidAmount: paidAmount,
        invoiceTotal: invoiceTotal
        
      );
      await invoice.insert();

      await Printer.printInvoice(invoice);

      setState(() {

      });

    }else{

    }

  }

  @override
  void initState() {
    if (mounted) {
      loadProducts();
    }
    super.initState();
  }

  void addToInvoice() {
    invoiceBalance = 0;
    _cashController.text = "0";
    if (selectedStock != null) {
      for(InvoiceItem i in invoiceItems){
        if(selectedStock!.id == i.stock.id){
          i.quantity += int.parse(_quantityController.text);
          clear();
          selectedStock = null;
          setState(() {});
          return;
        }
      }
      InvoiceItem invoiceItem = InvoiceItem(
          invoiceID: 0,
          grn: selectedStock!.grn,
          quantity: int.parse(_quantityController.text),
          product: selectedStock!.product,
          discount: double.parse(_itemDiscount.text),
          stock: selectedStock!,
          unitPrice: selectedStock!.retailPrice);
      invoiceItems.add(invoiceItem);
      clear();
      selectedStock = null;
      setState(() {});
    }
  }

  void removeInvoiceItem(InvoiceItem item){
    for(InvoiceItem i in invoiceItems){
      if(i.stock.id == item.stock.id){
        invoiceItems.remove(i);
        break;
      }
    }
    setState(() {

    });

  }


  double calculateInvoiceTotal(){
    double total = 0;
    for(InvoiceItem i in invoiceItems){
      double unitPrice = i.unitPrice;
      double unitDiscount = i.discount;
      double unitFinalPrice = unitPrice - unitDiscount;
      double itemTotalPrice = unitFinalPrice* i.quantity;
      total += itemTotalPrice;
    }
    return total;
  }

  void select(Stock stock) {
    selectedStock = stock;
    _barcodeController.text = stock.barcode;
    _productNameController.text = stock.product.name;
    _quantityController.text = "1";
    _itemDiscount.text = "${stock.defaultDiscount}";
    _itemValue.text = "${stock.retailPrice}";
    _itemTotal.text = "${stock.retailPrice - stock.defaultDiscount}";
    _itemGrandTotal.text = "${stock.retailPrice - stock.defaultDiscount}";
    setState(() {});
  }

  void clear() {
    selectedStock = null;
    _barcodeController.text = "";
    _productNameController.text = "";
    _quantityController.text = "0";
    _itemDiscount.text = "0.00";
    _itemValue.text = "0.00";
    _itemTotal.text = "0.00";
    _itemGrandTotal.text = "0.00";
    setState(() {});
  }

  void searchByBarcode(String value) {
    searchStock.clear();
    if (value.isNotEmpty) {
      for (Stock stock in stocks) {
        if (stock.barcode.startsWith(value)) {
          searchStock.add(stock);
        }
        if (stock.barcode == value) {
          select(stock);
        }
      }
    } else {
      searchStock.clear();
      searchStock.addAll(stocks);
      clear();
    }
    setState(() {});
  }

  void searchByProductName(String value) {
    searchStock.clear();
    if (value.isNotEmpty) {
      for (Stock stock in stocks) {
        if (stock.product.name.startsWith(value)) {
          searchStock.add(stock);
        }
        if (stock.product.name == value) {
          select(stock);
        }
      }
    } else {
      searchStock.clear();
      searchStock.addAll(stocks);
      clear();
    }
    setState(() {});
  }

  void calculateBalance(){
    double cash = double.parse(_cashController.text);
    invoiceBalance = cash - calculateInvoiceTotal();
    setState(() {

    });
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
              "Sell Products",
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
                    label: "Barcode",
                    child: TextBox(
                      placeholder: "Barcode",
                      controller: _barcodeController,
                      onChanged: searchByBarcode,
                    ),
                  ),
                  InfoLabel(
                    label: "Product Name",
                    child: TextBox(
                        placeholder: "Product Name",
                        onChanged: searchByProductName,
                        controller: _productNameController),
                  ),
                  InfoLabel(
                    label: "Quantity",
                    child: TextBox(
                        placeholder: "Quantity",
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _quantityController),
                  ),
                  InfoLabel(
                    label: "Discount For One Item",
                    child: TextBox(
                        placeholder: "Discount", controller: _itemDiscount),
                  ),
                  InfoLabel(
                    label: "Item Value",
                    child: TextBox(
                        placeholder: "Item Value",
                        enabled: false,
                        controller: _itemValue),
                  ),
                  InfoLabel(
                    label: "Item Total",
                    child: TextBox(
                        placeholder: "Item  Total",
                        enabled: false,
                        controller: _itemTotal),
                  ),
                  InfoLabel(
                    label: "Item Grand Total",
                    child: TextBox(
                        placeholder: "Item Grand Total",
                        enabled: false,
                        controller: _itemGrandTotal),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 32,
                        child: FilledButton(
                            onPressed: addToInvoice,
                            child: Text(
                              "ADD",
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
            )
          ],
        ),
      ),
      content: Container(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              // child: ResponsiveGridList(
              //   minItemWidth: 300,
              //   children:
              //       searchStock.map((e) => StockCardWidget(stock: e)).toList(),
              // ),
              child: ScaffoldPage.scrollable(
                header: Container(
                  margin:const EdgeInsets.all(5),
                  padding:const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("Stock Barcode",style: FluentTheme.of(context).typography.bodyStrong,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Product Barcode",style: FluentTheme.of(context).typography.bodyStrong,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Available Qty",style: FluentTheme.of(context).typography.bodyStrong,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Unit Price",style: FluentTheme.of(context).typography.bodyStrong,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Discount",style: FluentTheme.of(context).typography.bodyStrong,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("#",style: FluentTheme.of(context).typography.bodyStrong,),
                      )
                    ],
                  ),
                ),
                padding:const EdgeInsets.all(0),
                children: [
                  ...searchStock.map((e) => Container(
                    margin:const EdgeInsets.all(5),
                    padding:const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: FluentTheme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ListTile(
                      title: Text(e.product.name,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19)),
                      subtitle: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(e.barcode,style: FluentTheme.of(context).typography.bodyStrong,),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(e.product.barcode,style: FluentTheme.of(context).typography.bodyStrong,),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("X ${e.availbleQty}",style: FluentTheme.of(context).typography.bodyStrong,),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("${e.retailPrice}",style: FluentTheme.of(context).typography.bodyStrong,),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("${e.defaultDiscount}",style: FluentTheme.of(context).typography.bodyStrong,),
                          ),
                          Expanded(
                              flex: 1,
                              child:Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Button(
                                        child: Text("View"),
                                        onPressed: () {
                                          Navigator.of(context).push(FluentDialogRoute(builder: (context) => StockCardWidget(stock: e), context: context));
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child:e.exp_date.isBefore(DateTime.now())?Text("Expired",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(color: Colors.red),) : e.availbleQty > 0? Checkbox(
                                        checked: selectedStock == null ? false: selectedStock!.id == e.id,
                                        onChanged: (value) {
                                          if(value !=null){
                                            if(value){
                                              selectedStock = e;
                                              select(e);
                                              setState(() {

                                              });
                                            }else{
                                              selectedStock = null;

                                              setState(() {

                                              });
                                            }
                                          }
                                        },
                                      ):Text("No Stock",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(color: Colors.red),),
                                    ),
                                  )
                                ],
                              )
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10)),
                child: ScaffoldPage.scrollable(
                  bottomBar: Container(
                    padding: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InfoLabel(
                                label: "Total", child: Text("${calculateInvoiceTotal()}")),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InfoLabel(
                                label: "Cash",
                                child: TextBox(
                                  controller: _cashController,
                                  placeholder: "0.00",
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value){
                                    calculateBalance();
                                  },
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InfoLabel(
                                label: "Balance",
                                child: Text(
                                  "${invoiceBalance}",
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FilledButton(
                                child: Text(
                                  "CHECKOUT",
                                  style: FluentTheme.of(context)
                                      .typography
                                      .bodyStrong!
                                      .copyWith(color: Colors.white),
                                ),
                                onPressed:checkOut),
                          ),
                        ),
                      ],
                    ),
                  ),
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "INVOICE ITEMS",
                          style: FluentTheme.of(context).typography.title,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin:
                      const EdgeInsets.only(top: 10, left: 15, right: 5),
                      child:  Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("Qty",style: FluentTheme.of(context).typography.bodyStrong,),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("Discount",style: FluentTheme.of(context).typography.bodyStrong,),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("unitPrice",style: FluentTheme.of(context).typography.bodyStrong,),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text("Price",style: FluentTheme.of(context).typography.bodyStrong,),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                                "ItemTotal",style: FluentTheme.of(context).typography.bodyStrong,),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text(
                                ""),
                          ),
                        ],
                      ),
                    ),
                    ...invoiceItems.map((e) => Container(
                          margin:
                              const EdgeInsets.only(top: 10, left: 5, right: 5),
                          decoration: BoxDecoration(
                              color: FluentTheme.of(context)
                                  .selectionColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Text(e.product.name,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text("X${e.quantity}",style: FluentTheme.of(context).typography.bodyStrong,),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("${e.discount}",style: FluentTheme.of(context).typography.bodyStrong,),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("${e.unitPrice}",style: FluentTheme.of(context).typography.bodyStrong,),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("${e.unitPrice - e.discount}",style: FluentTheme.of(context).typography.bodyStrong,),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                      "${(e.unitPrice - e.discount) * e.quantity}",style: FluentTheme.of(context).typography.bodyStrong,),
                                ),
                              ],
                            ),
                            trailing: FilledButton(
                              style: ButtonStyle(
                                  backgroundColor: ButtonState.all(Colors.red)),
                              child:
                                  Icon(FluentIcons.remove, color: Colors.white),
                              onPressed: () {
                                removeInvoiceItem(e);
                              },
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
