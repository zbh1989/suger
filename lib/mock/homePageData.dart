/**
 * 启动公告
 */
String getAdvoce(){
  String msg =
  '1、每次提现金额最低300元起，只可提现100的整数 \n2、提现收取10%手续费，如提现100元则扣除余额110元，实际到账100元 \n3、仅支持银行卡提现，收款账户卡号和姓名必须一直，到账时间24h内. \n4.测试版本更新';
  return msg;
}

/**
 * 搜索页面跳转到短视频页面，根据视频ID 搜索短视频
 */
Map<String,dynamic> searchShortVideoById(String videoId){
  Map<String,dynamic> shortVideoInfo = Map();
  String anchorAvatarImg = 'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg'; // 主播头像
  String videoUrl = 'https://media.w3.org/2010/05/sintel/trailer.mp4'; // 主播视频
  shortVideoInfo['anchorAvatarImg'] = anchorAvatarImg; // 主播头像图片
  shortVideoInfo['videoUrl'] = videoUrl;
  shortVideoInfo['anchorId'] = 0;  // 主播ID
  shortVideoInfo['anchorName'] = '隔壁老王'; // 主播名称
  shortVideoInfo['videoId'] = 1;
  shortVideoInfo['videoDesc'] = '隔壁老王原创作品 - 搜索页面跳转短视频';//视频描述
  shortVideoInfo['anchorId'] = 1; // 当前视频主播ID
  shortVideoInfo['isFocus'] = 1; // 是否关注当前视频主播 ,1 : 已关注 ，2 : 未关注
  shortVideoInfo['isFavorite'] = 1; // 是否点赞当前视频 , 1 : 已点赞 ， 2 : 未点赞
  shortVideoInfo['favoriteNum'] = 3434245; // 点赞数量
  shortVideoInfo['commentNum'] = 3652657; // 评论数量
  shortVideoInfo['shareNum'] = 4326; // 分享数量
  return shortVideoInfo;
}

/**
 * 搜索数据
 */
Map<String,dynamic> searchByKey(String key){
  if(key != '8888'){
    return Map();
  }
  return {
    'longVideoList':[
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介222222222222222222222222222222222222222",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介1111111111111111111111111111111111111111111111111111111111111111111",
        "videoId":2,
        'showLevel': 1, // 1: 免费，2: 金币，3: VIP用户
        'gold':0,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 3, // 1: 免费，2: 金币，3: VIP用户
        'gold':0,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
    ],
    'shortVideoList':[
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介222222222222222222222222222222222222222",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介1111111111111111111111111111111111111111111111111111111111111111111",
        "videoId":2,
        'showLevel': 1, // 1: 免费，2: 金币，3: VIP用户
        'gold':0,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 3, // 1: 免费，2: 金币，3: VIP用户
        'gold':0,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
    ],
  };
}

/**
 * 查询搜索页面数据
 */
Map<String,dynamic> getSearchPageInfo(){
  return {
    'hotSearch':['三分野','妻子的新世界','公诉','奔跑吧','斗破苍穹年翻','斗罗大陆','漫长的季节',],
    'recommandVideoList':[
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介222222222222222222222222222222222222222",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介1111111111111111111111111111111111111111111111111111111111111111111",
        "videoId":2,
        'showLevel': 1, // 1: 免费，2: 金币，3: VIP用户
        'gold':0,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 3, // 1: 免费，2: 金币，3: VIP用户
        'gold':0,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
    ],
  };
}


/**
 * 充值金币
 */
List<Map<String,dynamic>> getChargeData(){
  return [
    {
      'money':50,
      'gold':500,
      'extraGold':88,
      'desc':'赠88金币',
      'isSelect':0, // 1： 选中 ，2： 未选中
    },
    {
      'money':100,
      'gold':1000,
      'extraGold':188,
      'desc':'赠188金币',
      'isSelect':0, // 1： 选中 ，2： 未选中
    },
    {
      'money':200,
      'gold':2000,
      'extraGold':388,
      'desc':'赠388金币',
      'isSelect':0, // 1： 选中 ，2： 未选中
    },


    {
      'money':300,
      'gold':3000,
      'extraGold':588,
      'desc':'赠588金币',
      'isSelect':0, // 1： 选中 ，2： 未选中
    },
    {
      'money':500,
      'gold':5000,
      'extraGold':1088,
      'desc':'赠1088金币',
      'isSelect':0, // 1： 选中 ，2： 未选中
    },
    {
      'money':1000,
      'gold':10000,
      'extraGold':3888,
      'desc':'赠3888金币',
      'isSelect':0, // 1： 选中 ，2： 未选中
    },
  ];
}

/**
 * 专题明细
 */
Map<String,dynamic> getTopicDetailList(int pageNum,int pageSize,String topicId){
  print('当前加载第 $pageNum 页数据');
  if(pageNum > 3){
    return {
      'headerImg': pageNum == 1 ? 'https://img2.baidu.com/it/u=1289382651,2149435600&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=333' : 'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'title':'蜜桃影像传媒新番推荐',
      'totalVideo':200,
      'detailList': []
    };
  }
  List<Map<String,dynamic>> topicDetailList = [
    {
      'topicId':1,
      'imgUrl':'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'videoId':1,
      'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
      'gold':1290, //金币数量，只有showLevel 为2 的时候有值
      'duration':'00:23:45', // 视频时长
      'watchTimes': 23432, // 观看次数
      'desc':'遇见心动的声音',
     },
    {
      'topicId':1,
      'imgUrl':'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'videoId':1,
      'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
      'gold':129, //金币数量，只有showLevel 为2 的时候有值
      'duration':'00:23:45', // 视频时长
      'watchTimes': 23432, // 观看次数
      'desc':'遇见心动的声音',
     },
    {
      'topicId':1,
      'imgUrl':'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'videoId':1,
      'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
      'gold':129, //金币数量，只有showLevel 为2 的时候有值
      'duration':'00:23:45', // 视频时长
      'watchTimes': 23432, // 观看次数
      'desc':'遇见心动的声音',
     },
    {
      'topicId':1,
      'imgUrl':'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'videoId':1,
      'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
      'gold':129, //金币数量，只有showLevel 为2 的时候有值
      'duration':'00:23:45', // 视频时长
      'watchTimes': 23432, // 观看次数
      'desc':'遇见心动的声音',
     },
    {
      'topicId':1,
      'imgUrl':'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'videoId':1,
      'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
      'gold':129, //金币数量，只有showLevel 为2 的时候有值
      'duration':'00:23:45', // 视频时长
      'watchTimes': 23432, // 观看次数
      'desc':'遇见心动的声音',
     },
    {
      'topicId':1,
      'imgUrl':'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'videoId':1,
      'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
      'gold':129, //金币数量，只有showLevel 为2 的时候有值
      'duration':'00:23:45', // 视频时长
      'watchTimes': 23432, // 观看次数
      'desc':'遇见心动的声音',
     },
    {
      'topicId':1,
      'imgUrl':'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'videoId':1,
      'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
      'gold':129, //金币数量，只有showLevel 为2 的时候有值
      'duration':'00:23:45', // 视频时长
      'watchTimes': 23432, // 观看次数
      'desc':'遇见心动的声音',
     },
    {
      'topicId':1,
      'imgUrl':'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'videoId':1,
      'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
      'gold':129, //金币数量，只有showLevel 为2 的时候有值
      'duration':'00:23:45', // 视频时长
      'watchTimes': 23432, // 观看次数
      'desc':'遇见心动的声音',
     },
    {
      'topicId':1,
      'imgUrl':'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'videoId':1,
      'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
      'gold':129, //金币数量，只有showLevel 为2 的时候有值
      'duration':'00:23:45', // 视频时长
      'watchTimes': 23432, // 观看次数
      'desc':'遇见心动的声音',
     },
    {
      'topicId':1,
      'imgUrl':'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'videoId':1,
      'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
      'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
      'gold':129, //金币数量，只有showLevel 为2 的时候有值
      'duration':'00:23:45', // 视频时长
      'watchTimes': 23432, // 观看次数
      'desc':'遇见心动的声音',
     },

  ];

  return {
    'headerImg': pageNum == 1 ? 'https://img2.baidu.com/it/u=1289382651,2149435600&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=333' : 'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
    'title':'蜜桃影像传媒新番推荐',
    'totalVideo':200,
    'detailList': topicDetailList
  };
}

/**
 * 专题列表
 */
List getTopicList(){
  return [
    {
      'imgUrl':'https://img11.360buyimg.com/imgzone/jfs/t1/121578/15/21088/116267/6224bde9Ea88aa5fe/a545bd58e1651c5a.jpg',
      'topicId':1,
      'totalVideo':200,
    },
    {
      'imgUrl':'https://p5.itc.cn/images01/20230425/9a56bbb130db419dbc34fce5b841b848.jpeg',
      'topicId':2,
      'totalVideo':220,
    },
    {
      'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
      'topicId':3,
      'totalVideo':123,
    },
    {
      'imgUrl':'https://img0.baidu.com/it/u=2419803585,211044956&fm=253&fmt=auto&app=120&f=JPEG?w=1280&h=800',
      'topicId':4,
      'totalVideo':433,
    },
    {
      'imgUrl':'https://img10.360buyimg.com/imgzone/jfs/t1/204438/8/7828/75987/614c274aEda4e554e/ed1493f2ff9ec187.jpg',
      'topicId':5,
      'totalVideo':223,
    },
    {
      'imgUrl':'https://img2.baidu.com/it/u=1289382651,2149435600&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=333',
      'topicId':5,
      'totalVideo':5453,
    },

  ];
}

/**
 * 长视频播放页面数据加载
 */
Map<String,dynamic> getWatchVideoPageInfo(String userId,String videoId){
  return {
    'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
    'duration':'30:42',
    'videoTitle':'PMTC029 同城约会古代穿越 唐雨菲',
    'watchTimes':'100W',
    'lastUpdateTime':'2023-06-06',
    "showType":1, // 1 横着放，一行放两个图片，2 竖着放，一行放三个图片
    'recommandTitle':[
      '女神',
      '极品',
      '原创',
      '彩虹传媒',
    ],
    'isFavorite':1, // 1: 点赞 ，2: 未点赞
    'isCollect':1, // 1: 已收藏 ,2: 未收藏
    'level':1,// 1: 普通用户, 2: 金币用户, 3: VIP用户
    'adId':10,
    'adImgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
    'favoriteTotal':'17.5K',
    'collectTotal':'28.5K',
    'guessLikeVideos':[
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介222222222222222222222222222222222222222",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介1111111111111111111111111111111111111111111111111111111111111111111",
        "videoId":2,
        'showLevel': 1, // 1: 免费，2: 金币，3: VIP用户
        'gold':0,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 3, // 1: 免费，2: 金币，3: VIP用户
        'gold':0,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
      {
        'videoUrl':'https://media.w3.org/2010/05/sintel/trailer.mp4',
        'imgUrl':'https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg',
        "name":"神雕侠侣",
        "desc":"神雕侠侣简介",
        "videoId":2,
        'showLevel': 2, // 1: 免费，2: 金币，3: VIP用户
        'gold':39,
      },
    ],
  };
}

/**
 * 查询短视频数据接口
  */
List<Map<String,dynamic>> getShortVideoPages(int pageNum){
  print('请求短视频第 $pageNum 页');
  List<Map<String,dynamic>> videoDataList = [];

  String anchorAvatarImg;
  String videoUrl;

  if(pageNum % 2 == 1){
    Map<String,dynamic> shortVideoInfo1 = Map();
    anchorAvatarImg = 'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg'; // 主播头像
    videoUrl = 'https://media.w3.org/2010/05/sintel/trailer.mp4'; // 主播视频
    shortVideoInfo1['anchorAvatarImg'] = anchorAvatarImg; // 主播头像图片
    shortVideoInfo1['videoUrl'] = videoUrl;
    shortVideoInfo1['anchorId'] = 0;  // 主播ID
    shortVideoInfo1['anchorName'] = '隔壁老王'; // 主播名称
    shortVideoInfo1['videoId'] = 1;
    shortVideoInfo1['videoDesc'] = '隔壁老王原创作品 - 1-第 $pageNum 页';//视频描述
    shortVideoInfo1['anchorId'] = 1; // 当前视频主播ID
    shortVideoInfo1['isFocus'] = 1; // 是否关注当前视频主播 ,1 : 已关注 ，2 : 未关注
    shortVideoInfo1['isFavorite'] = 1; // 是否点赞当前视频 , 1 : 已点赞 ， 2 : 未点赞
    shortVideoInfo1['favoriteNum'] = 99999; // 点赞数量
    shortVideoInfo1['commentNum'] = 3422; // 评论数量
    shortVideoInfo1['shareNum'] = 43242; // 分享数量
    videoDataList.add(shortVideoInfo1);

    Map<String,dynamic> shortVideoInfo2 = Map();
    anchorAvatarImg = 'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg'; // 主播头像
    videoUrl = 'https://v-cdn.zjol.com.cn/276984.mp4'; // 主播视频
    shortVideoInfo2['anchorAvatarImg'] = anchorAvatarImg; // 主播头像图片
    shortVideoInfo2['videoUrl'] = videoUrl;
    shortVideoInfo2['anchorId'] = 0;  // 主播ID
    shortVideoInfo2['anchorName'] = '隔壁老王'; // 主播名称
    shortVideoInfo2['videoId'] = 2;
    shortVideoInfo2['videoDesc'] = '隔壁老王原创作品 - 2-第 $pageNum 页';//视频描述
    shortVideoInfo2['anchorId'] = 1; // 当前视频主播ID
    shortVideoInfo2['isFocus'] = 1; // 是否关注当前视频主播 ,1 : 已关注 ，2 : 未关注
    shortVideoInfo2['isFavorite'] = 1; // 是否点赞当前视频 , 1 : 已点赞 ， 2 : 未点赞
    shortVideoInfo2['favoriteNum'] = 23; // 点赞数量
    shortVideoInfo2['commentNum'] = 1321; // 评论数量
    shortVideoInfo2['shareNum'] = 321; // 分享数量
    videoDataList.add(shortVideoInfo2);
  }else if(pageNum % 2 == 0){
    Map<String,dynamic> shortVideoInfo3 = Map();
    anchorAvatarImg = 'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg'; // 主播头像
    videoUrl = 'https://v-cdn.zjol.com.cn/276985.mp4'; // 主播视频
    shortVideoInfo3['anchorAvatarImg'] = anchorAvatarImg; // 主播头像图片
    shortVideoInfo3['videoUrl'] = videoUrl;
    shortVideoInfo3['anchorId'] = 0;  // 主播ID
    shortVideoInfo3['anchorName'] = '隔壁老王'; // 主播名称
    shortVideoInfo3['videoId'] = 3;
    shortVideoInfo3['videoDesc'] = '隔壁老王原创作品 - 3-第 $pageNum 页';//视频描述
    shortVideoInfo3['anchorId'] = 1; // 当前视频主播ID
    shortVideoInfo3['isFocus'] = 1; // 是否关注当前视频主播 ,1 : 已关注 ，2 : 未关注
    shortVideoInfo3['isFavorite'] = 2; // 是否点赞当前视频 , 1 : 已点赞 ， 2 : 未点赞
    shortVideoInfo3['favoriteNum'] = 323; // 点赞数量
    shortVideoInfo3['commentNum'] = 32; // 评论数量
    shortVideoInfo3['shareNum'] = 3213; // 分享数量
    videoDataList.add(shortVideoInfo3);

    Map<String,dynamic> shortVideoInfo4 = Map();
    anchorAvatarImg = 'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg'; // 主播头像
    videoUrl = 'https://v-cdn.zjol.com.cn/276982.mp4'; // 主播视频
    shortVideoInfo4['anchorAvatarImg'] = anchorAvatarImg; // 主播头像图片
    shortVideoInfo4['videoUrl'] = videoUrl;
    shortVideoInfo4['anchorId'] = 0;  // 主播ID
    shortVideoInfo4['anchorName'] = '隔壁老王'; // 主播名称
    shortVideoInfo4['videoId'] = 4;
    shortVideoInfo4['videoDesc'] = '隔壁老王原创作品 - 4-第 $pageNum 页';//视频描述
    shortVideoInfo4['anchorId'] = 1; // 当前视频主播ID
    shortVideoInfo4['isFocus'] = 1; // 是否关注当前视频主播 ,1 : 已关注 ，2 : 未关注
    shortVideoInfo4['isFavorite'] = 2; // 是否点赞当前视频 , 1 : 已点赞 ， 2 : 未点赞
    shortVideoInfo4['favoriteNum'] = 56; // 点赞数量
    shortVideoInfo4['commentNum'] = 76; // 评论数量
    shortVideoInfo4['shareNum'] = 6786; // 分享数量
    videoDataList.add(shortVideoInfo4);

    Map<String,dynamic> shortVideoInfo5 = Map();
    anchorAvatarImg = 'https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg'; // 主播头像
    videoUrl = 'https://media.w3.org/2010/05/sintel/trailer.mp4'; // 主播视频
    shortVideoInfo5['anchorAvatarImg'] = anchorAvatarImg; // 主播头像图片
    shortVideoInfo5['videoUrl'] = videoUrl;
    shortVideoInfo5['anchorId'] = 0;  // 主播ID
    shortVideoInfo5['anchorName'] = '隔壁老王'; // 主播名称
    shortVideoInfo5['videoId'] = 5;
    shortVideoInfo5['videoDesc'] = '隔壁老王原创作品 - 5-第 $pageNum 页';//视频描述
    shortVideoInfo5['anchorId'] = 1; // 当前视频主播ID
    shortVideoInfo5['isFocus'] = 1; // 是否关注当前视频主播 ,1 : 已关注 ，2 : 未关注
    shortVideoInfo5['isFavorite'] = 2; // 是否点赞当前视频 , 1 : 已点赞 ， 2 : 未点赞
    shortVideoInfo5['favoriteNum'] = 334; // 点赞数量
    shortVideoInfo5['commentNum'] = 246; // 评论数量
    shortVideoInfo5['shareNum'] = 213; // 分享数量
    videoDataList.add(shortVideoInfo5);
  }
  return videoDataList;
}

/**
 * 查询顶部菜单专题数据
 */
List<Map<String,dynamic>> getMenuTopicVideoList(String menuId,int pageNum,int pageSize,int showType){ //  分页查询主题数据，1，横着放一页5条数据，2，竖着放一页6条数据
  Map<String,dynamic> m1 = {
    "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"射雕英雄传",
    "desc":"射雕英雄传简介4443333333333333333333333333333",
    "videoId":1,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m2 = {
    "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"神雕侠侣",
    "desc":"神雕侠侣简介",
    "videoId":2,
    "duration":"00:23:14",
    "showLevel": 2, // 1: 免费，2: 金币，3: VIP用户
    "gold":50 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m3 = {"imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"倚天屠龙记",
    "desc":"倚天屠龙记简介",
    "videoId":3,
    "duration":"01:33:14",
    "showLevel": 3, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m4 = {
    "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"射雕英雄传",
    "desc":"射雕英雄传简介",
    "videoId":1,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m5 = {
    "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"神雕侠侣",
    "desc":"神雕侠侣简介",
    "videoId":2,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m6 = {"imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"倚天屠龙记",
    "desc":"倚天屠龙记简介",
    "videoId":3,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m7 = {"imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"倚天屠龙记",
    "desc":"倚天屠龙记简介",
    "videoId":3,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m8 = {
    "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"神雕侠侣",
    "desc":"神雕侠侣简介",
    "videoId":2,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m9 = {"imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"倚天屠龙记",
    "desc":"倚天屠龙记简介",
    "videoId":3,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };



  Map<String,dynamic> m10 = {
    "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"神雕侠侣",
    "desc":"神雕侠侣简介",
    "videoId":2,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m11 = {"imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"倚天屠龙记",
    "desc":"倚天屠龙记简介",
    "videoId":3,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m12 = {"imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"倚天屠龙记",
    "desc":"倚天屠龙记简介",
    "videoId":3,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m13 = {
    "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"神雕侠侣",
    "desc":"神雕侠侣简介",
    "videoId":2,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m14 = {"imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"倚天屠龙记",
    "desc":"倚天屠龙记简介",
    "videoId":3,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m15 = {"imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"倚天屠龙记",
    "desc":"倚天屠龙记简介",
    "videoId":3,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  return showType == 1 ? [m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14] : [m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15];
}

/**
 * 查询首页数据
 */
List getVideoList(String topicId,int showType){ //  分页查询主题数据，1，横着放一页5条数据，2，竖着放一页6条数据
  Map<String,dynamic> m1 = {
    "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"射雕英雄传",
    "desc":"射雕英雄传简介4443333333333333333333333333333",
    "videoId":1,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m2 = {
    "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"神雕侠侣",
    "desc":"神雕侠侣简介",
    "videoId":2,
    "duration":"00:23:14",
    "showLevel": 2, // 1: 免费，2: 金币，3: VIP用户
    "gold":50 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m3 = {"imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"倚天屠龙记",
    "desc":"倚天屠龙记简介",
    "videoId":3,
    "duration":"01:33:14",
    "showLevel": 3, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m4 = {
    "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"射雕英雄传",
    "desc":"射雕英雄传简介",
    "videoId":1,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m5 = {
    "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"神雕侠侣",
    "desc":"神雕侠侣简介",
    "videoId":2,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  Map<String,dynamic> m6 = {"imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
    "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
    "name":"倚天屠龙记",
    "desc":"倚天屠龙记简介",
    "videoId":3,
    "duration":"00:23:14",
    "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
    "gold":0 // 只有showLevel = 2 才有，
  };

  return showType == 1 ? [m1,m2,m3,m4,m5] : [m1,m2,m3,m4,m5,m6];
}


List changeVideoList(String topicId,int showType){ //  和 getVideoList 是一个接口，模拟数据分成两个 分页查询主题数据，1，横着放一页5条数据，2，竖着放一页6条数据
    Map<String,dynamic> m1 = {
      "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
      "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
      "name":"射雕英雄传2",
      "desc":"射雕英雄传简介2",
      "videoId":1,
      "duration":"00:23:14",
      "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
      "gold":0 // 只有showLevel = 2 才有，
    };
    Map<String,dynamic> m2 = {
      "imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
      "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
      "name":"神雕侠侣2",
      "desc":"神雕侠侣简介2",
      "videoId":2,
      "duration":"00:23:14",
      "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
      "gold":0 // 只有showLevel = 2 才有，
    };
    Map<String,dynamic> m3 = {"imgUrl":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg",
      "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
      "name":"倚天屠龙记2",
      "desc":"倚天屠龙记简介2",
      "videoId":3,
      "duration":"00:23:14",
      "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
      "gold":0 // 只有showLevel = 2 才有，
    };
    Map<String,dynamic> m4 = {
      "imgUrl":"https://img.mp.itc.cn/q_70,c_zoom,w_640/upload/20170322/ea167f060df84d2391596f2f84886051_th.jpg",
      "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
      "name":"雪山飞狐2",
      "desc":"雪山飞狐简介2",
      "videoId":4,
      "duration":"00:23:14",
      "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
      "gold":0 // 只有showLevel = 2 才有，
    };
    Map<String,dynamic> m5 = {
      "imgUrl":"https://img.mp.itc.cn/q_70,c_zoom,w_640/upload/20170322/ea167f060df84d2391596f2f84886051_th.jpg",
      "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
      "name":"鹿鼎记2",
      "desc":"鹿鼎记简介2",
      "videoId":5,
      "duration":"00:23:14",
      "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
      "gold":0 // 只有showLevel = 2 才有，
    };
    Map<String,dynamic> m6 = {"imgUrl":"https://img.mp.itc.cn/q_70,c_zoom,w_640/upload/20170322/ea167f060df84d2391596f2f84886051_th.jpg",
      "videoUrl":"https://media.w3.org/2010/05/sintel/trailer.mp4",
      "name":"碧血剑2",
      "desc":"碧血剑简介2",
      "videoId":6,
      "duration":"00:23:14",
      "showLevel": 1, // 1: 免费，2: 金币，3: VIP用户
      "gold":0 // 只有showLevel = 2 才有，
    };
    return showType == 1 ? [m1,m2,m3,m4,m5] : [m1,m2,m3,m4,m5,m6];
}

// 查询轮播信息
Map<String,dynamic> getSwiperInfo(){
  return {
    "swiperFlag":1, // 轮播图开关， 1； 打开， 2： 关闭
    "imgList":[
      {
        "url":"https://p0.itc.cn/q_70/images03/20220908/20795320961944e6a49b7bd5cf68a07e.jpeg"
      },
      {
        "url":"https://p5.itc.cn/images01/20230425/9a56bbb130db419dbc34fce5b841b848.jpeg"
      },
      {
        "url":"https://img.mp.itc.cn/upload/20161229/95c7e4560ec443c6b780d90f32aed0a3_th.jpg"
      },
      {
        "url":"https://img13.360buyimg.com/n0/jfs/t1/115636/26/8841/169838/5ed34fffE133b4588/5774b11c6a90ff1f.jpg"
      }
    ]
  };
}

// 查询视频板块信息和轮播广告信息
List getTitleList(int topMenuId){
  return [
    {
      "topicType":1, // 1: 视频， 2： 广告
      "topic":"今日推荐$topMenuId",
      "topicId":1,
      "showType":1// 1 横着放，一行放两个图片，2 竖着放，一行放三个图片
    },
    {
      "topicType":1, // 1: 视频， 2： 广告
      "topic":"近期热门$topMenuId",
      "topicId":2,
      "showType":2// 1 横着放，一行放两个图片，2 竖着放，一行放三个图片
    },
    {
      "topicType":2, // 1: 视频， 2： 广告
      "topic":"广告",
      "topicId":3,
      "showType":1// 1：横幅广告，只放一个广告图，2： 横着放两个广告图
    },
    {
      "topicType":1, // 1: 视频， 2： 广告
      "topic":"热门主播视频$topMenuId",
      "topicId":4,
      "showType":2// 1 横着放，一行放两个图片，2 竖着放，一行放三个图片
    }
  ];
}

// 查询顶部菜单
List getTopMenu(){
  return [
    {"menuId":1,"menu":"推荐",'isHome':1,'showType':1}, // isHome: 是否是首页（没有设置，取第一条数据为首页） ,1: 是，2: 否, showType: 1 横着放，一行放两个图片，2 竖着放，一行放三个图片,首页优先取专题板块排列方式，没有设置板块排列方式取首页排列方式
    {"menuId":2,"menu":"最新",'isHome':2,'showType':1},
    {"menuId":3,"menu":"福利姬",'isHome':2,'showType':2},
    {"menuId":4,"menu":"主播精选",'isHome':2,'showType':2},
    {"menuId":5,"menu":"一线黑料",'isHome':2,'showType':1},
  ];
}