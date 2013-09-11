part of planets;

class Game extends Sprite implements Animatable{
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  List<Planet> bodies;
  List players;
  Map<Player, List<Planet>> _ownerships;
  bool _needToUpdatePlanetOwnerships;
  math.Random _random = new math.Random();
  
  Game(ResourceManager resourceManager) {
    _resourceManager = resourceManager;
    this.onAddedToStage.listen(_onAddedToStage);
    _needToUpdatePlanetOwnerships = false;
  }

  _onAddedToStage(Event e) {
    _juggler = stage.juggler;
  
    Shape background = new Shape();
    background.graphics.rect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
    background.graphics.fillColor(Color.Black);
    this.addChild(background);
    
    bodies = [];
    
    for(int i = 0; i < 10; i++){
      Planet body = new Planet(_random.nextInt(this.stage.stageWidth), _random.nextInt(this.stage.stageHeight), 20);
      body.owner = Player.NoPlayer;
      addChild(body);
      bodies.add(body);
    }
    
    Strategy strategy = new AllInStrategy();

    players = [new Player("Player 1", Color.Red, strategy), new Player("Player 2", Color.Blue, strategy), new Player("Player 3", Color.Green, strategy)];
    for(int i = 0; i < players.length; i++) {
      bodies[i].owner = players[i];
      bodies[i].value = 10;
    }
    
    _updateOwnershipMap();
    
    _juggler.add(this);
  }
  
  bool advanceTime(num time){
    //Add units
    players.forEach((Player player) => _ownerships[player].forEach((Planet planet) => planet.value += time));

    //Create orders
    List<Order> orders = new List<Order>();
    players.forEach((Player player) => orders.addAll(player.createOrders(this)));
    
    //Execute orders
    orders.forEach(_launchFleet);
    
    if(_needToUpdatePlanetOwnerships){
      _updateOwnershipMap();
      _needToUpdatePlanetOwnerships = false;
    }
    
    return true;
  }
  
  _updateOwnershipMap(){
    _ownerships = new Map<Player, List<Planet>>(); 
    
    bodies.forEach((Planet body){
      List<Planet> bodies = _ownerships[body.owner];
      if(bodies == null){
        bodies = new List<Planet>();
        _ownerships[body.owner] = bodies;
      }
      bodies.add(body);
    });
  }
  
  _launchFleet(Order order){
    num x = order.source.x;
    num y = order.source.y;
    num radius = order.source.radius;
    Planet destination = order.destination;
    Point destinationPoint = new Point(destination.x, destination.y);
    num speed = 40.0;
    
    for(int i = 0; i < order.unitCount; i++){
      Point sourcePosition = new Point(x + _random.nextDouble()*radius*2-radius, y + _random.nextDouble()*radius*2-radius);
      Ship ship = new Ship(order.issuer, sourcePosition);
      addChild(ship);
            
      num travelTime = destinationPoint.distanceTo(sourcePosition) / speed;
      var tween = new Tween(ship, travelTime);
      tween.animate("x", destinationPoint.x);
      tween.animate("y", destinationPoint.y);
      tween.onComplete = (){
        _performBattle(ship, destination);
      };
      renderLoop.juggler.add(tween);
      
      print("Sending ship to $destinationPoint. travelTime: $travelTime");
    }
    
    order.source.value -= order.unitCount;
  }
  
  _performBattle(Ship ship, Planet destination)
  {
    if(destination.owner == ship.owner)
    {
      print("Ship arrives and adds 1 to friendly planet");
      destination.value += 1;
    }
    else
    {      
      if(destination.value <= 0)
      {
        print("Ship arrives: Taking over planet");
        destination.owner = ship.owner;
        _needToUpdatePlanetOwnerships = true;
      }
      else
      {
        print("Ship arrives: Killing a unit");
        destination.value -= 1;
      }
    }
    ship.removeFromParent();
  }
  
  Map<Player, List<Planet>> ownerships([List<Player> players = null]) {
    if(players == null)
    {
      players = new List<Player>();
    }
    
    Map<Player, List<Planet>> result = new Map<Player, List<Planet>>();
    players.forEach((Player player) => result[player] = _ownerships[player] != null ? _ownerships[player] : []);
    
    return result;
  }
  
}