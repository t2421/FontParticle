class SeparateGlyphCollection{
  GlyphToJson glyphJson;
  ArrayList<Glyph> glyphList = new ArrayList<Glyph>();
  int numString;
  
  SeparateGlyphCollection(){
    
  }
  
  void setup(String str){
    String outputStr = str;
    String[] outputStrArray;
    outputStrArray =  outputStr.split("");
    List<String> list = new ArrayList<String>(Arrays.asList(outputStrArray));
    list.remove(0);
    
    numString = list.size();
 
    glyphList = new ArrayList<Glyph>();
    for(int i = 0; i<numString;i++){
      Glyph glyph;
      
      glyphJson = new GlyphToJson(list.get(i).toString(),150);
      
      Gson gson = new Gson();
      Type collectionType = new TypeToken<Collection<FontPoint>>(){}.getType();
      Collection<FontPoint> glyphCollection = gson.fromJson(glyphJson.getJson().toString(),collectionType);
      glyph = new Glyph();
      //glyph.isSeparete = true;
      glyph.setup(glyphCollection);
      glyphList.add(glyph);
      
    }
    
    //println(glyphJson.getJson().toString() );
    
    
    
  }
  
  void draw(){
    PVector[][] points;
    for(int i = 0; i<numString;i++){
      Glyph glyph = glyphList.get(i);
      
      points = glyph.updatePoint();
      for(int j = 0;j<points.length;j++){
         for(int k = 0;k<points[j].length;k++){
            ellipse(points[j][k].x,points[j][k].y,1,1); 
         }
      }
      //glyph.draw(0,0);
      
    }
  }
}
