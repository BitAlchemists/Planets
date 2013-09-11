part of planets;

class Ship extends Sprite{
  Player owner;
  
  Ship(this.owner, Point position){
    Shape shape = new Shape();
    shape.graphics.circle(position.x, position.y, 2);
    shape.graphics.fillColor(Color.White);
    addChild(shape);
  }
}