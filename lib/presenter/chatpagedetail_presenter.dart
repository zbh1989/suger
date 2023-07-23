import 'package:caihong_app/base/presenter/base_presenter.dart';
import 'package:caihong_app/network/api/network_api.dart';
import 'package:caihong_app/network/network_util.dart';
import 'package:caihong_app/pages/chatDetailPage.dart';
import 'package:caihong_app/utils/PreferenceUtils.dart';
import 'package:caihong_app/utils/db_utils.dart';
import 'package:caihong_app/utils/log_utils.dart';
import 'package:caihong_app/utils/time_format_util.dart';

class ChatPageDetailPresenter extends BasePresenter<ChatDetailPageState> {


  /**
   * 查询历史聊天记录
   */
  void getChatHisList(int id,String userId,int page,int limit) async {
    Map<String, dynamic> queryParams = Map();
    queryParams['id'] = id;
    queryParams['userId'] = userId;
    queryParams['limit'] = limit;
    queryParams['page'] = page;
    try{
      await requestFutureData<String>(
          Method.post,
          url: Api.HOST_URL + Api.CHAT_HIS_QUERY,
          isShow: true,
          isClose: true,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
                view.refreshData(map['data']);
              }else{
                view.showToast(map['msg']);
              }
            }else{
              view.showToast('系统异常，请程序员查看...');
            }
          },
          onError: (code, msg) {
            view.showToast(msg);
          });
    }catch(e){
      print('查询当前用户: $userId 下面的视频异常: $e');
    }
  }

}
