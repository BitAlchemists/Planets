part of planets;

class Order {
  Player issuer;
  Planet source;
  Planet destination;
  int unitCount;
  
  Order(this.issuer, this.source, this.destination, this.unitCount);
}