import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/widget/insight_summery_widget.dart';
import 'package:point_of_sale/widget/low_stock_products_view_widget.dart';
import 'package:point_of_sale/widget/my_line_chart_widget.dart';

import '../models/users.dart';
import '../widget/expired_stock_view_widget.dart';
import '../widget/payment_due_grn_view_widget.dart';

class DashboardScreen extends StatefulWidget {
  static UserAccess access = UserAccess.DASHBOARD;
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Row(
        children: [
          Expanded(
            flex: 2,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: FluentTheme.of(context).cardColor
                      ),
                        child: const MyLineChartWidget(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: PaymentDueGrnViewWidget(),
                        ),
                        const Expanded(
                          child:LowStockProductsViewWidget(),
                        )
                      ],
                    )),

                ],
              ),
          ),
          const Expanded(
            flex: 1,
            child: Column(
              children: [
                Flexible(child: InsightSummeryWidget()),
                Flexible(
                  child: ExpiredStockViewWidget()
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
