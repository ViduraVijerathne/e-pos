import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/widget/grn_card.dart';

import '../constrollers/insight_summery_controller.dart';
import '../models/grn.dart';
import 'loading_widget.dart';

class PaymentDueGrnViewWidget extends StatefulWidget {
  const PaymentDueGrnViewWidget({super.key});

  @override
  State<PaymentDueGrnViewWidget> createState() => _PaymentDueGrnViewWidgetState();
}

class _PaymentDueGrnViewWidgetState extends State<PaymentDueGrnViewWidget> {
  InsightSummery controller  = InsightSummery();

  List<GRN> grns = [];
  bool isLoading = false;
  void loadGrn()async{
    setState(() {
      isLoading = true;
    });
    grns =await controller.getPaymentDueGRNs();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    loadGrn();
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
          Text("Payment Due GRNs",style: FluentTheme.of(context).typography.subtitle,textAlign: TextAlign.center,),
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
                  Expanded(flex:3,child: Text("Qty",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("Supplier",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("value",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("Paid Amount",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("Due amount",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  const Expanded(
                    flex:1,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ),
          isLoading ? const Center(child: LoadingWidget(),) :const SizedBox(),

          ...grns.map((e) => Container(
            margin:const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: FluentTheme.of(context).accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10)
            ),
            child: ListTile(
              title: Text(e.product.name,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 14),),
              subtitle: Row(
                children: [
                  Expanded(flex:3,child: Text("${e.quantity}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("${e.supplier.name}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(flex:3,child: Text("${e.value}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12,)),),
                  Expanded(flex:3,child: Text("${e.paidAmount}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12,color: Colors.red)),),
                  Expanded(flex:3,child: Text("${e.douedAmount}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 12)),),
                  Expanded(
                    flex:1,
                    child: FilledButton(

                      child: Icon(FluentIcons.red_eye,size: 5),
                      onPressed: (){
                        Navigator.of(context).push(FluentDialogRoute(builder: (context) =>
                        Center(
                          child: Container(
                            width: 500,
                            child: GRNCard(grn: e, refresh: (){}, supplierOtherGRNs: (ex){}, productOtherGRNs: (ex){}),
                          ),
                        )

                            , context: context));
                      },
                    ),
                  ),


                ],
              ),
            ),
          ))

        ],
      ),
    );
  }
}
