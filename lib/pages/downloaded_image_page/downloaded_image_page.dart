// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:search_image_app/ob/response_ob.dart';
import 'package:search_image_app/pages/downloaded_image_page/downloaded_image_bloc.dart';

class DownloadedImagePage extends StatefulWidget {
  @override
  _DownloadedImagePageState createState() => _DownloadedImagePageState();
}

class _DownloadedImagePageState extends State<DownloadedImagePage> {
  final _bloc = DownloadedImageBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("downloaded_images")),
        centerTitle: true,
      ),
      body: StreamBuilder<ResponseOb>(
          initialData: ResponseOb(msgStae: MsgStae.loading),
          stream: _bloc.getStream(),
          builder: (BuildContext context, AsyncSnapshot<ResponseOb> snapshot) {
            ResponseOb reOb = snapshot.data!;
            if (reOb.msgStae == MsgStae.data) {
              return reOb.data.length == 0
                  ? Center(child: Text("NO IMAGE"))
                  : ListView.builder(
                      itemCount: reOb.data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Image.file(reOb.data[index]),
                            IconButton(
                              onPressed: () {
                                _bloc.deleteFile(reOb.data[index]);
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            )
                          ],
                        );
                      });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
