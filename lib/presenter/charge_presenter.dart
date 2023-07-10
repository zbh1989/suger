import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/chargePage.dart';

class ChargePresenter extends BasePresenter<ChargePageState> {

  /// 查询金币等级
  void queryGoldList() async {

    Map<String, dynamic> queryParams = Map();
    await requestFutureData<String>(
      Method.post,
      url: Api.HOST_URL + Api.GOLD_LIST_QUERY,
      queryParams: queryParams,
      onSuccess: (data) {
        Map<String, dynamic> map = parseData(data);
        view.refreshGoldList(map['data']);
      },
      onError: (code, msg) {
        view.closeProgress();
      });
  }

  /// 查询订单
  Future<void> queryOrderInfo(String orderNo) async {

    Map<String, dynamic> queryParams = Map();
    queryParams["orderNo"] = orderNo;
    await requestFutureData<String>(
        Method.post,
        url: Api.HOST_URL + Api.QUERY_ORDER_INFO,
        queryParams: queryParams,
        onSuccess: (data) {
          Map<String, dynamic> map = parseData(data);
          // Map orderInfo = map['data']['data'];
          Map orderInfo = map['data'];
          if (orderInfo != null && (orderInfo['orderStatus'] == 2 || orderInfo['orderStatus'] == 4)) { /// 充值成功，需要重新刷新用户信息
            autoLogin();
            view.refreshPage();
          }
        }, onError: (code, msg) {
          view.closeProgress();
        });
  }


  /// 刷新用户所有数据
  void refreshAllData(){
    autoLogin();
    view.refreshPage();
  }
}