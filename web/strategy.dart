part of planets;

abstract class Strategy
{
  List<Order> generateOrders(Player player, Game game); 
  
  List<Planet> otherPlanets(Player player, Game game){
    List<Player> otherPlayers = new List<Player>.from(game.players);
    otherPlayers.remove(player);
    otherPlayers.add(Player.NoPlayer);
    
    //print("Other players count: ${otherPlayers.length}");
    
    Map<Player, List<Planet>> otherOwnerships = game.ownerships(otherPlayers);
    List<Planet> otherPlanets = new List<Planet>();
    for(Player player in otherOwnerships.keys)
    {
      List<Planet> planets = otherOwnerships[player];
      otherPlanets.addAll(planets); 
    }
    otherPlanets.sort((Planet a, Planet b) => a.ships.compareTo(b.ships));

    return otherPlanets;
  }
  
  List<Planet> myPlanets(Player player, Game game){
    return game.ownerships([player])[player];
  }
}