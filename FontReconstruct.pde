import java.lang.reflect.Type;
import com.google.gson.reflect.TypeToken;
import java.util.Collection;
import java.util.Iterator;
import java.util.Arrays;


GlyphToJson glyphJson;
SeparateGlyphCollection sg;
GlyphCollection gc;
Glyph glyph;
int bgColor = 0;
String outString ;
ArrayList<Glyph> glyphList = new ArrayList<Glyph>();
int numString;
boolean isZoom = false;
void setup(){
  blendMode(ADD);
  outString = "いつもお世話になっております。";
  
  sg = new SeparateGlyphCollection();
  sg.setup(outString);
  
  gc = new GlyphCollection();
  gc.setup(outString,80);
  
  
  size(displayWidth,displayHeight);
  if (frame != null) {
    frame.setResizable(true);
  }
  background(bgColor);
  noFill();
  strokeWeight(1);
  strokeJoin(ROUND);
  stroke(0);
  smooth();
  
  
  
}

void mouseClicked() {
  gc.next();
  //isZoom = !isZoom;
}

void draw(){
  
  fill(bgColor,bgColor,bgColor,255);
  noStroke();
  rect(0,0,width,height);
  //background(255);
  translate(width/2-(outString.length()*gc.fontSize/2),height/2+gc.fontSize/2);
  //sg.draw();
  //translate(20,200);
  if(isZoom){
    scale(2);
    
  }else{
    scale(1); 
  }
  
  
  
  gc.draw();
  
}
