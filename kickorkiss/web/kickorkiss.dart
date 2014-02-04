import 'dart:html';
import '../lib/view.dart';

void main() {
  var canvasElement = querySelector("#canvas");
  View view = new View(canvasElement, width:25, height:12);
   
  view.draw();
  
  view.connect();
}
