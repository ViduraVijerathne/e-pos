import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/constrollers/insight_summery_controller.dart';

class InsightSummeryWidget extends StatefulWidget {
  const InsightSummeryWidget({super.key});

  @override
  State<InsightSummeryWidget> createState() => _InsightSummeryWidgetState();
}

class _InsightSummeryWidgetState extends State<InsightSummeryWidget> {
  InsightSummery controller = InsightSummery();

  int productCount = 0;
  bool isLoadingProductCount = true;

  double totalSales = 0;
  bool isLoadingTotalSales = true;

  double totalRevenue = 0;
  bool isLoadingTotalRevenue = true;

  int invoiceCount = 0;
  bool isLoadingInvoiceCount = true;


  void loadProductCount()async{
    productCount = await controller.getTotalProductCount();
    setState(() {
      isLoadingProductCount = false;
    });
  }

  void loadTotalSales()async{
    totalSales = await controller.getTotalSales();
    setState(() {
      isLoadingTotalSales = false;
    });
  }
  void loadTotalRevenue()async{
    totalRevenue = await controller.getTotalRevenue();
    setState(() {
      isLoadingTotalRevenue = false;
    });
  }

  void loadInvoicesCount()async{
    invoiceCount = await controller.getInvoiceCount();
    setState(() {
      isLoadingInvoiceCount = false;
    });
  }
  @override
  void initState() {
    loadProductCount();
    loadTotalSales();
    loadTotalRevenue();
    loadInvoicesCount();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: FluentTheme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        children: [
          const SizedBox(height: 10,),
          Text("Insights Summary",style: FluentTheme.of(context).typography.subtitle,textAlign: TextAlign.center,),
          const SizedBox(height: 10,),
          const Divider(),
          const SizedBox(height: 10,),
          ListTile(
            title: Text("Total Products",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
            leading: Container(
              padding:const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: FluentTheme.of(context).accentColor.withOpacity(0.2),
              ),
              child: Container(
                  padding:const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: FluentTheme.of(context).accentColor.withOpacity(0.2),
                  ),
                  child: const Icon(FluentIcons.product, size: 20, color: Colors.white,)),
            ),
            subtitle: isLoadingProductCount? ProgressBar(): Text("${productCount}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
          ),
          ListTile(
            title: Text("Today Sales",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
            leading: Container(
              padding:const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: FluentTheme.of(context).accentColor.withOpacity(0.2),
              ),
              child: Container(
                  padding:const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: FluentTheme.of(context).accentColor.withOpacity(0.2),
                  ),
                  child: const Icon(FluentIcons.money, size: 20, color: Colors.white,)),
            ),
            subtitle: isLoadingTotalSales? ProgressBar(): Text("LKR ${totalSales}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
          ),
          ListTile(
            title: Text("Today Revenue",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
            leading: Container(
              padding:const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: FluentTheme.of(context).accentColor.withOpacity(0.2),
              ),
              child: Container(
                height: 42,
                  width: 42,
                  padding:const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: FluentTheme.of(context).accentColor.withOpacity(0.2),
                  ),
                  child: const Center(child: Text('\$',style: TextStyle(fontSize: 20),textAlign: TextAlign.center,))),
            ),
            subtitle: isLoadingTotalRevenue? ProgressBar(): Text("LKR ${totalRevenue}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
          ),
          ListTile(
            title: Text("Today Invoices",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
            leading: Container(
              padding:const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: FluentTheme.of(context).accentColor.withOpacity(0.2),
              ),
              child: Container(
                  padding:const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: FluentTheme.of(context).accentColor.withOpacity(0.2),
                  ),
                  child: const Icon(FluentIcons.news, size: 20, color: Colors.white,)),
            ),
            subtitle: isLoadingInvoiceCount? ProgressBar(): Text("${invoiceCount}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
          ),
        ],
      ),
    );
  }
}
