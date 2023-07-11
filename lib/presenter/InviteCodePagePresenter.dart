
import 'package:caihong_app/base/presenter/base_presenter.dart';

import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../utils/PreferenceUtils.dart';

class InviteCodePagePresenter extends BasePresenter{


  /**
   * 绑定用户邀请码
   */
  void bindInviteCode(String inviteCode,{Function callback}) async {
    try{

      Future.wait([
        PreferenceUtils.instance.getString("userId"),
      ]).then((val){
        if(val != null){
            Map<String, dynamic> param = Map();
            param['userId'] = val[0];
            param['code'] = inviteCode;
            requestFutureData<String>(
            Method.post,
            url: Api.HOST_URL + Api.BIND_INVITE_CODE,
            queryParams: param,
            onSuccess: (data) {
              if (data != null) {
                Map<String, dynamic> map = parseData(data);
                if(map['code'] == 200){
                  view.showToast('绑定成功');
                  callback();
                }else{
                  view.showToast(map['msg']);
                  callback();
                }
              }else{
                view.showToast('系统异常，请程序员查看...');
              }
              return Future.value(data);
            },
            onError: (code, msg) {
            view.showToast(msg);
            });
        }else{
          view.showToast('用户ID为空');
        }
      });

    }catch(e){
      print('查询轮播图接口数据异常: $e');
    }
  }

}