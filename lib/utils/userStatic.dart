//这里记录登录用户的信息，因为只是个小Demo,就存个id，存个url，也没有去做持久化了

import 'package:caihong_app/bean/chatMessageModel.dart';

class UserMessage{
  static int userId = 0;
  ///将对话暂存在这里
  static List<ChatMessage> messages = [

  ];
}