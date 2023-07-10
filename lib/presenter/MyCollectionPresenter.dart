import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/myCollection.dart';
import '../utils/PreferenceUtils.dart';

class MyCollectionPresenter extends BasePresenter<MyCollectionState>{

  /**
   * 查询收藏视频
   */
  void getCollectionVideos(int page,int limit) async {
    Future result = Future.value(null);
    try{
      Map<String, dynamic> queryParams = Map();
      queryParams['limit'] = limit;
      queryParams['page'] = page;

      await PreferenceUtils.instance.getString("userId").then((userId){
        queryParams['userId'] = userId;

        requestFutureData<String>(
          Method.post,
          url: Api.HOST_URL + Api.COLLECTION_VIDEO,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
              // if(map['data']['code'] == 200){
                // result = Future.value(map['data']['data']);
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
      });
    }catch(e){
      print('查询轮播图接口数据异常: $e');
    }

    return result;
  }


  /**
   * 删除收藏
   * targetId : 目标ID
   * userId :  用户ID
   * bizItem : 1:视频; 2:漫画; 3:小说; 4:楼凤; 5:直播
   * bizType : 1:点赞; 2:点踩; 3:收藏; 4:下载; 5:分享; 6:播放
   */
  void deleteCollection(String targetId) async {
    Map<String, dynamic> queryParams = Map();
    queryParams["targetId"] = targetId;
    queryParams["bizType"] = 3;
    queryParams["bizItem"] = 1;

    await PreferenceUtils.instance.getString("userId").then((userId) {
      queryParams['userId'] = userId;
      print(queryParams);
      requestFutureData<String>(Method.post,
          url: Api.HOST_URL + Api.USER_ACTION_DELETE,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
              // if(map['data']['code'] == 200){
                view.showToast('删除成功');
              }else{
                view.showToast(map['data']['msg']);
              }
            }else{
              view.showToast('系统异常，请程序员查看...');
            }
            return Future.value(data);
          },
          onError: (code, msg) {
            view.showToast(msg);
          });
    });
  }

}