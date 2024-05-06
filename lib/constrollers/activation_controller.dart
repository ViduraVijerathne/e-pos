import 'package:firedart/firedart.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:firedart/firestore/models.dart';
import 'package:point_of_sale/utils/method_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v1.dart';

import '../models/activator_details.dart';

class ActivationController{
  CollectionReference collectionReference = Firestore.instance.collection('activators');

  String _generateCode(){
    var uuid = Uuid();
    // String code1 = uuid.v1();
    // String code2 = uuid.v4();
    String code =uuid.v4();
    print("Activation Code is "+code);
    return code;
  }

  Future<String> generateActivationCode(
      {required String deviceID, required String Email, required DateTime expiredDate}) async {

    String code = _generateCode();

    ActivatorDetails activatorDetails = ActivatorDetails(
      activationCode: code,
      activationDate: DateTime.now(),
      expiredDate: expiredDate,
      deviceID: deviceID,
      email: Email
    );

    await collectionReference.document(deviceID).set(activatorDetails.toJson());
    return activatorDetails.activationCode;
  }
  
  Future<void> _saveActivationData({required ActivatorDetails activatorDetails})async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("ActivationCode", activatorDetails.activationCode);
    prefs.setString("ActivationDate", activatorDetails.activationDate.toString());
    prefs.setString("deviceID", activatorDetails.deviceID);
    prefs.setString("expiredDate", activatorDetails.expiredDate.toString());
    prefs.setString("email", activatorDetails.email);
  }


  Future<MethodResponse> activate({required String code,required String deviceID})async{
    try{
      Document doc = await collectionReference.document(deviceID).get();
      ActivatorDetails activatorDetails = ActivatorDetails.fromJson(doc.map);
      if(activatorDetails.deviceID == deviceID && activatorDetails.activationCode == code){
        if(activatorDetails.expiredDate.isAfter(DateTime.now())){
          await _saveActivationData(activatorDetails: activatorDetails);
          return MethodResponse(isSuccess: true, message: "Activation Successful", data: "data");
        }else{
          return MethodResponse(isSuccess: false, message: "Activation Expired", data: "data");
        }
      }else{
        return MethodResponse(isSuccess: false, message: "Activation Failed", data: "data");
      }
    }catch(ex){
      print(ex);
      if(ex is GrpcError){
        if(ex.code == 2){
          return MethodResponse(isSuccess: false, message: "Connection Error! Check Your Connection", data: "data");
        }if(ex.code == 5){
          return MethodResponse(isSuccess: false, message: "Activation Failed", data: "data");
        }else{
          return MethodResponse(isSuccess: false, message: "Activation Failed", data: "data");
        }
      }else{
        return MethodResponse(isSuccess: false, message: "Activation Failed ${ex.toString()}", data: "data");
      }
    }

    MethodResponse<String> res = MethodResponse(isSuccess: true, message: "message", data: "data");
    return res;
  }

}