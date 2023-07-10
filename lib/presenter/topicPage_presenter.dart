
import 'package:caihong_app/pages/topicPage.dart';

import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';

class TopicPagePresenter extends BasePresenter<TopicPageState> {


  /**
   * 专题列表
   */
  Future getTopicList(int page,int limit) async {
    Future result = Future.value(null);
    Map<String, dynamic> queryParams = Map();
    queryParams["page"] = page;
    queryParams["limit"] = limit;
    await requestFutureData<String>(Method.post,
        url: Api.HOST_URL + Api.TOPIC_LIST,
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
    return result;
  }

}
