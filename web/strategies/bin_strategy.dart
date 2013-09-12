part of planets;

class BinStrategy extends Strategy{
  BinStrategy();
  
  Planet _target;
  
  List<Order> generateOrders(Player player, Game game){
    
    List<Order> orders = new List<Order>();
    
    int unitReserve = 10;
    
    if(_target == null)
    {
      _target = _findTarget(player, game);      
    }    
    
    
    print("${player.name} going to take over a planet of ${_target.owner}");
    List<Planet> myPlanets = game.ownerships([player])[player];   
    if(myPlanets != null)
    {
      myPlanets.forEach((Planet myBody){
        if(myBody.ships > unitReserve){
          orders.add(new Order(player, myBody, _target, myBody.ships.toInt()-unitReserve));             
        }
      });
    }
    else
    {
      print("${player.name}: I am dead.");
    }
    
    return orders;
  }
  
  _findTarget(Player player, Game game){
    List<Planet> freePlanets = game.ownerships([Player.NoPlayer])[Player.NoPlayer];
    freePlanets.sort(Planet.compareByShipsAscending);
    
    print("Free planets count: ${freePlanets.length}");
    
    if(freePlanets.length > 0){
      return freePlanets.first;
    }
    
    return null;
  }
}