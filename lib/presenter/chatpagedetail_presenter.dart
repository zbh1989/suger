import 'package:caihong_app/base/presenter/base_presenter.dart';
import 'package:caihong_app/network/api/network_api.dart';
import 'package:caihong_app/network/network_util.dart';
import 'package:caihong_app/pages/chatDetailPage.dart';
import 'package:caihong_app/utils/PreferenceUtils.dart';
import 'package:caihong_app/utils/db_utils.dart';
import 'package:caihong_app/utils/log_utils.dart';
import 'package:caihong_app/utils/time_format_util.dart';

class ChatPageDetailPresenter extends BasePresenter<ChatDetailPageState> {
  Future getChatInfoDetail(String fromUser) async {
    Log.i("getChatInfoDetail--->" + fromUser);
    DBManager.instance.initDB();
    Future<String> result =
        PreferenceUtils.instance.getString("username", null);
    result.then((value) {
      Log.i("getChatInfoDetail value--->" + value);
      DBManager.instance.imMessageTable
          .queryListByUser(value.toString(), fromUser)
          .then((maps) => view.showMessageDetail(maps));
    });
  }

  Future addMessage(String toUser, String msg, int messageType) async {
    DBManager.instance.initDB();
    Future<String> result =
        PreferenceUtils.instance.getString("username", null);
    result.then((value) async {
      Map<String, dynamic> map = {};
      map["from_user"] = value.toString();
      map["to_user"] = toUser;
      map["im_msg"] = msg;
      map["message_type"] = messageType;
      map["update_time"] = TimeFormatUtil.getCurrentDate();
      DBManager.instance.imMessageTable.insert(map);
      getChatInfoDetail(toUser);
    });
  }

}
