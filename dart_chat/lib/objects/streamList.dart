import 'dart:async';

class StreamList<T> {
  late StreamController<List<T>> _controller;
  late List<T> _list;

  StreamList(List<T> list) {
    _list = list;

    _controller = StreamController.broadcast(
        onListen: () {
          _controller.sink.add(this._list);
        }
    );
  }

  Stream<List<T>> get stream => _controller.stream;

  List<T> get list => _list;

  void setList(List<T> list) {
    _list = list;
    sinkList();
  }

  void addToList(T value) {
    _list.add(value);
    sinkList();
  }

  void sinkList() {
    _controller.sink.add(_list);
  }

  void dispose() {
    _controller.close();
  }
}