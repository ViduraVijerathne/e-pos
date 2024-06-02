import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/invoice.dart';
import 'package:point_of_sale/models/invoice_item.dart';
import 'package:point_of_sale/utils/other_utils.dart';
import 'package:point_of_sale/widget/customer_card.dart';
import 'package:point_of_sale/widget/stock_card.dart';

class InvoiceViewCard extends StatefulWidget {
  final Invoice invoice;

  const InvoiceViewCard({super.key, required this.invoice});

  @override
  State<InvoiceViewCard> createState() => _InvoiceViewCardState();
}

class _InvoiceViewCardState extends State<InvoiceViewCard> {
  List<InvoiceItem> items = [];

  void loadInvoiceItems() async {
    if (widget.invoice.items.isEmpty) {
     items = await InvoiceItem.getByInvoiceID(widget.invoice.id.toString());
    } else {
      items = widget.invoice.items;
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    loadInvoiceItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          height: 500,
          width: 500,
          decoration: BoxDecoration(
            color: FluentTheme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ScaffoldPage.scrollable(
            padding: EdgeInsets.all(10),
              header: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text("INVOICE",
                            style: FluentTheme.of(context).typography.title,
                            textAlign: TextAlign.center)),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("ID : ${widget.invoice.id}",
                            style: FluentTheme.of(context).typography.subtitle,
                            textAlign: TextAlign.center)),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            "Date : ${OtherUtils.formatDateTime(widget.invoice.invoiceDate)}",
                            style: FluentTheme.of(context).typography.subtitle,
                            textAlign: TextAlign.center)),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Button(
                          onPressed: (){
                            Navigator.of(context).push(FluentDialogRoute(builder: (context) => Center(child: SizedBox(height: 500,width: 500,child: CustomerCard(customer:widget.invoice.customer))), context: context));
                          },
                          child: Text(
                              "Customer : ${widget.invoice.customer.name}",
                              style: FluentTheme.of(context).typography.subtitle,
                              textAlign: TextAlign.center),
                        )),
                    
                  ],
                ),
              ),
            bottomBar: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [

                  Expanded(
                    flex: 1,
                    child: Text("${items.length} Items",style: FluentTheme.of(context).typography.bodyStrong,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("Total : ${widget.invoice.grandTotal}",style: FluentTheme.of(context).typography.bodyStrong,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("Discounts : ${widget.invoice.discountTotal}",style: FluentTheme.of(context).typography.bodyStrong,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text("Grand Total : ${widget.invoice.invoiceTotal}",style: FluentTheme.of(context).typography.bodyStrong,),
                  ),
                ],
              ),
            ),
              children:[
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
                            "#"),
                      ),
                    ],
                  ),
                ),
                ...items.map((e) => Container(
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
                        Expanded(
                          flex: 1,
                          child: Button(

                            child:Text("Stock"),
                            onPressed: () {
                              Navigator.of(context).push(FluentDialogRoute(builder: (context) => Center(child: Container(width:500,child: StockCardWidget(stock: e.stock))), context: context));
                            },
                          ),
                        ),
                      ],
                    ),

                  ),
                ))
              ],

          )),
    );
  }
}
