import 'dart:convert';


class FluroConvertUtil{
  static String objectToString<T>(T t){
    return fluroCnParamsEncode(jsonEncode(t));
  }

  static Map<String,dynamic> StringToMap(String str){
    return json.decode(FluroCnParamsDecode(str));
  }
  static fluroCnParamsEncode(String originalCn){
    return jsonEncode(Utf8Encoder().convert(originalCn));
  }

  static String FluroCnParamsDecode(String encodeCn){
    var list=List<int>();
    jsonDecode(encodeCn).forEach(list.add);
    String value=Utf8Decoder().convert(list);
    return value;
  }
//  _goFillInOrder(AddressModel addressData){
//    Navigator.of(context).pop(FluroConvertUtil.objectToString(addressData));
//  }
}