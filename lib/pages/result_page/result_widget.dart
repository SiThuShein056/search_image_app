// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:search_image_app/ob/result_ob.dart';
import 'package:search_image_app/pages/detail_page/detail_page.dart';

class ResultWidget extends StatelessWidget {
  // const ResultWidget({ Key? key }) : super(key: key);
  Hits hits;
  ResultWidget(this.hits);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return DetailPage(hits);
          }));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 180,
              child: CachedNetworkImage(
                imageUrl: hits.webformatURL!,
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
                    imageUrl: hits.webformatURL!,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              title: Text(hits.user.toString()),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.download_rounded, color: Colors.blue),
                    Text(hits.downloads.toString()),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    Text(hits.likes.toString()),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.remove_red_eye,
                      color: Colors.green,
                    ),
                    Text(hits.views.toString()),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.comment,
                      color: Colors.yellow,
                    ),
                    Text(hits.comments.toString()),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
  }
}
