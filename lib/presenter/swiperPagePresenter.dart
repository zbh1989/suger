import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/newFirstPage.dart';
import '../pages/swiperPage.dart';

class SwiperPagePresenter extends BasePresenter<SwiperPageState>{

  /**
   * 查询首页轮播图数据
   */
  void getSwipInfo() async {
    try{
      await requestFutureData<String>(
          Method.post,
          url: Api.HOST_URL + Api.FIRST_PAGE_SWIP_INFO,
          queryParams: {},
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
              // if(map['data']['code'] == 200){
                // view.refreshData(map['data']['data']);
                view.refreshData(map['data']);
              }else{
                // view.showToast(map['data']['msg']);
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
      print('查询轮播图接口数据异常: $e');
    }
  }


}