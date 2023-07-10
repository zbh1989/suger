import 'package:flutter/material.dart';

Future getData(){
  List<Map<String,dynamic>> list = [
    {
      'id':1,
      'no':'2222'
    }
  ];

  return Future.value(list);
}

void main(){
  Future f = getData();
  f.then((value){
    print(value);
  });
}