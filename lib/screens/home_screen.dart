import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as WindowsIcons;
import 'package:point_of_sale/main.dart';
import 'package:point_of_sale/screens/add_customer.dart';
import 'package:point_of_sale/screens/add_grn_screen.dart';
import 'package:point_of_sale/screens/add_product_screen.dart';
import 'package:point_of_sale/screens/add_supplier.dart';
import 'package:point_of_sale/screens/customer_screen.dart';
import 'package:point_of_sale/screens/dashboard_screen.dart';
import 'package:point_of_sale/screens/grn_screen.dart';
import 'package:point_of_sale/screens/invoices_screen.dart';
import 'package:point_of_sale/screens/product_screen.dart';
import 'package:point_of_sale/screens/sell_product_screen.dart';
import 'package:point_of_sale/screens/settings_screen.dart';
import 'package:point_of_sale/screens/stock_screen.dart';
import 'package:point_of_sale/screens/suppliers_screen.dart';
import 'package:point_of_sale/utils/app_data.dart';
import 'package:point_of_sale/widget/loading_widget.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  void changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  PaneItem customPaneItem({required IconData icon,required String title,required Widget body}) {
    return PaneItem(
      icon:  Icon(icon,size: 24,color: FluentTheme.of(context).selectionColor,),
      title: Text(title,style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontWeight: FontWeight.w500),),
      body: body,

    );
  }
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: Hero(
          tag: "LOGO",
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Lottie.asset("assets/lottie/logo-lottie.json",),
              ),
               Text("${AppData().appName}",style: FluentTheme.of(context).typography.bodyLarge!.copyWith(fontWeight: FontWeight.w700),),
            ],
          ),
        ),


      ),
      pane: NavigationPane(
        displayMode: PaneDisplayMode.compact,
        selected: selectedIndex,
        onChanged: (value) {
          changeIndex(value);
        },
        items: [
          customPaneItem(
            icon: WindowsIcons.FluentIcons.grid_circles_28_filled,
            title: "Dashboard",
            body: DashboardScreen(),
          ),
          customPaneItem(
              icon: WindowsIcons.FluentIcons.cart_24_filled,
              title: "Sell Products",
              body: SellProductScreen(),
          ),
          customPaneItem(
              icon: WindowsIcons.FluentIcons.apps_add_in_16_filled,
              title: "Add Products",
              body: AddProductScreen()
          ),
          customPaneItem(
              icon: WindowsIcons.FluentIcons.apps_16_regular,
              title: "Products",
              body: ProductScreen()
          ),

          customPaneItem(
              icon: WindowsIcons.FluentIcons.note_add_16_filled,
              title: "Add GRN",
              body: AddGRNScreen()
          ),
          customPaneItem(
              icon: WindowsIcons.FluentIcons.note_24_filled,
              title: "GRNs",
              body: GRNScreen()
          ),
          customPaneItem(
              icon: WindowsIcons.FluentIcons.square_multiple_20_filled,
              title: "Stocks",
              body: StockScreen(),
          ),
          customPaneItem(
              icon: WindowsIcons.FluentIcons.person_add_32_filled,
              title: "Add Supplier",
              body: AddSupplierScreen()
          ),
          customPaneItem(
              icon: WindowsIcons.FluentIcons.person_48_filled,
              title: "Suppliers",
              body: SuppliersScreen()
          ),
          customPaneItem(
              icon: WindowsIcons.FluentIcons.person_alert_24_filled,
              title: "Add Customers",
              body: AddCustomerScreen()
          ),
          customPaneItem(
              icon: WindowsIcons.FluentIcons.person_accounts_20_filled,
              title: "Customers",
              body: CustomerScreen(),
          ),

          customPaneItem(
              icon: WindowsIcons.FluentIcons.news_28_filled,
              title: "Invoices",
              body: InvoiceScreen()
          ),


        ],
        size: NavigationPaneSize(
            openMaxWidth: 250,
            openMinWidth: 200,
        ),
        footerItems: [

          PaneItemSeparator(),
          // customPaneItem(
          //     icon: WindowsIcons.FluentIcons.settings_24_filled ,
          //     title: "Settings",
          //     body: SettingsScreen()
          // ),
          PaneItemAction(
            icon: Icon(WindowsIcons.FluentIcons.sign_out_24_filled, size: 24,),
            title: Text("Logout"),
            onTap: (){
              Navigator.of(context).pushReplacement(FluentPageRoute(builder: (context) => MainWrapper(),));
            }
          ),
          PaneItemAction(
              icon:Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark ?
              Icon(WindowsIcons.FluentIcons.weather_moon_20_regular,size: 24,color: Colors.yellow,) :
              Icon(FluentIcons.sunny,size: 24,color: Colors.black,),
              title: Text("Theme",style: FluentTheme.of(context).typography.bodyStrong!.copyWith(fontWeight: FontWeight.w700),),
              onTap: (){
                Provider.of<ThemeProvider>(context,listen: false).toggleTheme();
              }
          ),

        ]

      ),
    );
  }
}


