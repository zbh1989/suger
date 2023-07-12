import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/myVipPage.dart';

class MyVipPagePresenter extends BasePresenter<MyVipPageState>{

  /**
   * 查询推荐视频
   */
  Future getRecommandVideos() async {
    Future result = Future.value(null);
    try{
      Map<String, dynamic> queryParams = Map();
      queryParams['limit'] = 3;
      queryParams['page'] = 1;

      await requestFutureData<String>(
          Method.post,
          url: Api.HOST_URL + Api.RECOMMAND_VIDEO,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
                result = Future.value(map['data']);
              }else{
                view.showToast(map['msg']);
              }
            }else{
              view.showToast('系统异常，请程序员查看...');
            }
            return Future.value(data);
          },
          onError: (code, msg) {
            view.showToast(msg);
          });
    }catch(e){
      print('查询轮播图接口数据异常: $e');
    }

    return result;
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
          if (orderInfo != null && (orderInfo['orderStatus' == 2] || orderInfo['orderStatus' == 4])) { /// 充值成功，需要重新刷新用户信息
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