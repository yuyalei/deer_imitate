import 'dart:convert';

import 'package:deer_imitate/generated/json/base/json_convert_content.dart';
import 'package:deer_imitate/res/constant.dart';

class BaseEntity<T> {
  int? code;
  late String message;
  T? data;
  BaseEntity(this.code,this.message,this.data);

  BaseEntity.fromJson(Map<String,dynamic> json){
    code = json[Constant.code] as int?;
    message = json[Constant.message] as String;
    if(json.containsKey(Constant.data)){
      data = _generateOBJ<T>(json[Constant.data] as Object?);
    }
  }

  T? _generateOBJ<O>(Object? json){
    if(json == null) {
      return null;
    }
    if(T.toString() == 'String') {
      return json.toString() as T;
    }else if(T.toString() == 'Map<dynamic, dynamic>') {
      return json as T;
    }else {
      return JsonConvert.fromJsonAsT<T>(json);
    }
  }
}