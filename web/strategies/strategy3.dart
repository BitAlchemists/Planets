part of planets;

class Strategy3 extends Strategy{
  Strategy3();
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
      
      //we pick a random planet from the lower half of the array
      int start = (otherPlanets.length/2).round();
      int end = otherPlanets.length;
      otherPlanets.removeRange(start, end);
      
      print("Other planets count: ${otherPlanets.length}");
      
      if(otherPlanets.length > 0)
      {
        int randomPlanetIndex = new math.Random().nextInt(otherPlanets.length);
        _target = otherPlanets[randomPlanetIndex];
      }
    }
    
    if(_target != null)
    {
      print("${player.name} going to take over a planet of ${_target.owner}");
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