import '../utils/globalUtils.dart';


/// 为num 添加扩充类 DeviceUnit 设备单位换算
extension DeviceUnit on num {

  /// [px] 为 以px为单位的 w_h 数值提供不同设备的尺寸适配
  num get px {
    return GlobalUtils.pxFix(this);
  }

  /// [dp] 为 以dp为单位的 w_h 数值提供不同设备的尺寸适配
  num get dp {
    return GlobalUtils.dpFix(this);
  }

  /// [pt] 为 以pt为单位的 w_h 数值提供不同设备的尺寸适配
  num get pt {
    return GlobalUtils.ptFix(this);
  }
}