// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, sized_box_for_whitespace, deprecated_member_use
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:search_image_app/ob/result_ob.dart';
import 'package:path/path.dart';

class DetailPage extends StatefulWidget {
  Hits hits;
  DetailPage(this.hits);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(tr("image_detail")),
          centerTitle: true,
        ),
        body: ListView(children: [
          Container(
            child: CachedNetworkImage(
              imageUrl: widget.hits.webformatURL!,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          ListTile(
            leading: ClipOval(
              child: Container(
                height: 45,
                width: 45,
                child: CachedNetworkImage(
                  imageUrl: widget.hits.webformatURL!,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            title: Text(widget.hits.user.toString()),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(Icons.download_rounded, color: Colors.blue),
                  Text(widget.hits.downloads.toString()),
                ],
              ),
              Column(
                children: [
                  Icon(Icons.favorite, color: Colors.red),
                  Text(widget.hits.likes.toString()),
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.remove_red_eye,
                    color: Colors.green,
                  ),
                  Text(widget.hits.views.toString()),
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.comment,
                    color: Colors.yellow,
                  ),
                  Text(widget.hits.comments.toString()),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Tags",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.hits.tags!.split(",").map((e) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Chip(
                    label: Text(e),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }).toList(),
            ),
          ),
          !isDownloading
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      imageDownload(context);
                    },
                    child: Text(
                      tr("download_image"),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    child: LiquidCircularProgressIndicator(
                      value: int.parse(count) / 100,
                      valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).primaryColor),
                      backgroundColor: Colors.white,
                      borderColor: Theme.of(context).primaryColor,
                      borderWidth: 5.0,
                      direction: Axis.vertical,
                      center: Text(
                        count + " %",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
        ]));
  }

  bool isDownloading = false;
  String count = "0";
  void imageDownload(BuildContext context) async {
    setState(() {
      isDownloading = true;
    });
    Directory directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = (await getExternalStorageDirectory())!;
    }
    String path = directory.path +
        "/images/" +
        DateTime.now().millisecond.toString() +
        basename(widget.hits.largeImageURL!);

    await Dio().download(widget.hits.largeImageURL!, path,
        onReceiveProgress: (receive, total) {
      double percent = (receive / total) * 100;
      print(percent.toStringAsFixed(0));
      setState(() {
        count = percent.toStringAsFixed(0);
      });
      if (percent == 100) {
        setState(() {
          isDownloading = false;
        });
        count = "0";
        _scaffoldKey.currentState!.showSnackBar(SnackBar(
          content: Text(
            tr("successfully_download"),
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
        ));
      }
    });
  }
}
