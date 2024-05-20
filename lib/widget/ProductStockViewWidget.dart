import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/grn.dart';
import 'package:point_of_sale/models/product.dart';
import 'package:point_of_sale/models/stock_minimulistic_model.dart';
import 'package:point_of_sale/utils/other_utils.dart';
import 'package:point_of_sale/widget/grn_card.dart';
import 'package:point_of_sale/widget/loading_widget.dart';
import 'package:point_of_sale/widget/view_product_sales_widget.dart';

class ProductStockViewWidget extends StatefulWidget {
  final Product product;
  const ProductStockViewWidget({super.key, required this.product});

  @override
  State<ProductStockViewWidget> createState() => _ProductStockViewWidgetState();
}

class _ProductStockViewWidgetState extends State<ProductStockViewWidget> {
  List<StockMin> stocks = [];
  bool isLoading = true;

  void loadStocks()async{
    stocks.addAll(await StockMin.getAllByProductID(widget.product.id));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadStocks();
    super.initState();
  }
  void ViewGRN(int grnID)async{
    GRN grn = await GRN.getByID(grnID.toString());
    Navigator.of(context).push(FluentDialogRoute(builder: (context) =>Center(child: SizedBox(width: 500,height: 700, child: GRNCard(grn: grn, refresh: (){}, supplierOtherGRNs: (supplier){}, productOtherGRNs: (p0) {},))) , context: context));
  }


  @override
  Widget build(BuildContext context) {
    var titleFontStyle  = FluentTheme.of(context).typography.bodyStrong!.copyWith(fontWeight: FontWeight.w700);
    double width = 1000;
    return Center(
      child:SizedBox(
        height: 500,
        width: width,
        child: ScaffoldPage.scrollable(
          header: Container(
            color: FluentTheme.of(context).cardColor,
            height: 100,
            width: width,
            child: Column(
              children: [
                SizedBox(height: 10,),
                Text("'${widget.product.name}' Stocks List",style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontWeight: FontWeight.w700),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(top: 10,bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: FluentTheme.of(context).accentColor.withOpacity(0.2)
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text("ID",style: titleFontStyle,textAlign: TextAlign.center,),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("Stock Barcode",style: titleFontStyle,textAlign: TextAlign.center,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Available Qty \n (${widget.product.unit.name})",style: titleFontStyle,textAlign: TextAlign.center,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("WholeSale Price",style: titleFontStyle,textAlign: TextAlign.center,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Retail Price",style: titleFontStyle,textAlign: TextAlign.center,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("Default Discount",style: titleFontStyle,textAlign: TextAlign.center,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("MnfDate",style: titleFontStyle,textAlign: TextAlign.center,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("ExpDate",style: titleFontStyle,textAlign: TextAlign.center,),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text("#",style: titleFontStyle,textAlign: TextAlign.center,),
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
          children: isLoading? [const Center(child: LoadingWidget(),)]: stocks.isEmpty? [const SizedBox(height: 50,),const Center(child: Text("No Stocks Found"),)]: stocks.map((e) => Container(
            height: 100,
            width: width,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text("${e.id}",style: titleFontStyle,textAlign: TextAlign.center,),
                ),
                Expanded(
                  flex: 2,
                  child: Text("${e.barcode}",style: titleFontStyle,textAlign: TextAlign.center,),
                ),
                Expanded(
                  flex: 1,
                  child: Text("${e.qty}",style: titleFontStyle,textAlign: TextAlign.center,),
                ),
                Expanded(
                  flex: 1,
                  child: Text("${e.wholesalePrice}",style: titleFontStyle,textAlign: TextAlign.center,),
                ),
                Expanded(
                  flex: 1,
                  child: Text("${e.retailPrice}",style: titleFontStyle,textAlign: TextAlign.center,),
                ),
                Expanded(
                  flex: 1,
                  child: Text("${e.discount}",style: titleFontStyle,textAlign: TextAlign.center,),
                ),
                Expanded(
                  flex: 1,
                  child: Text(OtherUtils.getDate(e.mnf_date),style: titleFontStyle,textAlign: TextAlign.center,),
                ),
                Expanded(
                  flex: 1,
                  child: Text(OtherUtils.getDate(e.exp_date),style: titleFontStyle,textAlign: TextAlign.center,),
                ),
                Expanded(
                  flex: 1,
                  child: Button(
                    child: Text("View GRN"),
                    onPressed: (){
                      ViewGRN(e.grn_id);
                    },
                  ),
                ),

              ],
            ),
          )).toList(),
        ),
      ),
    );
  }
}
