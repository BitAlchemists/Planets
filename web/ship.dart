part of planets;

class Ship extends Sprite{
  Player owner;
  
  Ship(this.owner, Point position){
    this.x = position.x;
    this.y = position.y;
    
    Shape shape = new Shape();
    shape.graphics.circle(0, 0, 2);
    shape.graphics.fillColor(Color.White);
    addChild(shape);
  }
}