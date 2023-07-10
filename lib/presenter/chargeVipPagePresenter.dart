import 'dart:convert';
import 'package:caihong_app/utils/md5Util.dart';
import 'dart:math';
import '../base/presenter/base_presenter.dart';
import '../network/api/network_api.dart';
import '../network/network_util.dart';
import '../utils/PreferenceUtils.dart';
import '../views/chargeGoldPage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../views/chargeVipPage.dart';

class ChargeVipPagePresenter extends BasePresenter<ChargeVipPageState>{

  /// 支付接口
  String payUrl;

  /// 支付回掉地址
  String callUrl;

  /// 支付密鈅
  String token;

  /// APP ID
  String appId;

  /// 用户ID
  String userId;

  /**
   * 充值金币
   *  type: 1 支付宝  2  微信
   *  money: RMB
   */
  void createOrder(int type,int money,String orderNo) async {

    Future.wait([
      PreferenceUtils.instance.getString("payUrl").then((val)=>payUrl = val,),
      PreferenceUtils.instance.getString("callUrl").then((val)=>callUrl = val,),
      PreferenceUtils.instance.getString("token").then((val)=>token = val,),
      PreferenceUtils.instance.getString("appId").then((val)=>appId = val,),
      PreferenceUtils.instance.getString("userId").then((val)=>userId = val,),
    ]).then((res){
      if(payUrl != null && callUrl != null && token != null && appId != null && userId != null){
        String payType = getPayType(type);
        /// 校验支付方式
        if(payType == null){
          view.showToast('未知支付方式，请通知开发排查...');
          return ;
        }

        /// 发送请求创建支付订单
        requestCreateOrder(payType,money,orderNo);
        /// 发送请求创建回调后台创建订单
        createCallbackOrder(payType,money,orderNo);
      }else{
        view.showToast('支付请求创建订单失败，请联系开发...');
      }
    }).catchError((e,stack){
      print('支付请求创建订单失败: $e');
      print('支付请求创建订单失败(堆栈): $stack');
    });
  }

  /**
   * 发送四方请求创建订单
   */
  void requestCreateOrder(String payType,int money,String orderNo){
    Map<String,String> params = Map();
    try{
      params['appId'] = appId;
      /// 订单号
      params['merchantOrderNo'] = orderNo;
      params['type'] = payType;
      params['amount'] = money.toString();
      params['notifyUrl'] = callUrl;
      params['signType'] = 'MD5';
      params['version'] = '2.0';
      params['subject'] = '购物';
      Map body = {'money':money,};
      params['body'] = json.encode(body);
      params['sign'] = sign(params);

      print('签名字符串:' + params['sign']);
      print('请求四方支付，请求参数：' + json.encode(params));

      requestFutureData<String>(
      Method.post,
      url: payUrl,
      queryParams: params,
      onSuccess: (data) {
        if (data != null) {
          Map<String, dynamic> map = parseData(data);
          if(map['status'] == 200){
            print('请求四方创建订单成功，订单号:' + orderNo);
            // view.launchUrl(map['data']['data']['payUrl']);
            view.launchUrl(map['data']['payUrl']);
          }else{
            // view.showToast(map['data']['message']);
            view.showToast(map['message']);
          }
        }else{
          view.showToast('系统异常，请程序员查看...');
        }
      },
      onError: (code, msg) {
        view.showToast(msg);
      });
    }catch(e){
      print('请求四方创建订单接口数据异常: $e,请求参数:' + json.encode(params));
    }
  }

  /**
   * 请求回调后台创建订单
   */
  void createCallbackOrder(String payType,int money,String orderNo){
    try{
      Map<String,dynamic> params = Map();
      params['amount'] = money.toString();
      params['bizType'] = 2; /// 业务类型; 1: 会员等级充值; 2: 金币充值
      params['clientIp'] = '';
      params['device'] = 1; /// 设备类型;1:Android; 2:IOS; 3: WEB; 4: 其他
      Map body = {'money':money};
      params['ext'] = json.encode(body);
      params['levelNo'] = 0;
      params['orderNo'] = orderNo;
      params['userId'] = userId;

      requestFutureData<String>(
          Method.post,
          url: Api.HOST_URL + Api.CHARGE_GOLDEN,
          queryParams: params,
          onSuccess: (data) {
            if (data != null) {
              Map<String, dynamic> map = parseData(data);
              if(map['code'] == 200){
              // if(map['data']['code'] == 200){
                print('请求回调后台创建订单成功，订单号:' + orderNo);
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
      print('请求回调后台创建订单接口数据异常: $e');
    }
  }


  /// String appId,String merchantOrderNo,String type,String amount,String notifyUrl,String signType,String version,String subject,String body
  String sign(Map params){
    var sortedKeys = params.keys.toList()..sort();
    String str = '';
    sortedKeys.forEach((k) {
      str = str + k + '=' + params[k] + '&';
    });
    str += 'key=' + token;
    print('签名字符串:' + json.encode(str));
    return Md5Util.digest(str);
  }

  /**
   * 支付方式
   */
  String getPayType(int type){
    if(type == 1){
      return 'alipay';
    }else if(type == 2){
      return 'wechat';
    }else {
      return null;
    }
  }

}