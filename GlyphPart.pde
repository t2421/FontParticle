class GlyphPart{
  ArrayList<Line> lines;
  GlyphPart(){
    lines = new ArrayList<Line>();
  }
  GlyphPart(ArrayList<Line> lines){
     this.lines = lines;
  }  
  GlyphPart clone(){
    return new GlyphPart(lines);
  }
  
  void clear(){
      lines = new ArrayList<Line>();
  }
  
  PVector[] updatePoint(){
     PVector[] points = new PVector[lines.size()];
      for (int i = 0 ; i < lines.size() ; i++){
        Line line = lines.get(i);
        points[i] = line.next();
      } 
      return points;
  }
  
   PVector[] updatePointRandom(){
     PVector[] points = new PVector[lines.size()];
      for (int i = 0 ; i < lines.size() ; i++){
        Line line = lines.get(i);
        points[i] = line.getRandom();
      } 
      return points;
  }
  
  void draw(){
     for (int i = 0 ; i < lines.size() ; i++){
      Line line = lines.get(i);
      line.draw();
    }
  }
}
