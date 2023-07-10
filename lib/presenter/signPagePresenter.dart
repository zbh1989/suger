import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/signPage.dart';
import '../utils/PreferenceUtils.dart';

class SignPagePresenter extends BasePresenter<SignPageState> {

  /**
   * 签到
   */
  void doSign() async {

    PreferenceUtils.instance.getString("userId").then((userId){
      Map<String, dynamic> queryParams = Map();
      queryParams["userId"] = userId;
      requestFutureData<String>(Method.post,
          url: Api.HOST_URL + Api.USER_SIGN,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
                view.showToast('签到成功');
                autoLogin();
                view.refreshSignResult();
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