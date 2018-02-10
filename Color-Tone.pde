import processing.sound.*;

SoundFile[] notes = new SoundFile[27];
PImage img, src;
color[] pixelTemp;
int[] playback = new int[27];
int playbackIndx, insIndx;
int tempo, speed, span;
String[] fileTypes = {".png", ".jpg", ".jpeg"};
String[] instruments = {"Piano ", "Acoustic ", "Electric "};

/*-------------------------------------------------
Welcome to Color Tone: A Visual to Audio Generator.
To watch your own images come alive, load the name
of your image in the setup() function where asked to.
Happy listening!

Note: Requires Processing Sound Library to Operate.
---------------------------------------------------
*/



void setup() {
  
  String str = "color tone";  //load the name of your image here.
  
  for(int i = 0; i < fileTypes.length; i++)
    if(loadImage(str + fileTypes[i]) != null) {
      img = loadImage(str + fileTypes[i]);
      src = loadImage(str + fileTypes[i]);
    }
  float wth = img.width;
  float hgt = img.height;
  if(wth > 750) {
    wth = 750;
    hgt = (wth/img.width)*hgt;
  }
  else if(wth < 400) {
    wth = 400;
    hgt = (wth/img.width)*hgt;
  }
  
  surface.setSize(int(wth),int(hgt));
  img.resize(int(wth),int(hgt));
  src.resize(int(wth),int(hgt));
  background(0);
  tempo = 0;
  speed = 150;
  span = 10;
  playbackIndx = 0;
  img.loadPixels(); 
  pixelTemp = new color[img.pixels.length];
  int pixelSumRed = 0;
  int pixelSumGreen = 0;
  int pixelSumBlue = 0;
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      int loc = x + y*width;
      if(loc > img.width*img.height-1)
        loc = img.width*img.height-1;
      float r = red(img.pixels[loc]);
      float g = green(img.pixels[loc]);
      float b = blue(img.pixels[loc]);
      pixelSumRed += r;
      pixelSumBlue += g;
      pixelSumGreen += b;
      img.pixels[loc] =  color(100*int(r/100), 100*int(g/100), 100*int(b/100)); 
    }
  }
  if(max(pixelSumRed, pixelSumBlue, pixelSumGreen) == pixelSumRed)
    insIndx = 1;
  else if(max(pixelSumRed, pixelSumBlue, pixelSumGreen) == pixelSumGreen)
    insIndx = 2;
  else
    insIndx = 0;
  for(int i = 1; i < 10; i++)
    notes[i] = new SoundFile(this,instruments[insIndx] + "0" + str(i) + ".mp3");
  for(int i = 10; i < 14; i++)
    notes[i] = new SoundFile(this,instruments[insIndx] + str(i) + ".mp3");
  for(int i = 0; i < playback.length; i++)
    playback[i] = -1;
  img.updatePixels();
  arrayCopy(img.pixels, pixelTemp);
}



void draw() {
  image(src,0,0);
  image(img,0,0);
  arrayCopy(pixelTemp, img.pixels);
  for(int a = 0; a < height; a+=height/10) {
    int loc = tempo + a*width;
    if(loc > width*height-1)
      loc = width*height-1;
      
    color cur = img.pixels[loc];
    int col = int(red(pixelTemp[loc])) + int(green(pixelTemp[loc]))/10 + int(blue(pixelTemp[loc]))/100;
    if(frameCount%span == 0) {
      boolean repeat = true;
      for(int i = 0; i < playback.length; i++)
        if(col == playback[i])
          repeat = false;
      if(repeat) {
        playback[playbackIndx%27] = col;
        playbackIndx++;
      }
    }
    
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        int loc2 = x + y*width;
        
        if(red(cur) == red(img.pixels[loc2]) && blue(cur) == blue(img.pixels[loc2]) && green(cur) == green(img.pixels[loc2]))
          img.pixels[loc2] =  color(red(img.pixels[loc2])+20, green(img.pixels[loc2])+20, blue(img.pixels[loc2])+20);
      }
    }
  }
  img.updatePixels();
  stroke(255,0,0);
  
  image(src, 0, 0);
  tint(255,10);
  image(img, 0, 0);
  
  line(tempo,0,tempo,height);
  noStroke();
  tempo+=width/speed;
  if(tempo > width) {
    tempo = 0;
    frameCount = 0;
  }
  if(frameCount%span == 0)
    play_sounds();
  for(int i = 0; i < playback.length; i++)
    playback[i] = -1;
}

void play_sounds() {
  for(int i = 0; i < playback.length; i++) {
      switch (playback[i]) {
        case 0:
          notes[1].play();
          break;
        case 1:
          notes[2].play();
          break;
        case 2:
          notes[12].play();
          break;
        case 10:
          notes[2].play();
          break;
        case 11:
          notes[3].play();
          break;
        case 12:
          notes[6].play();
          break;
        case 20:
          notes[12].play();
          break;
        case 21:
          notes[7].play();
          break;
        case 22:
          notes[11].play();
          break;
        case 100:
          notes[2].play();
          break;
        case 101:
          notes[3].play();
          break;
        case 102:
          notes[6].play();
          break;
        case 110:
          notes[3].play();
          break;
        case 111:
          notes[4].play();
          break;
        case 112:
          notes[9].play();
          break;
        case 120:
          notes[5].play();
          break;
        case 121:
          notes[9].play();
          break;
        case 122:
          notes[10].play();
          break;
        case 200:
          notes[12].play();
          break;
        case 201:
          notes[7].play();
          break;
        case 202:
          notes[11].play();
          break;
        case 210:
          notes[5].play();
          break;
        case 211:
          notes[8].play();
          break;
        case 212:
          notes[10].play();
          break;
        case 220:
          notes[11].play();
          break;
        case 221:
          notes[10].play();
          break;
        case 222:
          notes[13].play();
          break;
        default:
          break;
      }
  }
}
