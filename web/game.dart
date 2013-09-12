part of planets;

class Game extends Sprite implements Animatable{
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  List<Planet> planets;
  List players;
  Map<Player, List<Planet>> _ownerships;
  List<Ship> _arrivedShips;
  List<Ship> _travelingShips;
  bool _needToUpdatePlanetOwnerships;
  math.Random _random = new math.Random();
  
  final int _planetCount = 15;
  final num _planetRadius = 12;
  final num _shipSpeed = 40.0;
  final int _initialPlayerPlanetUnitCount = 30;
  final int _initialNeutralPlanetUnitCount = 100;
  
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
    
    _reset();
    
    _juggler.add(this);
  }
  
  _reset(){
    if(planets != null)
    {
      planets.forEach((Planet planet) => planet.removeFromParent());
    }
    
    if(_arrivedShips != null){
      _arrivedShips.forEach((Ship ship) => ship.removeFromParent());
    }
    
    if(_travelingShips != null){
      _travelingShips.forEach((Ship ship) => ship.removeFromParent());
    }
    
    planets = [];
    _arrivedShips = new List<Ship>();
    _travelingShips = new List<Ship>();
    
    for(int i = 0; i < _planetCount; i++){
      Planet body = new Planet(_random.nextInt(this.stage.stageWidth), _random.nextInt(this.stage.stageHeight), _planetRadius);
      body.ships = _random.nextInt(_initialNeutralPlanetUnitCount);
      body.owner = Player.NoPlayer;
      addChild(body);
      planets.add(body);
    }
    
    Strategy strategy2 = new Strategy2();
    Strategy strategy3 = new Strategy3();
    Strategy binStrategy = new BinStrategy();
    
    players = [new Player("Player 1", Color.Red, strategy2), 
               new Player("Player 2", Color.Blue, strategy2),
               new Player("Player 3", Color.Yellow, binStrategy),
               new Player("Player 4", Color.Turquoise, strategy3)];
    for(int i = 0; i < players.length; i++) {
      planets[i].owner = players[i];
      planets[i].ships = _initialPlayerPlanetUnitCount;
    }
    
    _updateOwnerships();
  }
  
  bool advanceTime(num time){
    //Add units
    print("adding units");
    players.forEach((Player player) => _ownerships[player].forEach((Planet planet) => planet.ships += time));
    
    //Battles
    print("battles");
    _arrivedShips.forEach(_performBattle);
    _arrivedShips.clear();
    
    //Create orders
    print("creating orders");
    List<Order> orders = new List<Order>();
    for(Player player in players)
    {
      List<Order> playerOrders = player.createOrders(this);
      orders.addAll(playerOrders);       
    }
    
    //Execute orders
    print("executing orders");
    orders.forEach(_launchFleet);
    
    if(_needToUpdatePlanetOwnerships){
      print("updating ownerships");
      _updateOwnerships();
      _needToUpdatePlanetOwnerships = false;
    }
    
    //Check win conditions
    if(players.length <= 1)
    {
      _reset();
    }
    
    return true;
  }

  _launchFleet(Order order){
    num x = order.source.x;
    num y = order.source.y;
    num radius = order.source.radius;
    Planet destination = order.destination;
    Point destinationPoint = new Point(destination.x, destination.y);
    num speed = _shipSpeed;
    
    for(int i = 0; i < order.unitCount; i++){
      Point sourcePosition = new Point(x + _random.nextDouble()*radius*2-radius, y + _random.nextDouble()*radius*2-radius);
      Ship ship = new Ship(order.issuer, sourcePosition, destination);
      addChild(ship);
      _travelingShips.add(ship);
            
      num travelTime = destinationPoint.distanceTo(sourcePosition) / speed;
      var tween = new Tween(ship, travelTime);
      tween.animate("x", destinationPoint.x);
      tween.animate("y", destinationPoint.y);
      tween.onComplete = (){
        _travelingShips.remove(ship);
        _arrivedShips.add(ship);
      };
      renderLoop.juggler.add(tween);
      
      print("Sending ship to $destinationPoint. travelTime: $travelTime");
    }
    
    order.source.ships -= order.unitCount;
  }
  
  _performBattle(Ship ship)
  {
    Planet destination = ship.destination;
    
    if(destination.owner == ship.owner)
    {
      print("Ship arrives and adds 1 to friendly planet");
      destination.ships += 1;
    }
    else
    {      
      if(ship.destination.ships <= 0)
      {
        print("Ship arrives: Taking over planet");
        destination.owner = ship.owner;
        _needToUpdatePlanetOwnerships = true;
      }
      else
      {
        print("Ship arrives: Killing a unit");
        destination.ships -= 1;
      }
    }
    ship.removeFromParent();
  }
 
  
  _updateOwnerships(){
    _ownerships = new Map<Player, List<Planet>>(); 
    
    List<Player> killedPlayers = new List<Player>();
    List<Player> playersAndNeutral = new List<Player>.from(players);
    playersAndNeutral.add(Player.NoPlayer);
    
    for(Player player in playersAndNeutral){
      
      //Create list of planets that belong to the player
      List<Planet> playerPlanets = new List<Planet>();
      planets.forEach((Planet planet){
        if(planet.owner == player) {
          playerPlanets.add(planet); 
        }
      });
      
      //Count the traveling ships that belong to the player
      bool hasTravelingShips = false;
      for(Ship ship in _travelingShips)
      {
        if(ship.owner == player)
        {
          hasTravelingShips = true;
          break;
        }
      }
      
      //Check if the player got killed
      if(playerPlanets.length == 0 && player != Player.NoPlayer && !hasTravelingShips)
      {
        killedPlayers.add(player);
        continue;
      }
      _ownerships[player] = playerPlanets; 
    }    
    
    for(Player player in killedPlayers){
      players.remove(player);
      print("player ${player.name} died");
    }
  }
  
  Map<Player, List<Planet>> ownerships([List<Player> players = null]) {
    if(players == null)
    {
      players = new List<Player>();
    }
    
    Map<Player, List<Planet>> result = new Map<Player, List<Planet>>();
    for(Player player in players)
    {
      if(_ownerships[player] != null)
      {
        result[player] = new List<Planet>.from(_ownerships[player]); 
      }
      else
      {
        result[player] = [];        
      }
    }
    
    return result;
  }
  
}