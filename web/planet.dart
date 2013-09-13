part of planets;

class Planet extends Sprite
{
  TextField _pointsTextField;
  Shape _shape;
  num radius;
  
  num _ships;
  num get ships => _ships;
      set ships(num value){
        _ships = value;
        _pointsTextField.text = value.toInt().toString();
      }
  
  Player _owner;
  Player get owner => _owner;
    set owner(Player owner){
    _owner = owner;
    _shape.graphics.fillColor(owner.color);
  }
      
  Planet(x, y, this.radius) {
    _ships = 0;
    
    this.x = x;
    this.y = y;

    _shape = new Shape();
    _shape.graphics.circle(0, 0, radius);
    _shape.graphics.fillColor(Color.LightGray);
    
    SimpleButton button = new SimpleButton(_shape, _shape, _shape, _shape);
    addChild(button);

    _pointsTextField = new TextField();
    _pointsTextField.defaultTextFormat = new TextFormat("Arial", this.radius, 0x000000, bold:true, align:TextFormatAlign.CENTER);
    _pointsTextField.width = radius*2;
    _pointsTextField.height = radius*2;
    _pointsTextField.wordWrap = false;
    //_pointsTextField.selectable = false;
    _pointsTextField.x = 0-radius;
    _pointsTextField.y = 0-radius;
    //_pointsTextField.filters = [new GlowFilter(0x000000, 1.0, 2, 2)];
    _pointsTextField.mouseEnabled = false;
    _pointsTextField.text = "0";
    //_pointsTextField.scaleX = 0.9;
    addChild(_pointsTextField);    
  }
  
  static int compareByShipsAscending(Planet a, Planet b){
    return a.ships.compareTo(b.ships);
  }
  
  static Point centerOf(List<Planet> planets){
    double dx = 0.0;
    double dy = 0.0;
    for(Planet planet in planets){
      dx += planet.x;
      dy += planet.y;
    }
    
    int count = planets.length;
    return new Point(dx/count, dy/count);
  }
  
  double distanceTo(Planet other){
    num dx = x - other.x;
    num dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }
  
  /*
   * 
   *       //we pick a random planet from the lower half of the array
      int start = (otherPlanets.length/2).round();
      int end = otherPlanets.length;
      otherPlanets.removeRange(start, end);
              int randomPlanetIndex = new math.Random().nextInt(otherPlanets.length);
      
   
   */
}