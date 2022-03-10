// ignore_for_file: prefer_final_fields, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:search_image_app/ob/response_ob.dart';

class DownloadedImageBloc {
  StreamController<ResponseOb> _controller = StreamController<ResponseOb>();
  Stream<ResponseOb> getStream() => _controller.stream;

  getImage() async {
    ResponseOb responseOb = ResponseOb(msgStae: MsgStae.loading);
    _controller.sink.add(responseOb);
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = (await getExternalStorageDirectory())!;
    }
    Directory path = Directory(directory.path + "/images");

    List<FileSystemEntity> list = path.listSync();
    list.forEach((element) {
      print(element.path.toString());
    });
    responseOb.msgStae = MsgStae.data;
    responseOb.data = list;
    _controller.sink.add(responseOb);
  }

  deleteFile(FileSystemEntity file) {
    file.delete();
    getImage();
  }

  dispose() {
    _controller.close();
  }
}
