part of planets;

class ClosestPlanetStrategy extends Strategy{
  ClosestPlanetStrategy();
  Planet _target;
  
  List<Order> generateOrders(Player player, Game game){
    
    List<Order> orders = new List<Order>();
    
    //Validate the old target is still correct
    if(_target != null)
    {
      if(_target.owner == player)
      {
        _target = null; 
      }
    }
    
    //Aquire a new target
    if(_target == null)
    {
      var otherPlanets = this.otherPlanets(player, game);
      
      List<Planet> myPlanets = this.myPlanets(player, game);
      Point center = Planet.centerOf(myPlanets);
      
      otherPlanets.sort((Planet a, Planet b){
        Point pa = new Point(a.x, a.y);
        Point pb = new Point(b.x, b.y);
        return pa.distanceTo(center).compareTo(pb.distanceTo(center));
      });
      
      //print("Other planets count: ${otherPlanets.length}");
      
      if(otherPlanets.length > 0)
      {
        _target = otherPlanets.first;
      }
    }
    
    if(_target != null)
    {
      //print("${player.name} going to take over a planet of ${_target.owner}");
      List<Planet> myPlanets = game.ownerships([player])[player];   
      if(myPlanets != null)
      {
        myPlanets.forEach((Planet myBody){
          if(myBody.ships > 5){
            orders.add(new Order(player, myBody, _target, myBody.ships.toInt()-5));             
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