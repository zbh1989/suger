import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../pages/goldChargeHisPage.dart';
import '../pages/spreadRecordListPage.dart';
import '../utils/PreferenceUtils.dart';

class SpreadRecordListPresenter extends BasePresenter<SpreadRecordListPageState> {

  /**
   * 查询用户推广记录
   */
  void query({Function callback}) async {
    try{
      PreferenceUtils.instance.getString("userId").then((val){
        if(val != null){
          Map<String, dynamic> param = Map();
          param['userId'] = val;
          requestFutureData<String>(
              Method.post,
              url: Api.HOST_URL + Api.SUBORDINATE_USER,
              queryParams: param,
              onSuccess: (data) {
                if (data != null) {
                  Map<String, dynamic> map = parseData(data);
                  if(map['code'] == 200){
                    /*List dList = [];
                    Map data = Map();
                    data['id'] = 1;
                    data['username'] = '张三';
                    dList.add(data);
                    view.refreshData(dList);
                    */
                    view.refreshData(map['data']);
                  }else{
                    view.showToast(map['msg']);
                  }
                }else{
                  view.showToast('系统异常，请程序员查看...');
                }
              },
              onError: (code, msg) {
                view.showToast(msg);
              });
        }else{
          view.showToast('用户ID为空');
        }
      });

    }catch(e){
      print('查询推广用户数据异常: $e');
    }
  }

}