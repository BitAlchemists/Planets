library planets;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:math' as math;

part 'game.dart';
part 'planet.dart';
part 'player.dart';
part 'order.dart';
part 'ship.dart';
part 'strategy.dart';
part 'strategies/all_in_strategy.dart';
part 'strategies/strategy2.dart';

Stage stage;
RenderLoop renderLoop;

void main() {
  // initialize Stage and RenderLoop
  stage = new Stage("Stage", html.query('#stage'));
  renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  var resourceManager = new ResourceManager();
  resourceManager.addText("PLANETS_1", "Hi");
  
  stage.addChild(new Game(resourceManager));
}

