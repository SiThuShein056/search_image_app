import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:search_image_app/ob/response_ob.dart';
import 'package:search_image_app/ob/result_ob.dart';
import 'package:search_image_app/util/util.dart';

class ResultBloc {
  StreamController<ResponseOb> _controller =
      StreamController<ResponseOb>.broadcast();
  Stream<ResponseOb> getResultStream() => _controller.stream;
  int page = 1;
  searchImage(String searchImage) async {
    page = 1;
    var response = await http
        .get(Uri.parse("$BASE_URL?key=$API_KEY&q=$searchImage&page=$page"));
    ResponseOb respOb = ResponseOb(msgStae: MsgStae.loading);
    _controller.sink.add(respOb);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      ResultOb rOb = ResultOb.fromJson(map);
      respOb.msgStae = MsgStae.data;
      respOb.data = rOb;
      respOb.pageState = PageState.first;
    } else if (response.statusCode == 400) {
      respOb.msgStae = MsgStae.error;
      respOb.errState = ErrState.notfoundErr;
      _controller.sink.add(respOb);
    } else if (response.statusCode == 505) {
      respOb.msgStae = MsgStae.error;
      respOb.errState = ErrState.serverErr;
      _controller.sink.add(respOb);
    } else {
      respOb.msgStae = MsgStae.error;
      respOb.errState = ErrState.unknownErr;
      _controller.sink.add(respOb);
    }
  }

  searchImageMore(String searchImage) async {
    page++;
    var response = await http
        .get(Uri.parse("$BASE_URL?key=$API_KEY&q=$searchImage&page=$page"));
    ResponseOb respOb = ResponseOb(msgStae: MsgStae.loading);
    _controller.sink.add(respOb);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      ResultOb rOb = ResultOb.fromJson(map);
      respOb.msgStae = MsgStae.data;
      respOb.data = rOb;
      respOb.pageState = PageState.load;
    } else if (response.statusCode == 400) {
      respOb.msgStae = MsgStae.error;
      respOb.errState = ErrState.notfoundErr;
      _controller.sink.add(respOb);
    } else if (response.statusCode == 505) {
      respOb.msgStae = MsgStae.error;
      respOb.errState = ErrState.serverErr;
      _controller.sink.add(respOb);
    } else {
      respOb.msgStae = MsgStae.error;
      respOb.errState = ErrState.unknownErr;
      _controller.sink.add(respOb);
    }
  }

  Dispose() {
    _controller.close();
  }
}
