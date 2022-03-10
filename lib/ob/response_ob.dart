import 'package:search_image_app/pages/result_page/result_page.dart';

class ResponseOb {
  MsgStae? msgStae;
  ErrState? errState;
  dynamic data;
  PageState? pageState;

  ResponseOb({this.data, this.errState, this.msgStae, this.pageState});
}

enum MsgStae {
  loading,
  data,
  error,
}
enum ErrState {
  notfoundErr,
  serverErr,
  unknownErr,
}
enum PageState {
  first,
  load,
  no_more,
}
