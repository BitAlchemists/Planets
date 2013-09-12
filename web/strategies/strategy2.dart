part of planets;

class Strategy2 implements Strategy{
  Strategy2();
  
  List<Order> generateOrders(Player player, Game game){
    
    List<Order> orders = new List<Order>();
    
    List<Player> otherPlayers = new List<Player>.from(game.players);
    otherPlayers.remove(player);
    otherPlayers.add(Player.NoPlayer);
    
    Map<Player, List<Planet>> otherOwnerships = game.ownerships(otherPlayers);
    List<Planet> otherPlanets = new List<Planet>();
    otherOwnerships.forEach((player, planets) => otherPlanets.addAll(planets));
    otherPlanets.sort((Planet a, Planet b) => a.value.compareTo(b.value));
    Planet body = otherPlanets.first;
    
    if(body != null){
      List<Planet> myPlanets = game.ownerships([player])[player];   
      if(myPlanets != null)
      {
        myPlanets.forEach((Planet myBody){
          if(myBody.value > 5){
            orders.add(new Order(player, myBody, body, myBody.value.toInt()-5));             
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