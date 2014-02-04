import 'dart:html';
import 'dart:convert';

WebSocket ws;
var id;

void main() {  
    print('Peer view started.');
    _connect();
    _bindEvents();
}

void _connect(){
  ws = new WebSocket("ws://10.200.1.42:9090/peer");
  ws.onOpen.listen((ev){
    print("Controller ws-connection opened.");
  });
  ws.onClose.listen((ev){
    print("Controller ws-connection closed.");
  });
  ws.onError.listen((ev){
    print("Controller ws-connection error.");
  });
  ws.onMessage.listen((ev) {
    var json = JSON.decode(ev.data);
    switch (json['cmd']) {
      case "id":
        id = json['id'];
        break;
    }
  });
  print('Connected to 10.200.1.42');
}


void _bindEvents(){
  querySelector('#left').onClick.listen(move);
  querySelector('#right').onClick.listen(move);
  querySelector('#up').onClick.listen(move);
  querySelector('#down').onClick.listen(move);
  //querySelector('#kiss').onClick.listen(move);
  //querySelector('#kick').onClick.listen(move);
}

void move(MouseEvent event){
  print('Event received');
  String eventType = (event.target as ButtonElement).id;
  ws.send(JSON.encode(
            {'cmd': 'move', 
              'id': id,
              'dir' : eventType}
            ));
}