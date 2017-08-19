class Word {
  
  /*
    La ubicación de las palabras se va a hacer con una matriz posicional.
    Se pueden usar renglones como guìa.
    Tener en cuenta cantidad de palabras y largo de cada palabra para ubicarlas en el espacio x,y disponible.
    Alto de las palabras siempre igual.
  */
  
  public String Text;
  public PVector TopLeftPos;
  public PVector Size;
  public int FontSize;
  public String FontName;
  public ArrayList<Particles> ComponentParticles;
  public Boolean IsAligned = true;
  int AlignPercentage = 100;
  
  public Word(String wordText, String wordFontName, int wordFontSize) {
    this.Text = wordText;
    this.FontName = wordFontName;
    this.FontSize = wordFontSize;
  }
  
  public void createParticles() {
    // TO-DO: Create particles required for the word (invisible).
  }
  
  public void alignParticles() {
    // TO-DO: Align particles to show the word.
  }
  
  public void disalignParticles(int force, float conversionFactor) {
    // TO-DO: Disarm the word. Kill the particles when they are not visible anymore (probably should be inside Particle).
    // When completely disaligned: this.IsAligned = false;
  }
}