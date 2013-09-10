part of planets;

class Game extends Sprite implements Animatable{
  
  ResourceManager _resourceManager;
  Juggler _juggler;
  List<Body> bodies;
  List players;
  
  Map<Player, List<Body>> get bodiesByPlayer {
    Map<Player, List<Body>> result = new Map<Player, List<Body>>(); 
    
    bodies.forEach((Body body){
      List<Body> bodies = result[body.owner];
      if(bodies == null){
        bodies = new List<Body>();
        result[body.owner] = bodies;
      }
      bodies.add(body);
    });
    
    return result;
  }
  
  Game(ResourceManager resourceManager) {
    _resourceManager = resourceManager;
    this.onAddedToStage.listen(_onAddedToStage);
  }

  _onAddedToStage(Event e) {
    _juggler = stage.juggler;
  
    Shape background = new Shape();
    background.graphics.rect(0, 0, this.stage.stageWidth, this.stage.stageHeight);
    background.graphics.fillColor(Color.Black);
    this.addChild(background);
    
    bodies = [];
    math.Random random = new math.Random();
    for(int i = 0; i < 10; i++){
      Body body = new Body(random.nextInt(this.stage.stageWidth), random.nextInt(this.stage.stageHeight), 20);
      body.owner = Player.NoPlayer;
      addChild(body);
      bodies.add(body);
    }

    players = [new Player(Color.Red), new Player(Color.Blue), new Player(Color.Green)];
    for(int i = 0; i < players.length; i++) {
      bodies[i].owner = players[i];
      bodies[i].value = 10;
    }
    
    _juggler.add(this);
  }
  
  bool advanceTime(num time){
    bodies.forEach((Body body) => body.value += 1);

    List<Order> orders = new List<Order>();
    players.forEach((Player player) => orders.addAll(player.createOrders(this)));
    
    return true;
  }
  
}