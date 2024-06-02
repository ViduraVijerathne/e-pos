import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/constrollers/invoice_search_controller.dart';
import 'package:point_of_sale/models/customer.dart';
import 'package:point_of_sale/models/invoice.dart';
import 'package:point_of_sale/utils/other_utils.dart';
import 'package:point_of_sale/view_models/invoice_view.dart';
import 'package:point_of_sale/widget/invoiceViewCard.dart';
import 'package:point_of_sale/widget/loading_widget.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../models/product.dart';
import '../models/stock.dart';
class InvoiceScreen extends StatefulWidget {
  final Customer? customer;
  const InvoiceScreen({super.key, this.customer});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  List<InvoiceViewModel> searchInvoice = [];
  List<InvoiceViewModel> invoices = [];
  List<Customer> customers = [];
  List<Product> products = [];
  bool isLoading = false;
  bool isLoadingMoreData = false;

  final ScrollController _scrollController  = ScrollController();

  final TextEditingController _invoiceIDController  = TextEditingController();
  final TextEditingController _barcodeController  = TextEditingController();
  final TextEditingController _stockBarcodeController =TextEditingController();
  final TextEditingController _customerController =TextEditingController();
  final TextEditingController _productController =TextEditingController();
  Customer? _selectedCustomer;
  Product? _selectedProduct;




  void loadInvoices()async{
    setState(() {
      isLoading  = true;
    });
    invoices = await InvoiceViewModel.getAllLimit();
    searchInvoice.addAll(invoices);
    setState(() {
      isLoading  = false;
    });
  }

  void loadMoreInvoices({int limit = 20})async{
    setState(() {
      isLoadingMoreData  = true;
    });

    List<InvoiceViewModel> items = await InvoiceViewModel.getAllLimit(limit: limit);
    var count = 0;
    var beforeCount = invoices.length;
    for(var i in items){
      count++;
      if(count >=beforeCount){
        invoices.add(i);
        searchInvoice.add(i);
      }
    }

    setState(() {
      isLoadingMoreData  = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      bool isBottom = _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
      if (isBottom && !isLoading) {
        loadMoreInvoices(limit:searchInvoice.length+20); // Load more data when at the bottom
      }
    }
  }

  void viewInvoice(int id)async{
    Invoice invoice = await Invoice.getByID(id);
    Navigator.of(context).push(FluentDialogRoute(builder: (context) => InvoiceViewCard(invoice: invoice), context: context));
  }

  @override
  void initState() {
    _scrollController.addListener(_onScroll); // Add scroll listener
    if(mounted){
      if(widget.customer != null){
        _selectedCustomer = widget.customer!;
        _customerController.text = widget.customer!.name;
        search();
      }else{
        loadInvoices();
      }


    }

    super.initState();
  }

  final List<String> tableTitles = [
    "ID",
    "Barcode",
    "Customer Name",
    "Invoice Total",
    "Discount",
    "Grand Total",
    "Paid Amount",
    "Balance",
    "Date Time",
    "#",
  ];
  void clear()async{
    _invoiceIDController.clear();
    _barcodeController.clear();
    _stockBarcodeController.clear();
    _selectedCustomer = null;
    _selectedProduct = null;
    searchInvoice.clear();
    searchInvoice.addAll(invoices);
    setState(() {

    });

  }
  void search()async{
    InvoiceSearchController controller = InvoiceSearchController();
    if(_invoiceIDController.text.isNotEmpty){
      controller.searchByID(_invoiceIDController.text);
    }
    if(_barcodeController.text.isNotEmpty){
      controller.searchByBarcode(_barcodeController.text);
    }
    if(_selectedCustomer != null){
      controller.searchByCustomer(_selectedCustomer!.id.toString());
    }
    searchInvoice.clear();
    searchInvoice.addAll(await controller.searchResults());
    setState(() {

    });

  }
  void loadCustomer(String text)async{
    if(text.length > 2){
      customers.clear();
      customers.addAll(await Customer.search(text));
      setState(() {

      });
    }
  }
  void loadProduct(String text)async{
    if(text.length > 2){
      products.clear();
      products.addAll(await Product.search(text));
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        child: Row(
          children: [
            Flexible(
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InfoLabel(
                  label: "ID",
                  child: TextBox(placeholder: "INVOICE ID",controller: _invoiceIDController),
                ),
              ),
            ),
            Flexible(
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InfoLabel(
                  label: "Barcode",
                  child: TextBox(placeholder: "Barcode",controller: _barcodeController,),
                ),
              ),
            ),
            Flexible(
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: InfoLabel(
                  label: "Customer",
                  child: AutoSuggestBox<Customer>(
                    controller: _customerController,
                    enabled: widget.customer != null ? false : true,
                    items:customers.map((e) => AutoSuggestBoxItem<Customer>(value: e, label: "${e.name} : ${e.contact}")).toList(),
                    onChanged: (text, reason) {
                      if(reason == TextChangedReason.userInput){
                        loadCustomer(text);
                      }
                      if(text.isEmpty){
                        _selectedCustomer = null;
                        setState(() {});
                      }
                    },
                    onSelected: (value) {
                      _selectedCustomer = value.value;
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            // Flexible(
            //   child:Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 5),
            //     child: InfoLabel(
            //       label: "Product",
            //       child: AutoSuggestBox<Product>(
            //         controller: _productController,
            //         items:products.map((e) => AutoSuggestBoxItem<Product>(value: e, label: "${e.name}")).toList(),
            //         onChanged: (text, reason) {
            //           if(reason == TextChangedReason.userInput){
            //             loadProduct(text);
            //           }
            //         },
            //         onSelected: (value) {
            //           _selectedProduct = value.value;
            //           setState(() {});
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            // Flexible(
            //   child:Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 5),
            //     child: InfoLabel(
            //       label: "Stock Barcode",
            //       child: TextBox(placeholder: " Stock Barcode",controller: _stockBarcodeController,),
            //     ),
            //   ),
            // ),
            Flexible(
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Flexible(
                      flex:1,
                      child: FilledButton(
                        onPressed: search,
                        child: Text("Search",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Flexible(
                      flex:1,
                      child: FilledButton(
                        style: ButtonStyle(
                          backgroundColor: ButtonState.all(Colors.red)
                        ),
                        onPressed:clear,
                        child: Text("Clear",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(color: Colors.white)),
                      ),
                    )
                  ],
                )
              ),
            ),


          ],
        ),
      ),
     content: isLoading ? const LoadingWidget() :ListView(
       controller: _scrollController,
       children: [
         Container(
           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
           margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
           decoration: BoxDecoration(
               color: FluentTheme.of(context).accentColor,
               border: Border.all(color: Colors.black.withOpacity(0.2)),
               borderRadius: BorderRadius.circular(10)
           ),

           child: Row(
             children: tableTitles.map((e) => Expanded(
               flex: 1,
               child: Text(e,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 15),textAlign: TextAlign.center),
             ),).toList(),
           ),
         ),

         ...searchInvoice.map((e) =>
             Container(
               padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
               margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
               decoration: BoxDecoration(
                 color: FluentTheme.of(context).selectionColor.withOpacity(0.1),
                 border: Border.all(color: Colors.black.withOpacity(0.2)),
                 borderRadius: BorderRadius.circular(10)
               ),
               child: Row(
                 children: [
                   Expanded(
                     flex: 1,
                     child: Text(e.id.toString(),style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 15),textAlign: TextAlign.center),
                   ),
                   Expanded(
                     flex: 1,
                     child: Text(e.barcode,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 15),textAlign: TextAlign.center),
                   ),
                   Expanded(
                     flex: 1,
                     child: Text(e.customer.name,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 15),textAlign: TextAlign.center),
                   ),
                   Expanded(
                     flex: 1,
                     child: Text(e.invoiceTotal.toString(),style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 15),textAlign: TextAlign.center),
                   ),
                   Expanded(
                     flex: 1,
                     child: Text(e.discountTotal.toString(),style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 15),textAlign: TextAlign.center),
                   ),
                   Expanded(
                     flex: 1,
                     child: Text(e.grandTotal.toString(),style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 15),textAlign: TextAlign.center),
                   ),
                   Expanded(
                     flex: 1,
                     child: Text(e.paidAmount.toString(),style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 15),textAlign: TextAlign.center),
                   ),
                   Expanded(
                     flex: 1,
                     child: Text(e.balance.toString(),style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 15),textAlign: TextAlign.center),
                   ),
                   Expanded(
                     flex: 1,
                     child: Text(OtherUtils.formatDateTime(e.invoiceDate),style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 15),textAlign: TextAlign.center),
                   ),
                   Expanded(
                       flex: 1,
                       child:Button(
                         child: Text("View"),
                         onPressed: () {
                           viewInvoice(e.id);
                         },
                       )
                   ),
                 ],
               ),
             )
         ),
         isLoadingMoreData? const LoadingWidget() : Container(),

       ],
     )
    );
  }
}
