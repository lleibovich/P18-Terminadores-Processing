class Configuration {
  public String AnimationType = "ANIMACION1";
  public String SensorType = "KINECT";
  public ArrayList<String> Fears = new ArrayList<String>();
  public ArrayList<String> Strengths = new ArrayList<String>();
  public PVector ProjectorResolution = new PVector(800,600);
  public String ProjectorName = "";
  public String FontName = "Arial";
  public int FontSize = 32;
  public float DisalignConversionFactor = 5.5;
  
  public Configuration() {
    File[] files = listFiles(sketchPath());
    for (int i = 0; i < files.length; i++) {
      File f = files[i];
      if (f.getName() == "cfg.txt") {
        // TO-DO: Read config from file and fill properties
        break;
      }
    }
    // Testing config
    this.Fears.add("Fear one");
    this.Fears.add("Fear two");
    this.Fears.add("Fear three");
    this.Fears.add("Fear four");
    this.Fears.add("Fear five");
    this.Fears.add("Fear six");
    this.Fears.add("Fear seven");
    this.Fears.add("Fear eight");
    this.Fears.add("Fear nine");
    this.Fears.add("Fear ten");
    this.Strengths.add("Strength one");
    this.Strengths.add("Strength two");
    this.Strengths.add("Strength three");
    this.Strengths.add("Strength four");
    this.Strengths.add("Strength five");
    this.Strengths.add("Strength six");
    this.Strengths.add("Strength seven");
    this.Strengths.add("Strength eight");
    this.Strengths.add("Strength nine");
    this.Strengths.add("Strength ten");
    
  }
}