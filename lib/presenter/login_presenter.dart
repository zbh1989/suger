import 'package:caihong_app/base/presenter/base_presenter.dart';
import 'package:caihong_app/network/api/network_api.dart';
import 'package:caihong_app/network/network_util.dart';
import 'package:caihong_app/pages/loginPage.dart';
import 'package:caihong_app/utils/PreferenceUtils.dart';

/**
 * 登录接口处理
 */
class LoginPresenter extends BasePresenter<LoginPageState> {
  Future login(String username, String password) async {
    Map<String, dynamic> queryParams = Map();
    queryParams["username"] = username;
    queryParams["password"] = password;
    await requestFutureData<String>(Method.post,
        url: Api.LOGIN,
        isShow: true,
        queryParams: queryParams, onSuccess: (data) {
      Map<String, dynamic> map = parseData(data);
      int result = map['data'];
      if (result == 1) {
        PreferenceUtils.instance.saveString("username", username);
        PreferenceUtils.instance.saveString("password", password);
        PreferenceUtils.instance.saveString("login_status", "1");
        view.loginSuccess();
      } else {
        view.loginError();
      }
    }, onError: (code, msg) {
      view.closeProgress();
    });
  }
}
