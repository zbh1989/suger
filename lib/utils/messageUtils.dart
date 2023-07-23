import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';

import '../../network/api/network_api.dart';
import 'PreferenceUtils.dart';

class MessageUtils {
  static WebSocket webSocket;
  static List messageList = [];
  static Function onMsgCallback;
  static ValueChanged notifyMsg;
  static bool firstConnect = true;
  static num _id = 0;

  static void connect(String userId) {
    String url = Api.WS_HOST_URL + Api.WEBSOCKET_URL; ///     Api.LOCAL_WEBSOCKET_URL
    Future<WebSocket> futureWebSocket = WebSocket.connect(url + userId + '/1/30');// Api.WS_URL 为服务器端的 websocket 服务
    futureWebSocket.then((WebSocket ws) {
      webSocket = ws;
      webSocket.readyState;
      // 监听事件
      void onData(dynamic content) {
        _id++;
        List resp = jsonDecode(content);
        if(resp != null && resp.length > 0){
          if(!firstConnect){
            PreferenceUtils.instance.saveInteger('hasMsg', 1);

            PreferenceUtils.instance.saveInteger('hasMsg', 0);
          }
          /// 处理消息
          messageList.insertAll(0,resp);
          if(onMsgCallback != null){
            onMsgCallback();
          }
          if(notifyMsg != null){
            notifyMsg(true);
          }
        }
        firstConnect = false;
        // _createNotification("新消息", content + _id.toString());
      }

      webSocket.listen(onData,
          onError: (a) => print("error"), onDone: () => print("done"));
    });
  }

  static void closeSocket() {
    if(webSocket != null){
      webSocket.close();
    }
  }

  // 向服务器发送消息
  static void sendMessage(String message) {
    webSocket.add(message);
  }

  // 手机状态栏弹出推送的消息
  /*static Future<void> _createNotification(String title, String content)  async {
    await LocalNotifications.createNotification(
      id: _id,
      title: title,
      content: content,
      onNotificationClick: NotificationAction(
          actionText: "some action",
          callback: _onNotificationClick,
          payload: "接收成功！"),
    );
  }

  static _onNotificationClick(String payload) {
    LocalNotifications.removeNotification(_id);
    _sendMessage("消息已被阅读");
  }*/
}