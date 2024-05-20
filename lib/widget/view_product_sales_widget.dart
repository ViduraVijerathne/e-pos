import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:point_of_sale/models/product.dart';
import 'package:point_of_sale/utils/database.dart';
import 'package:point_of_sale/widget/loading_widget.dart';
import 'package:point_of_sale/widget/my_line_chart_widget.dart';

class ViewProductSalesWidget extends StatefulWidget {
  final Product product;
  const ViewProductSalesWidget({super.key, required this.product});

  @override
  State<ViewProductSalesWidget> createState() => _ViewProductSalesWidgetState();
}

class _ViewProductSalesWidgetState extends State<ViewProductSalesWidget> {
  InsightModes selectedMode = InsightModes.sales;
  bool isLoading = true;
  List<double> chartData = [];
  List<ViewProductSaleChartDataModel>  data = [];
  int gridLineLabelPrecision = 3;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  DateTime maxDate = DateTime.now();
  DateTime minDate = DateTime.now();

  DateTime maxiumValueDate = DateTime.now();
  double maxValue = 0;

  DateTime miniumValueDate = DateTime.now();
  double minValue = 0;
  double totalOfValue = 0;
  void loadData()async{
    setState(() {
      isLoading = true;
    });
    final conn =  MySQLDatabase().pool;
    String query = "SELECT (invoice_has_stock.invoice_unit_price- invoice_has_stock.discount)*SUM(invoice_has_stock.invoice_qty) AS sales ,SUM(invoice_has_stock.invoice_qty) AS qty,DATE(invoice.invoice_date) AS sale_date FROM invoice_has_stock INNER JOIN stock ON stock.id = invoice_has_stock.stock_id INNER JOIN invoice ON invoice_has_stock.invoice_invoice_id = invoice.invoice_id WHERE invoice_has_stock.stock_product_product_id = ${widget.product.id} GROUP BY DATE(invoice.invoice_date)";
    if(selectedMode == InsightModes.sales){
      query = "SELECT SUM(invoice_has_stock.invoice_qty) AS sales ,DATE(invoice.invoice_date) AS sale_date FROM invoice_has_stock INNER JOIN stock ON stock.id = invoice_has_stock.stock_id INNER JOIN invoice ON invoice_has_stock.invoice_invoice_id = invoice.invoice_id WHERE invoice_has_stock.stock_product_product_id = ${widget.product.id} GROUP BY DATE(invoice.invoice_date)";
    }
    final result = await conn.execute(query);
    int i = 0;
    for(var row in result.rows){
      chartData.add(double.parse(row.colByName("sales")!));
      data.add(
          ViewProductSaleChartDataModel(value: double.parse(row.colByName("sales")!), date: DateTime.parse(row.colByName("sale_date")!)
          ));

      if(DateTime.parse(row.colByName("sale_date")!).isAfter(maxDate)||i == 0){
        maxDate = DateTime.parse(row.colByName("sale_date")!);
      }
      if(DateTime.parse(row.colByName("sale_date")!).isBefore(minDate)|| i == 0){
        minDate = DateTime.parse(row.colByName("sale_date")!);
      }
      if(double.parse(row.colByName("sales")!) > maxValue || i ==0){
        maxValue = double.parse(row.colByName("sales")!);
        maxiumValueDate = DateTime.parse(row.colByName("sale_date")!);
      }

      if(double.parse(row.colByName("sales")!) < minValue || i ==0){
        minValue = double.parse(row.colByName("sales")!);
        miniumValueDate = DateTime.parse(row.colByName("sale_date")!);
      }

      totalOfValue = totalOfValue + double.parse(row.colByName("sales")!);

      i +=1;
    }

    // for(double value in chartData){
    //   if(value > maxValue){
    //     maxValue = value;
    //   }
    // }

    gridLineLabelPrecision = maxValue.toString().length;
    print(" MAX VALUE IS  ${maxValue}");
    print(" gridLineLabelPrecision IS  ${gridLineLabelPrecision}");
    setState(() {
      isLoading = false;
    });
  }
  void selectInsightMode(InsightModes mode){
    data.clear();
    chartData.clear();
    setState(() {
      selectedMode = mode;
    });
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 100,
                        child: ComboBox<InsightModes>(
                          value: selectedMode,
                          onChanged: (value) {
                            if(value !=null){
                              selectInsightMode(value);

                            }
                          },
                          items: InsightModes.values
                              .map((e) =>
                              ComboBoxItem<InsightModes>(value: e,child: Text(e.name.toUpperCase()),))
                              .toList(),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              child: Text("${widget.product.name.uppercaseFirst()} ${selectedMode.name.uppercaseFirst()}",
                  style: FluentTheme.of(context).typography.title,
                  textAlign: TextAlign.center),
            ),

            Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Button(
                      child:Icon(FluentIcons.chrome_close, color: Colors.red),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                )
            )
          ],
        ),
      ),
      content: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: FluentTheme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child:isLoading ? const LoadingWidget():  Sparkline(
                data:chartData,
                lineColor: FluentTheme.of(context).accentColor,
                lineWidth: 3,
                fillMode: FillMode.below,
                fillGradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    FluentTheme.of(context).accentColor.withOpacity(0.6),
                    FluentTheme.of(context).accentColor.withOpacity(0.0)
                  ],
                ),
                useCubicSmoothing: true,
                cubicSmoothingFactor: 0.2,
                gridLinelabelPrefix: selectedMode == InsightModes.sales ? " ${widget.product.unit.name} ": 'LKR ',
                gridLineLabelPrecision: gridLineLabelPrecision,
                enableGridLines: true,
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: FluentTheme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child:   Container(
                      decoration: BoxDecoration(
                        color: FluentTheme.of(context).accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: FluentTheme.of(context).accentColor,width: 1),
                      ),
                      child: ListTile(
                        title: Text("Total ${selectedMode.name.uppercaseFirst()}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
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
                        subtitle: isLoading? ProgressBar(): Text("${totalOfValue} ${selectedMode == InsightModes.sales?  widget.product.unit.name:'LKR'}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
                        trailing: Text("FROM ${DateFormat('yyyy-MM-dd').format(minDate)} \nTO ${DateFormat('yyyy-MM-dd').format(maxDate)}"),
                      ),
                    ),

                  ),
                  const SizedBox(width: 4,),
                  Expanded(
                    flex: 3,
                    child:   Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green,width: 1),
                      ),
                      child: ListTile(
                        title: Text("Maximum ${selectedMode.name.uppercaseFirst()}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
                        leading: Container(
                          padding:const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.green.withOpacity(0.2),
                          ),
                          child: Container(
                              padding:const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.green.withOpacity(0.2),
                              ),
                              child: const Icon(FluentIcons.product, size: 20, color: Colors.white,)),
                        ),
                        subtitle: isLoading? ProgressBar(): Text("${maxValue} ${selectedMode == InsightModes.sales?  widget.product.unit.name:'LKR'}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
                        trailing: Text("FROM ${DateFormat('yyyy-MM-dd').format(maxiumValueDate)} "),
                      ),
                    ),

                  ),
                  const SizedBox(width: 4,),
                  Expanded(
                    flex: 3,
                    child:   Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.red,width: 1),
                      ),
                      child: ListTile(
                        title: Text("Minimum ${selectedMode.name.uppercaseFirst()}",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
                        leading: Container(
                          padding:const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.red.withOpacity(0.2),
                          ),
                          child: Container(
                              padding:const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.red.withOpacity(0.2),
                              ),
                              child: const Icon(FluentIcons.product, size: 20, color: Colors.white,)),
                        ),
                        subtitle: isLoading? ProgressBar(): Text("${minValue} ${selectedMode == InsightModes.sales?  widget.product.unit.name:'LKR'} ",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontSize: 19),),
                        trailing: Text("FROM ${DateFormat('yyyy-MM-dd').format(miniumValueDate)} "),
                      ),
                    ),

                  ),
                  const SizedBox(width: 4,),
                  Expanded(
                    flex: 1,
                      child: Button(child: Text("Print"),onPressed: (){},)
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),

        ],
      ),
    );
  }
}

class ViewProductSaleChartDataModel{
  final double value;
  final DateTime date;
  ViewProductSaleChartDataModel({required this.value,required this.date});
}
