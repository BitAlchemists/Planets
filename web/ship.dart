part of planets;

class Ship extends Sprite{
  Player owner;
  Planet destination;
  
  Ship(this.owner, Point position, this.destination, num radius){
    this.x = position.x;
    this.y = position.y;
    
    Shape shape = new Shape();
    shape.graphics.circle(0, 0, radius);
    shape.graphics.fillColor(this.owner.color);
    addChild(shape);
  }
}