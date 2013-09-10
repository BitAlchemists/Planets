part of planets;

class Body extends Sprite
{
  TextField _pointsTextField;
  Shape _shape;
  
  int _value;
  int get value => _value;
      set value(int value){
        _value = value;
        _pointsTextField.text = value.toString();
      }
  
  Player _owner;
  Player get owner => _owner;
    set owner(Player owner){
    _owner = owner;
    _shape.graphics.fillColor(owner.color);
  }
      
  Body(num x, num y, num radius) {
    _value = 0;

    _shape = new Shape();
    _shape.graphics.circle(x, y, radius);
    _shape.graphics.fillColor(Color.LightGray);
    
    SimpleButton button = new SimpleButton(_shape, _shape, _shape, _shape);
    addChild(button);

    _pointsTextField = new TextField();
    _pointsTextField.defaultTextFormat = new TextFormat("Arial", 30, 0x000000, bold:true, align:TextFormatAlign.CENTER);
    _pointsTextField.width = radius*2;
    _pointsTextField.height = radius*2;
    _pointsTextField.wordWrap = false;
    //_pointsTextField.selectable = false;
    _pointsTextField.x = x-radius;
    _pointsTextField.y = y-radius;
    //_pointsTextField.filters = [new GlowFilter(0x000000, 1.0, 2, 2)];
    _pointsTextField.mouseEnabled = false;
    _pointsTextField.text = "0";
    //_pointsTextField.scaleX = 0.9;
    addChild(_pointsTextField);    
  }
}