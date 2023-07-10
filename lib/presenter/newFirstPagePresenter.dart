import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/newFirstPage.dart';

class NewFirstPagePresenter extends BasePresenter<NewFirstPageState>{

  /**
   * 查询首页轮播图数据
   */
  Future getSwipInfo() async {
    Future result = Future.value(null);
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
      print('查询轮播图接口数据异常: $e');
    }

    return result;
  }


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
              // if(map['data']['code'] == 200){
              if(map['code'] == 200){
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
      print('请求查询菜单按钮接口异常：$e');
    }
  }

  /**
   * 查询当前菜单下面的所有标题
   */
  Future getTopicList(String menuId) async {
    Future result = Future.value(null);
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
      print('查询当前菜单下面的标题异常: $e');
    }
    return result;
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