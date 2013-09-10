part of planets;

class Player {
  int color;
  Player(this.color);
  
  static final _noPlayer = new Player(Color.LightGray);
  static Player get NoPlayer => _noPlayer;
  
  List<Order> createOrders(Game game)
  {
    List<Order> orders = new List<Order>();
    Map<Player, List<Body>> bodiesByPlayer = game.bodiesByPlayer;
    List<Body> allBodies = new List<Body>.from(game.bodies);
    allBodies.sort((Body a, Body b) => a.value.compareTo(b.value));
    Body body = allBodies.firstWhere((Body testBody) => testBody.owner != this, orElse: ()=>null);
    
    if(body != null){
      List<Body> myBodies = bodiesByPlayer[this];     
      myBodies.forEach((Body myBody) => orders.add(new Order(myBody, body, myBody.value)));
    }
    
    return orders;
  }
}