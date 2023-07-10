import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/firstPageVideoModule.dart';

class FirstPageVideoModulePresenter extends BasePresenter<FirtPageVideoModuleState>{

  /**
   * 查询当前板块下面的视频
   */
  void getVideoList(String titleId,int page,int limit) async {
    List result;
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
                // result = map['data']['data'];
                result = map['data'];
                // view.refreshData(map['data']['data']);
                // return Future(() => map['data']['data']);
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
      print('查询当前title: $titleId 下面的视频异常: $e');
    }
    // return Future(() => null);
    view.refreshData(result);
  }

}


