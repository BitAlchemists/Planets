part of planets;

class Game extends Sprite implements Animatable{
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  List<Planet> planets;
  List players;
  Map<Player, List<Planet>> _ownerships;
  List<Ship> _arrivedShips;
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
    
    _reset();
    
    _juggler.add(this);
  }
  
  _reset(){
    if(planets != null)
    {
      planets.forEach((Planet planet) => planet.removeFromParent());
      print("Implement me");
    }
    
    if(_arrivedShips != null){
      _arrivedShips.forEach((Ship ship) => ship.removeFromParent());
    }
    
    planets = [];
    _arrivedShips = new List<Ship>();
    
    for(int i = 0; i < 10; i++){
      Planet body = new Planet(_random.nextInt(this.stage.stageWidth), _random.nextInt(this.stage.stageHeight), 20);
      body.value = _random.nextInt(100);
      body.owner = Player.NoPlayer;
      addChild(body);
      planets.add(body);
    }
    
    Strategy strategy = new Strategy2();

    players = [new Player("Player 1", Color.Red, strategy), new Player("Player 2", Color.Blue, strategy), new Player("Player 3", Color.Green, strategy)];
    for(int i = 0; i < players.length; i++) {
      planets[i].owner = players[i];
      planets[i].value = 30;
    }
    
    _updateOwnerships();
  }
  
  bool advanceTime(num time){
    //Add units
    print("adding units");
    players.forEach((Player player) => _ownerships[player].forEach((Planet planet) => planet.value += time));
    
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
    
    return true;
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
      Ship ship = new Ship(order.issuer, sourcePosition, destination);
      addChild(ship);
            
      num travelTime = destinationPoint.distanceTo(sourcePosition) / speed;
      var tween = new Tween(ship, travelTime);
      tween.animate("x", destinationPoint.x);
      tween.animate("y", destinationPoint.y);
      tween.onComplete = (){
        _arrivedShips.add(ship);
      };
      renderLoop.juggler.add(tween);
      
      print("Sending ship to $destinationPoint. travelTime: $travelTime");
    }
    
    order.source.value -= order.unitCount;
  }
  
  _performBattle(Ship ship)
  {
    Planet destination = ship.destination;
    
    if(destination.owner == ship.owner)
    {
      print("Ship arrives and adds 1 to friendly planet");
      destination.value += 1;
    }
    else
    {      
      if(ship.destination.value <= 0)
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
 
  
  _updateOwnerships(){
    _ownerships = new Map<Player, List<Planet>>(); 
    
    List<Player> killedPlayers = new List<Player>();
    List<Player> playersAndNeutral = new List<Player>.from(players);
    playersAndNeutral.add(Player.NoPlayer);
    
    for(Player player in playersAndNeutral){
      List<Planet> playerPlanets = new List<Planet>();
      planets.forEach((Planet planet){
        if(planet.owner == player) {
          playerPlanets.add(planet); 
        }
      });
      if(playerPlanets.length == 0 && player != Player.NoPlayer)
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
    players.forEach((Player player) => result[player] = _ownerships[player] != null ? _ownerships[player] : []);
    
    return result;
  }
  
}