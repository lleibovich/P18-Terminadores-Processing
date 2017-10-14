class Configuration {
  public String AnimationType = "ANIMACION1";
  public String SensorType = "KINECT";
  public String CameraName = "";
  public Integer BackgroundColor = color(220, 230, 240);
  public ArrayList<String> Fears = new ArrayList<String>();
  public ArrayList<Integer> FearsColors = new ArrayList<Integer>(); // colors are integers, add new item with color(r,g,b)
  public ArrayList<String> Strengths = new ArrayList<String>();
  public ArrayList<Integer> StrengthsColors = new ArrayList<Integer>(); // colors are integers, add new item with color(r,g,b)
  public PVector ProjectorResolution = new PVector(800,600);
  public String ProjectorName = "";
  public String FontName = "Arial";
  public int FontSize = 48;
  public float DisalignConversionFactor = 55.5;
  public int DisalignIntervalMs = 500;
  public String LocationType = "RANDOM";
  
  public Configuration() {
    File[] files = listFiles(sketchPath());
    for (int i = 0; i < files.length; i++) {
      File f = files[i];
      if (f.getName().equals("cfg.txt")) {
        BufferedReader reader = createReader(f.getName());
        boolean read = true;
        while (read) {
          String line = "";
          try {
            line = reader.readLine();
          } catch (Exception ex) {
            line = null;
          }
          if (line == null || line.equals("")) {
            read = false;
          } else {
            // Process line
            String[] keyValue = line.split("=");
            switch(keyValue[0]) {
              case "AnimationType":
                this.AnimationType = keyValue[1];
                break;
              case "SensorType":
                this.SensorType = keyValue[1];
                break;
              case "CameraName":
                this.CameraName = keyValue[1];
                break;
              case "ProjectorName":
                this.ProjectorName = keyValue[1];
                break;
              case "ProjectorResolution":
                String[] coord = splitTokens(keyValue[1], ",");
                this.ProjectorResolution = new PVector(int(coord[0]), int(coord[1]));
                break;
              case "Fears":
                String[] fears = keyValue[1].split(";");
                for (String w : fears) {
                  this.Fears.add(w);
                }
                break;
              case "FearsColors":
                String[] fearsColors = splitTokens(keyValue[1], "|");
                for (String colorRGB : fearsColors) {
                  String[] fearColorComps = splitTokens(colorRGB, ";");
                  this.FearsColors.add(color(int(fearColorComps[0]), int(fearColorComps[1]), int(fearColorComps[2])));
                }
                break;
              case "Strengths":
                String[] strengths = keyValue[1].split(";");
                for (String w : strengths) {
                  this.Strengths.add(w);
                }
                break;
              case "StrengthsColors":
                String[] strengthsColors = splitTokens(keyValue[1], "|");
                for (String colorRGB : strengthsColors) {
                  String[] strengthColorComps = splitTokens(colorRGB, ";");
                  this.StrengthsColors.add(color(int(strengthColorComps[0]), int(strengthColorComps[1]), int(strengthColorComps[2])));
                }
                break;
              case "FontName":
                this.FontName = keyValue[1];
                break;
              case "FontSize":
                this.FontSize = int(keyValue[1]);
                break;
              case "DisalignConversionFactor":
                this.DisalignConversionFactor = float(keyValue[1]);
                break;
              case "DisalignIntervalMs":
                this.DisalignIntervalMs = int(keyValue[1]);
                break;
              case "BackgroundColor":
                String[] backgroundColorComps = keyValue[1].split(";");
                this.BackgroundColor = color(int(backgroundColorComps[0]), int(backgroundColorComps[1]), int(backgroundColorComps[2]));
                break;
              case "LocationType":
                this.LocationType = keyValue[1];
                break;
            }
          }
        }
        break;
      }
    }
  }
}