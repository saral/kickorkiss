library view;

import "dart:html";
import "grid.dart";
import "peer.dart";
import "package:stagexl/stagexl.dart";
import "dart:convert";

class View {
  final ResourceManager _resourceManager = new ResourceManager();
  final RenderLoop _renderLoop = new RenderLoop();
  
  Stage _stage;
  Grid _grid;
  WebSocket ws;
  Map<int, Peer> peers = new Map();
  
  View(CanvasElement canvas, {width: 10, height: 10 }) {
    _stage = new Stage(canvas);
    _grid = new Grid(width, height, _stage);   
    _renderLoop.addStage(_stage);
  }
  
  void connect() {
    ws = new WebSocket("ws://10.200.1.42:9090/view");
    
    ws.onClose.listen((ev) {
      print("view.ws.closed");
    });
  
    ws.onOpen.listen((ev) {
      print("view.ws.opened");
    });
    
    ws.onMessage.listen((event){
      print("view.ws.message ${event}");
      
      var data = JSON.decode(event.data);
      switch(data['cmd']) {
        case "new-peer":
          print("view.ws.new-peer");
          Peer p = new Peer(_grid.getRandomEmptyPosition(), _grid, _renderLoop, _stage);
          peers[data['id']] = p;
          addPeer(p);
          _stage.addChild(p.draw());
          break;
        case "move":
          Peer p = peers[data['id']];
          if (p != null) {
            p.move(data['dir']);
          }
          break;
      }
    });
    
  }
  
  void draw(){
    _grid.draw();
    var size = _grid.getCellSize();
    for(var peerId in peers.keys) {
      Peer p = peers[peerId];
     // _stage.addChild(p.draw());
    }
  }
  
  void addPeer(Peer peer) {
    _grid.put(peer.position, peer);
    _grid.draw();
  }
  
}