import 'dart:async';

import 'dart:io';

import 'dart:typed_data';

import 'dart:ui' as ui;

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:qr_flutter/qr_flutter.dart';

import 'package:share/share.dart';

import '../utils/toast.dart';

// import 'package:yelena_qr_demo/components/public_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(
        child: AuthQRPage(),
      ),
    );
  }
}


class AuthQRPage extends StatefulWidget {

  @override

  _AuthQRPageState createState() => _AuthQRPageState();

}

class _AuthQRPageState extends State<AuthQRPage> {

  GlobalKey globalKey = GlobalKey();

  String message = 'www.baidu.com';

//嵌入logo至二维码

  Future<ui.Image> _loadOverlayImage() async {
    final completer = Completer<ui.Image>();

    final byteData = await rootBundle.load('lib/assets/images/logo.png');

    ui.decodeImageFromList(byteData.buffer.asUint8List(), completer.complete);

    return completer.future;
  }

  //生成图片文件

  Future<File> _shareUiImage(ui.Image uiImage) async {
    ByteData finalByteData = await uiImage.toByteData(
        format: ImageByteFormat.png);

    Uint8List finalPngBytes = finalByteData.buffer.asUint8List();

    final document = await getApplicationDocumentsDirectory();

    final dir = Directory(document.path + '/Yelena_QR.png');

    final imageFile = File(dir.path);

    await imageFile.writeAsBytes(finalPngBytes);

    return imageFile;
  }


  @override
  Widget build(BuildContext context) {
    final qrFutureBuilder = FutureBuilder(

      future: _loadOverlayImage(),

      builder: (ctx, snapshot) {
        final size = 280.0;

        if (!snapshot.hasData) {
          return Container(width: size, height: size);
        }

        return CustomPaint(

          size: Size.square(size),

          painter: QrPainter(

            errorCorrectionLevel: QrErrorCorrectLevel.M,

            // color: Macro.colorPrimary,

            data: message,

            version: QrVersions.auto,

            embeddedImage: snapshot.data,

            embeddedImageStyle: QrEmbeddedImageStyle(

              size: Size.square(60),

            ),

          ),

        );
      },

    );

    return Scaffold(

      // backgroundColor: Macro.colorPrimary,

        appBar: AppBar(

          title: Text('二维码',/* style: Macro.textStyleAppBarTitle,*/),

        ),

        body: Container(

          width: double.infinity,

          height: double.infinity,

          child: Padding(

            padding: EdgeInsets.all(16.0),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                //生成图片部分

                RepaintBoundary(

                  key: globalKey,

                  child: Container(

                    width: 300,

                    height: 300,

                    color: Colors.white,

                    child: Padding(

                      padding: EdgeInsets.all(16.0),

                      child: Container(

                        color: Colors.white,

                        child: qrFutureBuilder,

                      ),

                    ),

                  ),

                ),

                SizedBox(height: 30,),

                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [

                    Container(

                      width: 120,

                      height: 50,

                      child: ElevatedButton(
                        child: Text('保存'),
                        onPressed: () async {
                        //检查是否有存储权限

                        var status = await Permission.storage.status;

                        if (!status.isGranted) {
                          status = await Permission.storage.request();

                          print(status);

                          return;
                        }

                        BuildContext buildContext = globalKey.currentContext;

                        if (null != buildContext) {
                          RenderRepaintBoundary boundary = buildContext
                              .findRenderObject();

                          ui.Image image = await boundary.toImage();

                          ByteData byteData = await image.toByteData(
                              format: ui.ImageByteFormat.png);

                          final result = await ImageGallerySaver.saveImage(
                              byteData.buffer.asUint8List(), quality: 100,
                              name: 'Lead_Image' + DateTime.now().toString());

                          if (result['isSuccess'].toString() == 'true') {
                            Toast.show('保存成功');
                          } else {
                            Toast.show('保存失败');
                          }
                        }
                      },),),

                    Container(

                      height: 50,

                      width: 120,

                      child: ElevatedButton (
                        child: Text('分享'),
                        onPressed: () async {
                        BuildContext buildContext = globalKey.currentContext;

                        if (null != buildContext) {
                          RenderRepaintBoundary boundary = buildContext
                              .findRenderObject();

                          ui.Image image = await boundary.toImage();

                          File imageFile = await _shareUiImage(image);

                          Share.shareFiles([imageFile.path]);
                        }
                      },),)

                  ],

                ),

              ],

            ),

          ),

        )

    );
  }
}
