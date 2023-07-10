import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/myVipPage.dart';
import '../pages/titlePage.dart';

class TitlePagePresenter extends BasePresenter<TitlePageState>{

  /**
   * 查询当前菜单下面的所有标题
   */
  void getTopicList(String menuId) async {
    Map<String, dynamic> queryParams = Map();
    try{
      await requestFutureData<String>(
          Method.post,
          url: Api.HOST_URL + Api.FIRST_PAGE_QUERERY,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
              // if(map['data']['code'] == 200){
                // view.refreshPage(map['data']['data']);
                view.refreshPage(map['data']);
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
      print('查询当前菜单下面的标题异常: $e');
      view.showToast('查询当前菜单下面的标题异常，请程序员查看...');
    }
  }


  /**
   * 查询当前板块下面的视频
   */
  Future getVideoList(String titleId,int page,int limit) async {
    Future result = Future.value(null);
    Map<String, dynamic> queryParams = Map();
    queryParams['limit'] = limit;
    queryParams['page'] = page;
    queryParams['typeId'] = titleId;
    try{
      await requestFutureData<String>(
          Method.post,
          url: Api.HOST_URL + Api.FIRST_PAGE_VIDEO_PIC,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
              // if(map['data']['code'] == 200){
                // result = Future.value(map['data']['data']);
                result = Future.value(map['data']);
              }else{
                // view.showToast(map['data']['msg']);
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
      print('查询当前title下面的视频异常: $e');
    }
    return result;
  }

}