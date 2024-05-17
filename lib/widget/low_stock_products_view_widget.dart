import 'package:fluent_ui/fluent_ui.dart';

import '../constrollers/insight_summery_controller.dart';
import '../models/stock.dart';
import '../utils/other_utils.dart';
import 'loading_widget.dart';

class LowStockProductsViewWidget extends StatefulWidget {
  const LowStockProductsViewWidget({super.key});

  @override
  State<LowStockProductsViewWidget> createState() => _LowStockProductsViewWidgetState();
}

class _LowStockProductsViewWidgetState extends State<LowStockProductsViewWidget> {
  InsightSummery controller= InsightSummery();
  List<Stock> stocks = [];
  bool isLoading = false;

  void loadStocks()async{
    setState(() {
      isLoading = true;
    });
    stocks = await controller.getLowStocks();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadStocks();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        children: [
          const SizedBox(height: 10,),
          Text("Low Stocks Products",style: FluentTheme.of(context).typography.subtitle,textAlign: TextAlign.center,),
          const SizedBox(height: 10,),
          const Divider(),
          const SizedBox(height: 10,),
          Container(
            margin:const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: FluentTheme.of(context).accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10)
            ),
            child:  ListTile(

              title: Row(
                children: [
                  Expanded(flex:3,child: Text("QTY",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("Wholesale",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("RetailPrice",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("Exp Date ",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("Added Date ",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),

                ],
              ),
            ),
          ),
          isLoading ? const Center(child: LoadingWidget(),) : stocks.isEmpty ? Container(
            margin:const EdgeInsets.only(top: 50,),
            child: Center(child: Text("Nothings To Show",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 20,color: Colors.red.withOpacity(0.5)),)),
          )  :const SizedBox(),

          ...stocks.map((e) => Container(
            margin:const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: FluentTheme.of(context).accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              title: Text(e.product.name,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 14),),
              subtitle: Row(
                children: [
                  Expanded(flex:3,child: Text("${e.availbleQty}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("${e.grn.wholesalePrice}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("${e.retailPrice}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12,)),),
                  Expanded(flex:3,child: Text("${OtherUtils.getDate(e.exp_date)}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12,color: Colors.red)),),
                  Expanded(flex:3,child: Text("${OtherUtils.getDate(e.grn.grnDate)}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),



                ],
              ),
            ),
          ))


        ],
      ),
    );
  }
}
