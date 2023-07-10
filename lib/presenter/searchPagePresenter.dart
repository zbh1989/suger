
import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/searchPage.dart';

class SearchPagePresenter extends BasePresenter<SearchPageState>{

  /**
   * 短视频
   */
  void getRecommandVideos(int page,int limit) {
    // Future result = Future.value(null);
    Map<String, dynamic> queryParams = Map();
    queryParams["page"] = page;
    queryParams["limit"] = limit;
    requestFutureData<String>(Method.post,
        url: Api.HOST_URL + Api.GUESS_LIKE_VIDEO_QUERY,
        queryParams: queryParams,
        onSuccess: (data) {
          if (data != null) {
            Map<String, dynamic> map = parseData(data);
            if(map['code'] == 200){
            // if(map['data']['code'] == 200){
              // result = Future.value(map['data']['data']);
              // view.refreshPage(map['data']['data']);
              view.refreshPage(map['data']);
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
    // return result;
  }

  /**
   * 搜索
   */
  void searchByKey(String key) async {
    try{
      Map<String, dynamic> queryParams = Map();
      queryParams["page"] = 1;
      queryParams["limit"] = 50;
      queryParams['title'] = key;
      await requestFutureData<String>(Method.post,
          url: Api.HOST_URL + Api.SEARCH_VIDEO_BY_NAME,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
              // if(map['data']['code'] == 200){
                // result = Future.value(map['data']['data']);
                // view.refreshSearchResult(map['data']['data']);
                view.refreshSearchResult(map['data']);
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
    }catch(e){
      view.showToast(e);
    }
  }

}
