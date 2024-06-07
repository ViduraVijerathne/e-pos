import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/users.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../providers/login_provider.dart';

class UserManagementScreen extends StatefulWidget {
  static UserAccess access = UserAccess.USERMANAGEMENT;

  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //Map<UserAccess, bool> accesses = {};
  List<UserAccess> accesses = [];
  List<Users> users = [];
  Users? selectedUser;
  void load()async{
    users = await Users.getAll();
    if(mounted){
      setState(() {

      });
    }
  }

  void loadToField(Users user){
    _emailController.text = user.email;
    _usernameController.text = user.username;
    _passwordController.text = user.password;
    accesses = user.accesses;
    selectedUser = user;
    setState(() {

    });
  }
  @override
  void initState() {
    load();
    super.initState();
  }


  void showError(String message)async{
    await displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: const Text('Error'),
        content:  Text(message),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: InfoBarSeverity.warning,
      );
    });
  }
  void showSuccess(String message)async{
    await displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: const Text('Success'),
        content:  Text(message),
        action: IconButton(
          icon: const Icon(FluentIcons.clear),
          onPressed: close,
        ),
        severity: InfoBarSeverity.success,
      );
    });
  }
  void add()async{
    if(_emailController.text.isEmpty) {
      showError("Email is required");
      return;
    }
    if(_usernameController.text.isEmpty) {
      showError("Username is required");
      return;
    }
    if(_passwordController.text.isEmpty) {
      showError("Password is required");
      return;
    }
    if(accesses.isEmpty){
      showError("Please Add minimum one role for the user");
      return;
    }
    Users user = Users(
      email: _emailController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      accesses: accesses, id: 0
    );
    try{
      await user.add();
      clearfields();
      showSuccess("Successfully added!");
    }catch(ex){
     showError("User is already exist");
    }
    load();
  }
  void update()async{
    int id = selectedUser!.id;
    if(_emailController.text.isEmpty) {
      showError("Email is required");
      return;
    }
    if(_usernameController.text.isEmpty) {
      showError("Username is required");
      return;
    }
    if(_passwordController.text.isEmpty) {
      showError("Password is required");
      return;
    }
    Users user = Users(
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
        accesses: accesses, id: id
    );
    await user.update();
    clearfields();
    showSuccess("Successfully Updated!");
    load();
  }
  void clearfields(){
    _emailController.text = "";
    _usernameController.text = "";
    _passwordController.text = "";
    accesses.clear();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
        header: Align(
          alignment: Alignment.center,
          child: Text(
            "User Management",
            textAlign: TextAlign.center,
            style: FluentTheme.of(context).typography.title,
          ),
        ),
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: FluentTheme.of(context).cardColor,
            ),
            child: Row(
              children: [
                Expanded(
                    child: InfoLabel(
                  label: "Email",
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextBox(
                      controller: _emailController,
                    ),
                  ),
                )),
                Expanded(
                    child: InfoLabel(
                  label: "Username",
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextBox(
                      controller: _usernameController,
                    ),
                  ),
                )),
                Expanded(
                    child: InfoLabel(
                  label: "Password",
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextBox(
                      controller: _passwordController,
                    ),
                  ),
                )),
                Expanded(
                    child: InfoLabel(
                  label: "",
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Button(
                      child: Text(selectedUser == null  ? "add" : "update"),
                      onPressed: selectedUser == null  ? add : update,
                    ),
                  ),
                )),
              ],
            ),
          ),
          SizedBox(height: 10,),
          ResponsiveGridList(
            listViewBuilderOptions: ListViewBuilderOptions(
              shrinkWrap: true,
            ),
            minItemWidth: 130,
            children: UserAccess.values
                .map(
                  (e) => Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: FluentTheme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InfoLabel(
                      label: e.name,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Checkbox(
                            checked: accesses.contains(e),
                            onChanged: (bool? value) {
                              // accesses[e] = value ?? false;
                              if(value ?? false){
                                accesses.add(e);
                              }else{
                                if(accesses.length ==1){
                                  accesses = [];
                                  return;
                                }
                                accesses.remove(e);
                              }
                              setState(() {});
                            },
                          )),
                    ),
                  ),
                )
                .toList(),
            // children: [
            //
            //   Expanded(child: InfoLabel(label: "Email",child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: TextBox(controller: _emailController,),
            //   ),)),
            //
            // ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context, "ID"),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context, "Email"),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context, "Username"),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context, "Password"),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context, "Accesses"),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.tight,
                child: _tableHead(context, "#"),
              )
            ],
          ),

          const SizedBox(
            height: 20,
          ),
          ...users.map((e) =>  Container(
            height: 100,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: FluentTheme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: _tableBodyCell(context,"${e.id}"),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: _tableBodyCell(context,e.email),
                ),

                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: _tableBodyCell(context,e.username),
                ),

                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: _tableBodyCell(context,e.password),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: ComboBox(
                    value: e.accesses.first.name,
                    placeholder:Text(e.accesses.first.name) ,
                    items: e.accesses.map((e) =>ComboBoxItem(child: Text(e.name)) ,).toList(),
                    onChanged: (value) {

                    },
                  ),
                ),


                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: Center(
                    child: Checkbox(
                      onChanged: (value) {
                        if(value ?? false){
                          Users? u= Provider.of<LoginProvider>(context,listen: false).user;
                          if(u !=null && u.id == e.id){
                            showError("you cant update  yourself");
                          }else{
                            selectedUser = e;
                            loadToField(e);
                          }


                        }else{
                          selectedUser = null;
                          _emailController.text = "";
                          _usernameController.text = "";
                          _passwordController.text = "";
                          accesses = [];
                          // accesses.removeRange(0,accesses.length-1);
                        }
                        setState(() {

                        });
                      },
                      checked: selectedUser == null ? false:selectedUser!.id == e.id,
                    ),
                  ),
                )
              ],
            ),
          ),)
        ]);
  }
}

Widget _tableHead(BuildContext context, String text) {
  return Container(
    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
    decoration: BoxDecoration(
        color: FluentTheme.of(context).accentColor.withOpacity(0.2)),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: FluentTheme.of(context).typography.bodyStrong,
    ),
  );
}

Widget _tableBodyCell(BuildContext context, String text) {
  return Container(
    padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
    child: Text(
      text,
      textAlign: TextAlign.center,
    ),
  );
}
