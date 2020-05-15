import 'dart:convert';

class StringUtil{
  static String encode(String OriginalCn){
    return jsonEncode(Utf8Encoder().convert(OriginalCn));
  }


  static String decode(String encodeCn){
    var list=List<int>();
    jsonDecode(encodeCn).forEach(list.add);
    String value=Utf8Decoder().convert(list);
    return value;
  }
}