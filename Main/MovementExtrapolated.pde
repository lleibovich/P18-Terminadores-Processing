public class MovementExtrapolated {
  public PVector from;
  public PVector to;
  
  public MovementExtrapolated() {}
  public MovementExtrapolated(PVector pFrom, PVector pTo) {
    this.from = pFrom;
    this.to = pTo;
  }
  
  public String toString() {
    String str = "";
    str += "From: " + this.from;
    str += " - ";
    str += "To: " + this.to;
    return str;
  }
}