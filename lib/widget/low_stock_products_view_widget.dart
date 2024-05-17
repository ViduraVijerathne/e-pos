import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/low_stock_model.dart';

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
  List<LowStockModel> stocks = [];
  bool isLoading = false;

  void loadStocks()async{
    setState(() {
      isLoading = true;
    });
    stocks = await controller.getLowStocks2();
    // stocks = await controller.getLowStocks();
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
                  Expanded(flex:3,child: Text("ID",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("Barcode",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("Main Category",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("Sub Category",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("available Qty",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),

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
                  Expanded(flex:3,child: Text("${e.product.id}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("${e.product.barcode}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 10)),),
                  Expanded(flex:3,child: Text("${e.product.mainCategory.name}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12,)),),
                  Expanded(flex:3,child: Text("${e.product.subCategory.name}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("${e.qty}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12,color: Colors.red,fontWeight: FontWeight.w700)),),
                ],
              ),
            ),
          ))

        ],
      ),
    );
  }
}
