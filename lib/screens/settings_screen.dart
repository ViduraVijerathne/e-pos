import 'package:fluent_ui/fluent_ui.dart';
import 'package:lottie/lottie.dart';
import 'package:point_of_sale/utils/app_data.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as wi;
import 'package:url_launcher/url_launcher.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(

      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 310,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top:10),
                      decoration: BoxDecoration(
                          color: FluentTheme.of(context).accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network("https://scontent.fcmb3-2.fna.fbcdn.net/v/t39.30808-6/428399737_1436440863950891_2080681780170201498_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeHGSr9FtOc3Cccrl5qsqTM7ADqBwB1_DJAAOoHAHX8MkLICuyeJ-jXIzmd8ZN1cCE0tc0VOqYWJ2iG4nD_IhRUL&_nc_ohc=3UOmBAi2YYYQ7kNvgGSsp51&_nc_zt=23&_nc_ht=scontent.fcmb3-2.fna&oh=00_AYBIrxTJRWCmnXV54ODnRL0me8T1VUUgFvEQ1WgdpoCo1g&oe=6660B766"),

                      ),
                    ),
                    Text("Selling Agent",
                      style: FluentTheme.of(context).typography.title,
                    ),
                    Text("Sahan Sandeepa ",
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                    Text("Software Developer",
                      style: FluentTheme.of(context).typography.bodyStrong,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                            child:Container(
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: Icon(wi.FluentIcons.call_12_regular, color: Colors.green),
                                title: Text("Whatsapp"),
                              ),
                            )
                        ),
                        Expanded(
                            child:Container(
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: Icon(wi.FluentIcons.mail_12_regular, color: Colors.red),
                                title: Text("Email"),
                              ),
                            )
                        ),


                      ],
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                        child:Container(
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: ListTile(
                            leading: Icon(wi.FluentIcons.chat_12_regular, color: Colors.blue),
                            title: Text("Chat"),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 250,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top:10),
                      decoration: BoxDecoration(
                          color: FluentTheme.of(context).accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Center(
                        child: Lottie.asset("assets/lottie/logo-lottie.json",
                            reverse: true),

                      ),
                    ),
                    Text(AppData().appName,
                      style: FluentTheme.of(context).typography.title,
                    ),
                    Text(AppData().companyName,
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                    Text(AppData().appVersion,
                      style: FluentTheme.of(context).typography.bodyStrong,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child:Container(
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                onPressed: () {
                                  _launchUrl("www.google.com");
                                },
                                leading: Icon(wi.FluentIcons.web_asset_20_regular, color: Colors.green),
                                title: Text("Visit Website"),
                              ),
                            )
                        ),
                        Expanded(
                            child:Container(
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: Icon(wi.FluentIcons.mail_12_regular, color: Colors.red),
                                title: Text("Report Issues"),
                              ),
                            )
                        ),


                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 310,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top:10),
                      decoration: BoxDecoration(
                          color: FluentTheme.of(context).accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network("https://scontent.fcmb3-2.fna.fbcdn.net/v/t39.30808-6/428399737_1436440863950891_2080681780170201498_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeHGSr9FtOc3Cccrl5qsqTM7ADqBwB1_DJAAOoHAHX8MkLICuyeJ-jXIzmd8ZN1cCE0tc0VOqYWJ2iG4nD_IhRUL&_nc_ohc=3UOmBAi2YYYQ7kNvgGSsp51&_nc_zt=23&_nc_ht=scontent.fcmb3-2.fna&oh=00_AYBIrxTJRWCmnXV54ODnRL0me8T1VUUgFvEQ1WgdpoCo1g&oe=6660B766"),

                      ),
                    ),
                    Text("Developer",
                      style: FluentTheme.of(context).typography.title,
                    ),
                    Text("Vidura Vijerathne",
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                    Text("Bsc(Hons) Software Eng BCU UK",
                      style: FluentTheme.of(context).typography.bodyStrong,
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                            child:Container(
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: Icon(wi.FluentIcons.call_12_regular, color: Colors.green),
                                title: Text("Whatsapp"),
                              ),
                            )
                        ),
                        Expanded(
                            child:Container(
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: ListTile(
                                leading: Icon(wi.FluentIcons.mail_12_regular, color: Colors.red),
                                title: Text("Email"),
                              ),
                            )
                        ),


                      ],
                    ),
                    SizedBox(height: 10,),
                    Expanded(
                        child:Container(
                          margin: EdgeInsets.only(right: 5),
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: ListTile(
                            leading: Icon(wi.FluentIcons.chat_12_regular, color: Colors.blue),
                            title: Text("Chat"),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),

          ],
        )
      ],
    );
  }
}

void _launchUrl(String url) async {
  Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}