class Glyph{
   ArrayList<GlyphPart> glyphParts;
   PVector startPoint = new PVector(0,0);
  PVector endPoint = new PVector(0,0);
  PVector entryPoint = new PVector(0,0);
  Collection<FontPoint> glyphCollection;
  int drawCount = 1;
  int drawCountStep = 1;
  boolean isSeparete = true;
   Glyph(){
     glyphParts = new ArrayList<GlyphPart>();
   }
   
   void setup(Collection<FontPoint> fontPointCollection){
     GlyphPart gp = new GlyphPart();
       for (Iterator i = fontPointCollection.iterator(); i.hasNext();) {
      
      FontPoint pointInfo = (FontPoint) i.next();
      
      float[] points = pointInfo.points;
      
      
      if(pointInfo.lineType.equals("QUADTO")){
        QuadBezier line = new QuadBezier(pointInfo);
        line.startPoint = startPoint;
        //line.draw();
        gp.lines.add(line);
        startPoint = line.endPoint.get();
      }else if(pointInfo.lineType.equals("CUBICTO")){
        CubicBezier line = new CubicBezier(pointInfo);
        line.startPoint = startPoint;
        //line.draw();
        gp.lines.add(line);
        startPoint = line.endPoint.get();
      }else if(pointInfo.lineType.equals("LINETO")){
        StraitLine line = new StraitLine(pointInfo);
        line.startPoint = startPoint;
        //line.draw();
        gp.lines.add(line);
        startPoint = line.endPoint.get();
      }else if(pointInfo.lineType.equals("MOVETO")){
        MoveTo line = new MoveTo(pointInfo);
        startPoint.x = line.fp.points[0];
        startPoint.y = line.fp.points[1];
        entryPoint = startPoint.get();
        gp.lines.add(line);
      }else if(pointInfo.lineType.equals("CLOSETO")){
       
        StraitLine line = new StraitLine(pointInfo);
        line.startPoint = startPoint.get();
        line.endPoint = entryPoint.get();
        //line.draw();
        gp.lines.add(line);
        add(gp.clone());
        gp.clear();
        
      }
      
   }
   }
   
  void next(){
    if(drawCount>=glyphParts.size()){
      drawCountStep *= -1;
    }
    
    if(drawCount<=0){
      drawCountStep *= -1;
    }
    
    drawCount+=drawCountStep; 
  }
  
  PVector[][] updatePoint(){
    int max = min(drawCount,glyphParts.size());
     if(!isSeparete){
       max = glyphParts.size();
     }
      PVector[][] points = new PVector[max][];
      for (int i = 0 ; i < max ; i++){
        GlyphPart gp = glyphParts.get(i);
        points[i] = gp.updatePoint();
      } 
      return points;
      
  }
  
  PVector[][] updatePointRandom(){
    int max = min(drawCount,glyphParts.size());
     if(!isSeparete){
       max = glyphParts.size();
     }
      PVector[][] points = new PVector[max][];
      for (int i = 0 ; i < max ; i++){
        GlyphPart gp = glyphParts.get(i);
        points[i] = gp.updatePointRandom();
      } 
      return points;
      
  }
  
   
   void add(GlyphPart gp){
     glyphParts.add(gp);
   }
   void draw(float x,float y){
     translate(x,y);
     draw();
   }
   void draw(){
     int max = min(drawCount,glyphParts.size());
     if(!isSeparete){
       max = glyphParts.size();
     }
     for (int i = 0 ; i < max ; i++){
      GlyphPart gp = glyphParts.get(i);
      gp.draw();
    } 
   }
}
