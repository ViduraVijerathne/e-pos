import 'package:point_of_sale/utils/pc_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activator{


// Obtain shared preferences.

  Future<bool> isActive()async{
    // return false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("ActivationCode", activatorDetails.activationCode);
    // prefs.setString("ActivationDate", activatorDetails.activationDate.toString());
    // prefs.setString("deviceID", activatorDetails.deviceID);
    // prefs.setString("expiredDate", activatorDetails.expiredDate.toString());
    // prefs.setString("email", activatorDetails.email);

    String activationCode = prefs.getString('ActivationCode') ?? "";
    String activationDateString = prefs.getString('ActivationDate') ?? "";
    String deviceID = prefs.getString('deviceID') ?? "";
    String expiredDateString = prefs.getString('expiredDate') ?? "";
    String email = prefs.getString('email') ?? "";

    if(activationDateString.isNotEmpty && expiredDateString.isNotEmpty){
      DateTime activationDate = DateTime.parse(activationDateString);
      DateTime expiredDate = DateTime.parse(expiredDateString);
      if(activationCode.isNotEmpty && activationDate.isBefore(DateTime.now()) && expiredDate.isAfter(DateTime.now()) && deviceID.isNotEmpty && email.isNotEmpty){
        String deviceID = await PCInfo().getDeviceID();
        if(deviceID == deviceID) {
          return true;
        }else{
          return true;
        }
      }else{
        return false;
      }
    }else{
      return false;
    }
  }

  Future<bool> isSetupped()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isSetupped') ?? false;
  }


}