class GlyphCollection{
  GlyphToJson glyphJson;
  Glyph glyph;
  PVector[][] points;
  int fontSize;
  GlyphCollection(){
    
  }
  
  void setup(String str,int size){
    glyphJson = new GlyphToJson(str,size);
    fontSize = size;
    Gson gson = new Gson();
    Type collectionType = new TypeToken<Collection<FontPoint>>(){}.getType();
    Collection<FontPoint> glyphCollection = gson.fromJson(glyphJson.getJson().toString(),collectionType);
    glyph = new Glyph();
    glyph.setup(glyphCollection);
    
    //println(glyphJson.getJson().toString() );
    
    
    
  }
  
  void update(){
    points = glyph.updatePoint();
  }
  
  void next(){
    glyph.next();
    
  }
  
  void draw(){
    
    
    
    
    PVector[][] points;
    float randomSeed = map(mouseX,0,width,0,140);
    float randomSeedY = map(mouseY,0,height,0,height);
    float halfSeed = randomSeed/2;
    float halfSeedY = randomSeedY/2;
    float radius = 2;
    float countMax = 1;
    
    
    points = glyph.updatePointRandom();

    for(int count = 0;count<countMax;count++){
      for(int j = 0;j<points.length;j++){
         for(int k = 0;k<points[j].length;k++){
           strokeWeight(random(0.5)+0.5);
           //stroke(random(255),random(255),random(255),10);
           fill(random(255),random(255),random(255),0);
           //stroke(255);
           float x = points[j][k].x+random(randomSeed)-halfSeed;
           float y = points[j][k].y+random(randomSeedY)-halfSeedY;
           //triangle(x, y-2, x-2, y, x+2, y); 
           pushMatrix();
           translate(x,y);
           rotate(random(360));
           ellipse(0,0,random(radius),random(radius));
           
           translate(-x,-y);
           popMatrix();
         }
      }
    }
    
    //glyph.draw();
  }
}
