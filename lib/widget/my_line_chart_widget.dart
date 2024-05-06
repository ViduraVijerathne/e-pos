import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/constrollers/chart_controller.dart';
import 'package:point_of_sale/widget/loading_widget.dart';

// import 'package:syncfusion_flutter_charts/charts.dart';
class MyLineChartWidget extends StatefulWidget {
  const MyLineChartWidget({super.key});

  @override
  State<MyLineChartWidget> createState() => _MyLineChartWidgetState();
}

class _MyLineChartWidgetState extends State<MyLineChartWidget> {
  InsightModes selectedMode = InsightModes.sales;
  InsightTimes selectedTime = InsightTimes.total;
  final controller = ChartController();
  bool isLoading = false;
  List<double> chartData = [];
  int gridLineLabelPrecision = 3;
  void loadData()async{
    setState(() {
      isLoading = true;
    });
    chartData.clear();

    chartData.addAll(await controller.getData(selectedMode: selectedMode,selectedTime: selectedTime));

    double maxValue = 0;
    for(double value in chartData){
      if(value > maxValue){
        maxValue = value;
      }
    }

    gridLineLabelPrecision = maxValue.toString().length;
    print(" MAX VALUE IS  ${maxValue}");
    print(" gridLineLabelPrecision IS  ${gridLineLabelPrecision}");

    setState(() {
      isLoading = false;
    });
  }

  void selectInsightMode(InsightModes mode){
    setState(() {
      isLoading = true;
    });
    selectedMode = mode;
    loadData();
  }

  void selectInsightTime(InsightTimes time){
    setState(() {
      isLoading = true;
    });
    selectedTime = time;
    loadData();
  }

  @override
  void initState() {
    loadData();
    super.initState();
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
                    child: ComboBox<InsightTimes>(
                      value: selectedTime,
                      onChanged: (value) {
                        if(value !=null){
                          selectInsightTime(value);

                        }
                      },
                      items: InsightTimes.values
                          .map((e) =>
                          ComboBoxItem<InsightTimes>(value: e,child: Text(e.name.toUpperCase()),))
                          .toList(),
                    ),
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
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

                ],
              ),
            ),
            Expanded(
              child: Text("${selectedTime.name.uppercaseFirst()} ${selectedMode.name.uppercaseFirst()}",
                  style: FluentTheme.of(context).typography.title,
                  textAlign: TextAlign.center),
            ),
            Expanded(
              child: isLoading ? const SizedBox():const SizedBox()
             )
          ],
        ),
      ),
      content: Center(
        child: Container(
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
            gridLinelabelPrefix: 'LKR ',
            gridLineLabelPrecision: gridLineLabelPrecision,
            enableGridLines: true,
          ),
        ),
      ),
    );
  }
}

enum InsightModes {
  sales,
  profit,
}

enum InsightTimes {
  total,
  daily,
  monthly,
  weekly,
  yearly,

}
