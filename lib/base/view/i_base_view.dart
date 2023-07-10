
import 'package:flutter/material.dart';

abstract class IBaseView {

  BuildContext getContext();

  void showProgress();

  void showProgressMsg(String msg);

  void closeProgress();

  void showToast(String msg);
}
