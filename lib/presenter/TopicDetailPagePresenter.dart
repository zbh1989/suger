import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/topicDetailPage.dart';

class TopicDetailPagePresenter extends BasePresenter<TopicDetailPageState> {

  /**
   * 专题列表
   */
  void getTopicDetailList(int page,int limit,String topicId) async {
    Map<String, dynamic> queryParams = Map();
    queryParams["page"] = page;
    queryParams["limit"] = limit;
    queryParams["typeId"] = topicId;
    await requestFutureData<String>(Method.post,
        url: Api.HOST_URL + Api.FIRST_PAGE_VIDEO_PIC,
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
          // return Future.value(data);
        },
        onError: (code, msg) {
          view.showToast(msg);
        });
    // return result;
  }

}