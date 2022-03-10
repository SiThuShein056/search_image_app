// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_image_app/ob/response_ob.dart';
import 'package:search_image_app/ob/result_ob.dart';
import 'package:search_image_app/pages/result_page/result_bloc.dart';
import 'package:search_image_app/pages/result_page/result_widget.dart';

class ResultPage extends StatefulWidget {
  String searchText;
  ResultPage(this.searchText);
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final _bloc = ResultBloc();
  RefreshController _controller = RefreshController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.searchImage(widget.searchText);
    _bloc.getResultStream().listen((ResponseOb responseOb) {
      if (responseOb.msgStae == MsgStae.data) {
        if (responseOb.pageState == PageState.first) {
          _controller.refreshCompleted();
          _controller.resetNoData();
        } else if (responseOb.pageState == PageState.load) {
          ResultOb rOb = responseOb.data;
          if (rOb.hits!.length < 20) {
            _controller.loadNoData();
          } else {
            _controller.loadComplete(); //20 ပြီး တစ်ခုပြီးတစ်ခုထပ်လာဘို့
          }
        }
      }
    });
  }

  List<Hits> hits = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.searchText,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<ResponseOb>(
          initialData: ResponseOb(msgStae: MsgStae.loading),
          stream: _bloc.getResultStream(),
          builder: (context, AsyncSnapshot<ResponseOb> snapshot) {
            ResponseOb respOb = snapshot.data!;
            if (respOb.msgStae == MsgStae.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (respOb.msgStae == MsgStae.data) {
              ResultOb rOb = respOb.data;
              if (respOb.pageState == PageState.first) {
                hits = rOb.hits!;
              }
              if (respOb.pageState == PageState.load) {
                hits.addAll(rOb.hits!);
              }
              return SmartRefresher(
                controller: _controller,
                enablePullDown: true,
                enablePullUp: hits.length > 19,
                onLoading: () {
                  _bloc.searchImageMore(widget.searchText);
                },
                onRefresh: () {
                  _bloc.searchImage(widget.searchText);
                },
                child: hits.length == 0
                    ? Center(
                        child: Text("NO DATA"),
                      )
                    : ListView.builder(
                        itemCount: hits.length,
                        itemBuilder: (context, index) {
                          return ResultWidget(hits[index]);
                        }),
              );
            } else {
              return Text("Error");
            }
          }),
    );
  }
}
