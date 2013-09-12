part of planets;

class AllInStrategy extends Strategy{
  AllInStrategy();
  
  List<Order> generateOrders(Player player, Game game){
    
    List<Order> orders = new List<Order>();
    
    var otherPlanets = this.otherPlanets(player, game);
    
    Planet body = otherPlanets.first;
    
    if(body != null){
      List<Planet> myPlanets = game.ownerships([player])[player];   
      if(myPlanets != null)
      {
        myPlanets.forEach((Planet myBody) => orders.add(new Order(player, myBody, body, myBody.ships.toInt())));
      }
      else
      {
        print("${player.name}: I am dead.");
      }
    }
    
    return orders;

  }
}