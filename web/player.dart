part of planets;

class Player {
  int color;
  String name;
  Strategy strategy;
  
  Player(this.name, this.color, this.strategy);
  
  static final _noPlayer = new Player("Neutral", Color.LightGray, new AllInStrategy());
  static Player get NoPlayer => _noPlayer;
  
  List<Order> createOrders(Game game)
  {
    return this.strategy.generateOrders(this, game);
  }
  
  String toString()
  {
    return name;
  }
}