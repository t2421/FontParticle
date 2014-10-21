import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;


import java.awt.Font;
import java.awt.GraphicsEnvironment;
import java.awt.font.*;
import java.awt.Graphics2D;
import java.awt.geom.*;
import java.awt.image.BufferedImage;
import java.awt.Shape;
import java.util.ArrayList;
import java.util.List;
import java.net.URLDecoder;

import com.google.gson.*;
import com.google.gson.annotations.*;
import com.google.gson.internal.*;
import com.google.gson.internal.bind.*;
import com.google.gson.reflect.*;
import com.google.gson.stream.*;

import java.io.*;

class GlyphToJson{
    Gson gson;
    ArrayList path;
    GlyphToJson(String str,int _fontSize){
      gson = new Gson();
      String outFont = str;
      String fontName = "Sans-serif";
      int dataType = 0;
      int fontSize = _fontSize;
      String[] splitedStr = outFont.split("");
      for (int i=0; i<splitedStr.length; i++) {
        System.out.println(splitedStr[i]);
        FontOutlineSystem fos;
        fos = new FontOutlineSystem(fontName,fontSize);
        path = fos.convert(splitedStr[i],0,0);
      }
      
      FontOutlineSystem fos;
      fos = new FontOutlineSystem(fontName,fontSize);
      path = fos.convert(outFont,0,0);
    }

    String getJson(){
      return gson.toJson(path);
    }
}

class FontPoint extends Object{
  String lineType;
  float[] points = new float[6];

  FontPoint(String lineType,float[] points){
    this.lineType = lineType;
    this.points = points;
  }
}

class Line{
  FontPoint fp;
  PVector endPoint;
  PVector startPoint;
  float t = 0;
  float tp = 1;
  float tStep = random(0.1)-0.05;
  Line(FontPoint fp){
    this.fp = fp;
    
  }
  
  void countUp(){
    t+=tStep;
    if(t>=1){
      t=1;
      tStep *= -1;
    }
    if(t<=0){
       t=0; 
       tStep *= -1;
    }
    tp = 1 - t;
  }
  
  void randomPoint(){
    t = random(1);
    tp = 1 - t;
  }
  
  PVector getRandom(){
    randomPoint();
    return new PVector();
  }
  PVector next(){
    countUp();
    return new PVector();
  }
  
  void draw(){
    
  }
}

class StraitLine extends Line{
  StraitLine(FontPoint fp){
    super(fp);
    endPoint = new PVector(fp.points[0],fp.points[1]);
    startPoint =  new PVector(0,0);
  }
  
  PVector next(){
    PVector vec = new PVector();
    countUp();
    vec.x = startPoint.x *tp+endPoint.x*t;
    vec.y = startPoint.y *tp+endPoint.y*t;
    return vec;
  }
  
  PVector getRandom(){
    
    PVector vec = new PVector();
    randomPoint();
    vec.x = startPoint.x *tp+endPoint.x*t;
    vec.y = startPoint.y *tp+endPoint.y*t;
    return vec;
  }
  
  void draw(){
     line(startPoint.x,startPoint.y,endPoint.x,endPoint.y); 
  }
}

class QuadBezier extends Line{
   QuadBezier(FontPoint fp){
    super(fp);
    endPoint = new PVector(fp.points[2],fp.points[3]);
    startPoint =  new PVector(0,0);
  }
  PVector next(){
    PVector vec = new PVector();
    countUp();
    vec.x = t*t*endPoint.x + 2*t*tp*fp.points[0] + tp*tp*startPoint.x;
    vec.y = t*t*endPoint.y + 2*t*tp*fp.points[1] + tp*tp*startPoint.y;
    return vec;
  }
  
  PVector getRandom(){
    
    PVector vec = new PVector();
    randomPoint();
    vec.x = t*t*endPoint.x + 2*t*tp*fp.points[0] + tp*tp*startPoint.x;
    vec.y = t*t*endPoint.y + 2*t*tp*fp.points[1] + tp*tp*startPoint.y;
    return vec;
  }
  void draw(){
     bezier(startPoint.x,startPoint.y,fp.points[0],fp.points[1],fp.points[2],fp.points[3],endPoint.x,endPoint.y); 
  } 
}

class CubicBezier extends Line{
   CubicBezier(FontPoint fp){
    super(fp);
    endPoint = new PVector(fp.points[4],fp.points[5]);
    startPoint =  new PVector(0,0);
  }
  PVector next(){
    PVector vec = new PVector();
    countUp();
    vec.x = t*t*t*endPoint.x + 3*t*t*tp*fp.points[2] + 3*t*tp*tp*fp.points[0] + tp*tp*tp*startPoint.x;
    vec.y = t*t*t*endPoint.y + 3*t*t*tp*fp.points[3] + 3*t*tp*tp*fp.points[1] + tp*tp*tp*startPoint.y;
    return vec;
  }
  PVector getRandom(){
    
    PVector vec = new PVector();
    randomPoint();
    vec.x = t*t*t*endPoint.x + 3*t*t*tp*fp.points[2] + 3*t*tp*tp*fp.points[0] + tp*tp*tp*startPoint.x;
    vec.y = t*t*t*endPoint.y + 3*t*t*tp*fp.points[3] + 3*t*tp*tp*fp.points[1] + tp*tp*tp*startPoint.y;
    return vec;
  }
  
  void draw(){
     bezier(startPoint.x,startPoint.y,fp.points[0],fp.points[1],fp.points[2],fp.points[3],endPoint.x,endPoint.y); 
  } 
}

class MoveTo extends Line{
   MoveTo(FontPoint fp){
    super(fp);
    //endPoint = new PVector(fp.points[4],fp.points[5]);
    //startPoint =  new PVector(0,0);
  }
  PVector next(){
    PVector vec = new PVector();
    countUp();
    vec.x = -9999;
    vec.y = -9999;
    return vec;
  }
  
  PVector getRandom(){
    
    PVector vec = new PVector();
    randomPoint();
     vec.x = -9999;
    vec.y = -9999;
    return vec;
  }
  void draw(){
    endPoint = new PVector(fp.points[0],fp.points[1]);
     //bezier(startPoint.x,startPoint.y,fp.points[0],fp.points[1],fp.points[2],fp.points[3],endPoint.x,endPoint.y); 
  } 
}

class FontOutlineSystem{
  Font font;
  BufferedImage img;
  Graphics2D g2d;
  FontRenderContext frc;

  FontOutlineSystem(){

  }

  FontOutlineSystem(String fontName, int fontSize){
    img = new BufferedImage(1,1,BufferedImage.TYPE_INT_ARGB);
    g2d = img.createGraphics();
    loadFont(fontName,fontSize);
  }

  void loadFont(String name, int size){
    font = new Font(name,Font.PLAIN,size);
    Font[] fonts = GraphicsEnvironment.getLocalGraphicsEnvironment().getAllFonts();
    for(int i = 0;i<fonts.length;i++){
      //System.out.println(fonts[i].getName());
      if(fonts[i].getName().equals(name)){
        font = fonts[i];
        font = font.deriveFont(Font.PLAIN,size);
      }
    }
  }
  ArrayList convert(String text, float xo, float yo){
    ArrayList al = new ArrayList<FontPoint>();
    if(font==null) return al;
    
    float [] seg = new float[6];
    float x=0, y=0, mx=0, my=0;
    
    frc = new FontRenderContext(new AffineTransform(),false,false);
    GlyphVector gv = font.createGlyphVector(frc, text);
    Shape glyph = gv.getOutline(xo, yo);
    PathIterator pi = glyph.getPathIterator(null);
    String lineType = "";
    
    
    while(!pi.isDone()){
      seg = new float[6];
      int segtype = pi.currentSegment(seg);
      int mode = 0;
      switch(segtype){
      
      
      case PathIterator.SEG_MOVETO:

        lineType = "MOVETO";
        break;
        
      case PathIterator.SEG_LINETO:

        lineType = "LINETO";
        
        break;
        
      case PathIterator.SEG_QUADTO:
        lineType = "QUADTO";
        
        break;
        
      case PathIterator.SEG_CUBICTO:
        lineType = "CUBICTO";
        
        break;
        
      case PathIterator.SEG_CLOSE:
        lineType = "CLOSETO";
        
        break;
      
      }
      al.add(new FontPoint(lineType,seg.clone()));
      pi.next();
    }
    Font [] fonts=GraphicsEnvironment.getLocalGraphicsEnvironment().getAllFonts();
    for(int i = 0;i<fonts.length;i++){
      //System.out.println(fonts[i]);
    }

    
    return al;
  }

}
