import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/buyVipPage.dart';
import '../pages/chargePage.dart';

class BuyVipPagePresenter extends BasePresenter<BuyVipPageState> {

  /// 查询VIP等级
  void queryVipLevelList() async {

    Map<String, dynamic> queryParams = Map();
    await requestFutureData<String>(
        Method.post,
        url: Api.HOST_URL + Api.VIP_LEVEL_QUERY,
        queryParams: queryParams,
        onSuccess: (data) {
          Map<String, dynamic> map = parseData(data);
          view.refreshData(map['data']);
        },
        onError: (code, msg) {
          view.closeProgress();
        });
  }


}