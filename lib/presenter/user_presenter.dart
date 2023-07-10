import 'package:caihong_app/base/presenter/base_presenter.dart';
import 'package:caihong_app/bean/home_bean_entity.dart';
import 'package:caihong_app/network/api/network_api.dart';
import 'package:caihong_app/network/network_util.dart';
import 'package:caihong_app/pages/userPage.dart';
import 'package:caihong_app/utils/PreferenceUtils.dart';

class UserPresenter extends BasePresenter<UserPageState> {
  void checkLoginStatus() {
    Future<String> result =
        PreferenceUtils.instance.getString("login_status", "0");
        result.then((value) => {
          if (value != "1") {view.jumpLogin()} else {getAccount()}
        });
  }

  void getAccount() {
    Future<String> result =
        PreferenceUtils.instance.getString("username", null);
    result.then((value) => {view.showAccount(value)});
  }

}
