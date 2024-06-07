import 'package:fluent_ui/fluent_ui.dart';
import 'package:point_of_sale/models/users.dart';

class LoginProvider with ChangeNotifier{
  Users? _user;

  Users? get user => _user;

  void setUser(Users user){
    _user = user;
    notifyListeners();
  }


}