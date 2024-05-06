import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class PCInfo{
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    return <String, dynamic>{
      'numberOfCores': data.numberOfCores,
      'computerName': data.computerName,
      'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
      'userName': data.userName,
      'majorVersion': data.majorVersion,
      'minorVersion': data.minorVersion,
      'buildNumber': data.buildNumber,
      'platformId': data.platformId,
      'csdVersion': data.csdVersion,
      'servicePackMajor': data.servicePackMajor,
      'servicePackMinor': data.servicePackMinor,
      'suitMask': data.suitMask,
      'productType': data.productType,
      'reserved': data.reserved,
      'buildLab': data.buildLab,
      'buildLabEx': data.buildLabEx,
      'digitalProductId': data.digitalProductId,
      'displayVersion': data.displayVersion,
      'editionId': data.editionId,
      'installDate': data.installDate,
      'productId': data.productId,
      'productName': data.productName,
      'registeredOwner': data.registeredOwner,
      'releaseId': data.releaseId,
      'deviceId': data.deviceId,
    };
  }

  Future<String> getDeviceID()async{
    Map<String,dynamic> result = _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
    // result['deviceId'] = "";
    if(result['deviceId'] == null || result['deviceId'].isEmpty){
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String generatedDeviceID = prefs.getString('generatedDeviceID') ?? "";
      if(generatedDeviceID.isEmpty){
        Uuid uuid =  Uuid();
        result['deviceId'] = "GENERATED@${uuid.v4()}";
        prefs.setString('generatedDeviceID', result['deviceId']);
      }else{
        result['deviceId'] = generatedDeviceID;
      }

    }
    return result['deviceId'];
  }
}