library grid;

import 'package:stagexl/stagexl.dart';
import 'dart:math';
import 'position.dart';

class Grid {
  static final Random _random = new Random();
  int width;
  int height;
  List _cells;
  Stage _stage;
  
  Grid(this.width, this.height, this._stage){
    _cells = new List(width * height);
  }
  
  void put(Position position, object){
    _cells[_getIndex(position)] = object;    
  }
  
  Object get (Position position){
    return _cells[_getIndex(position)];
  }
  
  void remove(Position pos) {
    _cells[_getIndex(pos)] = null;
  }
  
  int _getIndex(Position position){
    return position.y * width + position.x;
  }
  
  int getCellSize() {
    return _stage.sourceHeight ~/ height;
  }
  
  void draw() {
    for(int x = 0; x < width; x++){
      for(int y = 0; y < height; y++ ){
        drawCell(x, y);
      }
    }
  }
  
  void drawCell(int x, int y) {
    var rect = new Shape();
    
    int size = getCellSize();
    rect.graphics.rect(x * size, y * size, size, size);
    rect.graphics.strokeColor(Color.Gray);
    
    _stage.addChild(rect);
  }
  
  Position getRandomEmptyPosition() {
    var x, y;
    do {
      x = _random.nextInt(width);
      y = _random.nextInt(height);
    }while ( get(new Position(x, y)) != null );
    return new Position(x, y);
  }
}
