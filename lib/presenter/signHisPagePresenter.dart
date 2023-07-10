import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/signHisPage.dart';
import '../utils/PreferenceUtils.dart';

class SignHisPresenter extends BasePresenter<SignHisPageState> {

  /**
   * 分页查询用户签到奖励记录
   */
  void querySignHis(){
    PreferenceUtils.instance.getString("userId").then((userId){
      Map<String, dynamic> queryParams = Map();
      queryParams["userId"] = userId;
      requestFutureData<String>(Method.post,
          url: Api.HOST_URL + Api.USER_SIGN_HIS,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
                view.refreshData(map['data']);
              }else{
                // view.showToast(map['data']['msg']);
                view.showToast(map['msg']);
              }
            }else{
              view.showToast('系统异常，请程序员查看...');
            }
            // return Future.value(data);
          },
          onError: (code, msg) {
            view.showToast(msg);
          });
    });
  }

}