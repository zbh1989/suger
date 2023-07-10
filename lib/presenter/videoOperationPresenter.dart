import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../utils/PreferenceUtils.dart';
import '../views/videoOperation.dart';

class VideoOperationPresenter extends BasePresenter<VideoOperationState> {


  /**
   * 收藏点赞查询
   * targetId : 目标ID
   * userId :  用户ID
   * bizItem : 1:视频; 2:漫画; 3:小说; 4:楼凤; 5:直播
   * bizType : 1:点赞; 2:点踩; 3:收藏; 4:下载; 5:分享; 6:播放
   */
  void query(String targetId,int bizType) async {
    Map<String, dynamic> queryParams = Map();
    queryParams["targetId"] = targetId;
    queryParams["bizType"] = bizType;
    queryParams["bizItem"] = 1;

    PreferenceUtils.instance.getString("userId").then((userId) {
      queryParams['userId'] = userId;

      requestFutureData<String>(Method.post,
          url: Api.HOST_URL + Api.USER_ACTION_QUERY,
          queryParams: queryParams,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
              // if(map['data']['code'] == 200){
                if(bizType == 1){
                  // view.refreshPage(bizType,map['data']['data']['like']??false);
                  view.refreshPage(bizType,map['data']['like']??false);
                }else if(bizType == 3){
                  // view.refreshPage(bizType,map['data']['data']['favorite']??false);
                  view.refreshPage(bizType,map['data']['favorite']??false);
                }
              }else{
                // view.showToast('收藏点赞查询 :'+ map['data']['msg']);
                view.showToast('收藏点赞查询 :'+ map['msg']);
              }
            }else{
              view.showToast('系统异常，请程序员查看...');
            }
          },
          onError: (code, msg) {
            view.showToast(msg);
          });

    });
  }


  /**
   * 更新收藏点赞
   * targetId : 目标ID
   * userId :  用户ID
   * bizItem : 1:视频; 2:漫画; 3:小说; 4:楼凤; 5:直播
   * bizType : 1:点赞; 2:点踩; 3:收藏; 4:下载; 5:分享; 6:播放
   */
  void update(String targetId,int bizType) async {
    Map<String, dynamic> queryParams = Map();
    queryParams["targetId"] = targetId;
    queryParams["bizType"] = bizType;
    queryParams["bizItem"] = 1;

    await PreferenceUtils.instance.getString("userId").then((userId) {
      queryParams['userId'] = userId;
      print(queryParams);
      requestFutureData<String>(Method.post,
        url: Api.HOST_URL + Api.UPDATE_USER_ACTION,
        queryParams: queryParams,
        onSuccess: (data) {
          if (data != null) {
            Map<String, dynamic> map = parseData(data);
            if(map['code'] == 200){
            // if(map['data']['code'] == 200){
              query(targetId,bizType);
            }else{
              view.showToast('更新收藏点赞 :'+ map['data']['msg']);
            }
          }else{
            view.showToast('系统异常，请程序员查看...');
          }
        },
        onError: (code, msg) {
          view.showToast(msg);
        });
    });
  }

  /**
   * 取消收藏点赞
   * targetId : 目标ID
   * userId :  用户ID
   * bizItem : 1:视频; 2:漫画; 3:小说; 4:楼凤; 5:直播
   * bizType : 1:点赞; 2:点踩; 3:收藏; 4:下载; 5:分享; 6:播放
   */
  void cancel(String targetId,int bizType) async {
    Map<String, dynamic> queryParams = Map();
    queryParams["targetId"] = targetId;
    queryParams["bizType"] = bizType;
    queryParams["bizItem"] = 1;

    bool result = false;

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
                query(targetId,bizType);
              }else{
                view.showToast(map['data']['msg']);
              }
            }else{
              view.showToast('取消收藏点赞 :'+ '系统异常，请程序员查看...');
            }
          },
          onError: (code, msg) {
            view.showToast(msg);
          });
    });
  }

}
