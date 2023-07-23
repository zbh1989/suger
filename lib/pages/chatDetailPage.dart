import 'package:caihong_app/base/view/base_state.dart';
import 'package:caihong_app/presenter/chatpagedetail_presenter.dart';
import 'package:caihong_app/utils/toast.dart';
import 'package:flutter/material.dart';
import '../utils/PreferenceUtils.dart';
import '../utils/messageUtils.dart';
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

  bool _isLoading = false;

  String onlineStatus = "";

  int page = 1;

  int limit  = 30;

  int lastId = 0;

  @override
  void dispose() {
    super.dispose();
    MessageUtils.onMsgCallback = null;
  }

  @override
  void initState() {
    PreferenceUtils.instance.saveInteger('hasMsg', 0);
    MessageUtils.onMsgCallback = (){
      if(mounted){
        setState(() {

        });
      }
    };
    super.initState();
    _scrollController.addListener(scrollListener);
    _focusNode.addListener(textFocusListener);
    // connect();
  }

  void refreshData(List list){
    _isLoading = false;
    if(list != null && list.length > 0 && mounted){
      setState(() {
        MessageUtils.messageList.addAll(list);
      });
    }else{
      Toast.tips('没有更多消息了');
    }
  }

  void scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      if (_isLoading) return;
      if(!_isLoading) {
        mPresenter.getChatHisList(MessageUtils.messageList[MessageUtils.messageList.length - 1]['id'],widget.userId,page++,limit);
      }
      _isLoading = true;
    }
  }

  void textFocusListener() {
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  void sendMsg() {
    MessageUtils.sendMessage(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Scaffold(
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
                    Navigator.of(context).pop();
                    /*Navigator.pushAndRemoveUntil(
                      context,
                      new MaterialPageRoute(builder: (context) => HomePage(type: TikTokPageTag.me),),
                          (route) => route == null,
                    );*/
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
            itemCount: MessageUtils.messageList.length,
            reverse: true,
            controller: _scrollController,
            physics: ChatScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.only(bottom: 100),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(
                    left: 14, right: 14, top: 6, bottom: 6),
                child: Align(
                    alignment: (MessageUtils.messageList[index]['status'] == 2
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (MessageUtils.messageList[index]['status'] == 2
                              ? Colors.white
                              : Colors.green),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                        child: Column(
                          crossAxisAlignment: MessageUtils.messageList[index]['status'] == 2 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                          children: [
                            Text(MessageUtils.messageList[index]['createTime'],style: TextStyle(fontSize: 10, color: Color(0x80000000)),),
                            SizedBox(height: 5,),
                            Text(MessageUtils.messageList[index]['content'],style: TextStyle(fontSize: 15, color: Colors.black),)
                          ],
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

    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).pop();
        /*Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(builder: (context) => HomePage(type: TikTokPageTag.me),),
              (route) => route == null,
        );*/
        return Future(() => true);
      },
      child: body,
    );
  }

  @override
  ChatPageDetailPresenter createPresenter() {
    return ChatPageDetailPresenter();
  }
}
