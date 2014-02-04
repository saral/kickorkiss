library peer;

import 'package:stagexl/stagexl.dart';
import 'position.dart';
import 'grid.dart';
import 'dart:math';

class Peer {
  String name;
  Position position;
  Grid _grid;
  RenderLoop _renderLoop;
  Stage _stage;
  
  Shape _shape;
  TextField _textField;
  Sprite _sprite;
  final Random random = new Random();
  int _energy = 5;

  List colors = [Color.BlanchedAlmond, Color.AntiqueWhite, Color.AliceBlue, Color.Aqua, Color.Aquamarine, Color.Azure, Color.Beige, Color.Bisque  , Color.Black, Color.Blue, Color.BlueViolet, Color.Brown, Color.BurlyWood, Color.CadetBlue, Color.Chartreuse, Color.Chocolate, Color.Coral, Color.CornflowerBlue, Color.Cornsilk, Color.Crimson , Color.Cyan, Color.DarkBlue, Color.DarkCyan, Color.DarkGoldenrod, Color.DarkGray, Color.DarkGreen, Color.DarkKhaki, Color.DarkMagenta  , Color.DarkOliveGreen, Color.DarkOrange, Color.DarkOrchid, Color.DarkRed , Color.DarkSalmon, Color.DarkSeaGreen , Color.DarkSlateBlue, Color.DarkSlateGray, Color.DarkTurquoise, Color.DarkViolet, Color.DeepPink, Color.DeepSkyBlue  , Color.DimGray , Color.DodgerBlue ];
  Peer(this.position, this._grid, this._renderLoop, this._stage);
  
  Sprite draw() {
    var size = _grid.getCellSize();
    var radius = size ~/ 2;
    
    _shape = new Shape();
    _shape.graphics.circle(0, 0, radius);
    _shape.graphics.fillColor(colors[random.nextInt(colors.length)]);
    
    _textField = new TextField(_energy.toString());
    var textFormat1 = new TextFormat('Helvetica,Arial', 14, Color.Black, bold:true);
    _textField.defaultTextFormat = textFormat1;
    _textField.x = -4;
    _textField.y = -9;

    _sprite = new Sprite();
    _sprite.addChild(_shape);
    _sprite.addChild(_textField);
    
    animTo();
    return _sprite;
  }
  
  void move(String dir) {
    switch(dir) {
      case 'up':
        if(position.y - 1 < 0 ) return;
        var newPos = new Position(position.x, position.y - 1);
        moveTo(newPos);
        break;
      case 'down':
        if(position.y + 1 >= _grid.height ) return;
        var newPos = new Position(position.x, position.y + 1);
        moveTo(newPos);
        break;
      case 'left':
        if(position.x - 1 < 0 ) return;
        var newPos = new Position(position.x - 1, position.y);
        moveTo(newPos);
        break;
      case 'right':
        if(position.x + 1 >= _grid.width ) return;
        var newPos = new Position(position.x + 1, position.y);
        moveTo(newPos);
        break;
      case 'kiss':
        
        break;  
      case 'kick':
        
        break;
    }
  }
  
  void decreaseEnergy() {
    _energy--;
    _textField.text = _energy.toString();
    if (_energy <= 0) {
      _grid.remove(this.position);
      _stage.removeChild(_sprite);
    }
  }
  
  void moveTo(Position newPos) {
    print("Peer.moveTo: ${newPos.x} ${newPos.y}");
    if (_energy <= 0) {
      return;
    }
    Peer neighbour = _grid.get(newPos);
    if (neighbour != null) {
      neighbour.decreaseEnergy();
      return; 
    }
    _grid.put(newPos, this);
    _grid.remove(position);
    this.position = newPos;
    animTo();
  }
  void animTo() {
    var tween = new Tween(_sprite, 1.0, TransitionFunction.easeOutBounce);
    var cell = _grid.getCellSize();
    tween.animate.x.to(position.x * cell + (cell ~/ 2));
    tween.animate.y.to(position.y * cell + (cell ~/ 2));

    _renderLoop.juggler.add(tween);
  }
}
