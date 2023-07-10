

import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../views/topMenu.dart';

class TopMenuPagePresenter extends BasePresenter<TopMenuState>{

  /**
   * 查询所有菜单
   */
  void getMenuList() async {
    Map<String, dynamic> queryParams = Map();
    try{
      await requestFutureData<String>(
          Method.post,
          url: Api.HOST_URL + Api.TOP_MENU_LIST,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
              // if(map['data']['code'] == 200){
                // view.refreshData(map['data']['data']);
              }else{
                view.showToast(map['data']['msg']);
              }
            }else{
              view.showToast('系统异常，请程序员查看...');
            }
          },
          onError: (code, msg) {
            view.showToast(msg);
          });
    }catch(e){
      print('请求查询菜单按钮接口异常：$e');
    }
  }

}