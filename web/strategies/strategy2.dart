part of planets;

class Strategy2 extends Strategy{
  Strategy2();
  
  List<Order> generateOrders(Player player, Game game){
    
    List<Order> orders = new List<Order>();
    
    var otherPlanets = this.otherPlanets(player, game);
    print("Other planets count: ${otherPlanets.length}");
        
    if(otherPlanets.length > 0){
      Planet body = otherPlanets.first;
      //print("${player.name} going to take over a planet of ${body.owner}");
      List<Planet> myPlanets = game.ownerships([player])[player];   
      if(myPlanets != null)
      {
        myPlanets.forEach((Planet myBody){
          if(myBody.ships > 5){
            orders.add(new Order(player, myBody, body, myBody.ships.toInt()-5));             
          }
        });
      }
      else
      {
        print("${player.name}: I am dead.");
      }
    }
    
    return orders;

  }
}