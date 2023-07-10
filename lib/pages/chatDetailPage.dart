import 'dart:convert' as convert;
import 'dart:io';

import 'package:caihong_app/base/view/base_state.dart';
import 'package:caihong_app/bean/chatMessageModel.dart';
import 'package:caihong_app/presenter/chatpagedetail_presenter.dart';
import 'package:caihong_app/utils/log_utils.dart';
import 'package:caihong_app/utils/userStatic.dart';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  final String name;
  final String userImageUrl;
  final bool groupType;

  const ChatDetailPage({Key key, this.name, this.userImageUrl, this.groupType})
      : super(key: key);

  @override
  ChatDetailPageState createState() => ChatDetailPageState();
}

class ChatDetailPageState
    extends BaseState<ChatDetailPage, ChatPageDetailPresenter> {
  TextEditingController _controller = new TextEditingController();

  WebSocket _webSocket;

  String onlineStatus = "";

  showMessageDetail(List<Map<String, dynamic>> maps) {
    UserMessage.messages.clear();
    UserMessage.messages = [];
    setState(() {
      maps.forEach((element) {
        if (element["from_user"] == element["to_user"]) return;
        UserMessage.messages.add(ChatMessage(
            messageContent: element["im_msg"],
            messageType: element["message_type"],
            fromUser: element["from_user"],
            toUser: element["to_user"],
            recordTime: element["update_time"]));
        UserMessage.messages
            .sort((left, right) => right.recordTime.compareTo(left.recordTime));
      });
    });
  }


  void closeSocket() {
    _webSocket.close();
  }

  // 向服务器发送消息
  void sendMessage(dynamic message) {
    print(convert.jsonEncode(message));
    _webSocket.add(convert.jsonEncode(message));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    closeSocket();
  }

  @override
  void initState() {
  }

  void setSessionID(String id) {
    Log.i("用户session:" + id);
    if (widget.name == "1000000") {
      UserMessage.sessionID = "1000000";
    } else {
      UserMessage.sessionID = id;
    }
    setState(() {
      if (id.isNotEmpty && id != "null") {
        this.onlineStatus = "在线";
      } else {
        this.onlineStatus = "离线";
      }
    });
  }

  void sendMsg() {
    var message = {
      "msg": _controller.text,
      "toUser": UserMessage.sessionID,
      "type": widget.groupType ? 0 : 1
    };
    sendMessage(message);
    mPresenter.addMessage(widget.name, _controller.text, 0);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Image.asset(
                  "lib/assets/images/icon_head.png",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        this.onlineStatus,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: UserMessage.messages.length,
            reverse: true,
            padding: const EdgeInsets.only(bottom: 100),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                    alignment: (UserMessage.messages[index].messageType == 1
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (UserMessage.messages[index].messageType == 1
                              ? Colors.white
                              : Colors.green),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          UserMessage.messages[index].messageContent,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ))),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "发信息...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                      style: TextStyle(color: Colors.black),
                      controller: _controller,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      // mPresenter.getSessionIDByUser(widget.name, false);
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  ChatPageDetailPresenter createPresenter() {
    return ChatPageDetailPresenter();
  }
}
