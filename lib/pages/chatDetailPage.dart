import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';

import 'package:caihong_app/base/view/base_state.dart';
import 'package:caihong_app/bean/chatMessageModel.dart';
import 'package:caihong_app/presenter/chatpagedetail_presenter.dart';
import 'package:caihong_app/utils/log_utils.dart';
import 'package:caihong_app/utils/userStatic.dart';
import 'package:flutter/material.dart';

import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../utils/toast.dart';
import '../views/chat_scroll_physics.dart';

class ChatDetailPage extends StatefulWidget {
  final String userId;
  final String userImageUrl;
  final bool groupType;

  const ChatDetailPage({Key key, this.userId, this.userImageUrl, this.groupType})
      : super(key: key);

  @override
  ChatDetailPageState createState() => ChatDetailPageState();
}

class ChatDetailPageState extends BaseState<ChatDetailPage, ChatPageDetailPresenter> {
  final TextEditingController _controller = new TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  WebSocket _webSocket;

  bool _isLoading = false;

  String onlineStatus = "";

  int page = 1;

  int limit  = 10;

  List messageList = [];

  int lastId = 0;


  void closeSocket() {
    if(_webSocket != null){
      _webSocket.close();
    }
  }

  // 向服务器发送消息
  void sendMessage(String message) {
    if(message != null && _webSocket != null){
      _webSocket.add(message);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    closeSocket();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListener);
    _focusNode.addListener(textFocusListener);
    connect();
  }

  void refreshData(List list){
    _isLoading = false;
    if(list != null && list.length > 0 && mounted){
      setState(() {
        messageList.addAll(list);
      });
    }
  }

  void scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      if (_isLoading) return;
      if(!_isLoading) {
        mPresenter.getChatHisList(messageList[messageList.length - 1]['id'],widget.userId,page++,limit);
      }
      _isLoading = true;
    }
  }

  void textFocusListener() {
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  void connect() {
    try{
      String url = Api.WS_HOST_URL + Api.WEBSOCKET_URL; ///     Api.LOCAL_WEBSOCKET_URL
      Future<WebSocket> futureWebSocket = WebSocket.connect(url + widget.userId + '/$page/$limit'); //socket地址
      futureWebSocket.then((WebSocket ws) {
        _webSocket = ws;
        _webSocket.readyState;
        // 监听事件
        void onData(dynamic content) {
          List resp = jsonDecode(content);
          if(resp != null && resp.length > 0 && mounted){
            /// 处理消息
            setState(() {
              messageList.insertAll(0,resp);
            });
          }

        }

        _webSocket.listen(onData,
            onError: (a) => print("error"), onDone: () => print("done"));

        // sendMessage('hello,world zzzz');

      });
    }catch(e){
      print(e);
      Toast.show('websocket 消息异常: $e');
    }

  }


  void sendMsg() {
    var message = {
      "msg": _controller.text,
      "userId": widget.userId,
    };
    sendMessage(_controller.text);
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
                /*Image.asset(
                  "lib/assets/images/icon_head.png",
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),*/
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.userId,
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
            itemCount: messageList.length,
            reverse: true,
            controller: _scrollController,
            physics: ChatScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.only(bottom: 100),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 6, bottom: 6),
                child: Align(
                    alignment: (messageList[index]['status'] == 2
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messageList[index]['status'] == 2
                              ? Colors.white
                              : Colors.green),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                        child: Text(
                          messageList[index]['content'],
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
                  /*GestureDetector(
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
                  ),*/
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
                      sendMsg();
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
