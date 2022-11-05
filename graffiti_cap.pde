import processing.serial.*;    // Importing the serial library to communicate with the Arduino 
Serial myPort;      // Initializing a vairable named 'myPort' for serial communication
PGraphics pg_pointer;
PGraphics pg_blob;
PGraphics pg_page;
String val;
float x, y, b, fsr, sonar, arduino_color, light1, light2;
boolean finish_run = false;
boolean start_run = true;
ArrayList <Drip> driplist= new ArrayList<Drip>();
PImage [] pages = new PImage [4];
PImage [] walls; 
int counter_walls;
JSONArray walls_json;
float factor;
final float fastSpeed = 16;

Cap fat, skinny, needle, BLANK, current_cap;
Blob blob;

void setup() {
  //size(1200, 800);
  fullScreen(P2D, 2);
  //pg_blob - paint on screen, pg_pointer - pointer, pg_page - drawing on image in the end
  pg_blob = createGraphics(width, height);
  pg_pointer = createGraphics(width, height);
  pg_page = createGraphics(width, height);

  walls_json = loadJSONArray("walls_data.json");
  walls = new PImage [walls_json.size()];
  counter_walls = walls_json.size();
  for (int i = 0; i < 4; i++) {
    pages[i] = loadImage ("page"+i+".png");
    pages[i].resize(width, height);
  }



  //HSB: hue: 0-360, S: 0-100, B:0-100 
  colorMode(HSB, 360, 100, 100);

  ////////////RETURN
  myPort = new Serial(this, Serial.list()[5], 9600);
  myPort.bufferUntil('\n'); 
  ///////////


  ///////////////////////////////////DELETE
  //arduino_color = 0;
  //fsr = 6500;
  ////////////////////////////////////////

  blob = new Blob();

  // Cap(float _dist, float _rad, float _circ_min, float _circ_max, float _drip_size_min, float _drip_size_max, int _drip_span_min, int _drip_span_max)
  fat =    new Cap(0.8, 1.2, 0.2, 1.2, 15, 30, 200, 300,11);
  skinny = new Cap(0.6, 0.4, 0.6, 1, 2, 5, 100, 200,5);
  needle = new Cap(10, 1, 0.1, 1.6, 10, 40, 200, 400,8);
  BLANK = new Cap(0, 0, 0, 0, 0, 0, 0, 0,20);
  current_cap = fat;
}



void draw() {
  ////////////////////////////////////////////DELETE
  //float factor = 5;
  //x = map(mouseX, 0, width, -factor, factor);
  //y = map(mouseY, 0, height, -factor, factor);

  //sonar = 49;
  //////////////////////////////////////////////

  if (start_run) {
    func_start_run();
    ///////////////DELETE
    //check_key();
    /////////////////////
  } else if (finish_run) {
    func_finish_run();
  } else {
    //fsr, sonar

    check_cap();

    background(pg_blob);
    blob.pointer();
    blob.show(fsr, sonar*current_cap.radius, current_cap);
    blob.move(new PVector(x, y)); 

    ///////////////DELETE
    //check_key();
    /////////////////////
    set_color();
    //print("X: ", x, "Y: ", y, "B: ", b, "FSR: ", fsr, "SONAR: ", sonar);
    //println();

    if (frameCount % 150 == 0 && fsr > 1000) {
      //  Drip(int _x, int _y, int _size, color _col) 
      driplist.add(new Drip(blob.loc.x, blob.loc.y, random(current_cap.drip_size_min, current_cap.drip_size_max), blob.blob_col, current_cap.drip_span_min, current_cap.drip_span_max));
    }

    let_it_drip();

    if (b == 1) {
      finish_run = true;
    }
  }
}



void func_start_run() {
  int w = width/2;
  int h = height/2;
  background(251);
  tint(0, 0, 100, 180);
  image(pages[0], 0, 0, w, h);
  image(pages[1], w, 0, w, h);
  image(pages[2], 0, h, w, h);
  image(pages[3], w, h, w, h);
  strokeWeight(5);
  line(w, 0, w, height);
  line(0, h, width, h);
  noTint();
  if (blob.loc.x < w & blob.loc.y < h) {
    image(pages[0], 0, 0, w, h);
  } else if (blob.loc.x > w & blob.loc.y < h) {
    image(pages[1], w, 0, w, h);
  } else if (blob.loc.x < w & blob.loc.y > h) {
    image(pages[2], 0, h, w, h);
  } else {
    image(pages[3], w, h, w, h);
  }
  blob.pointer();
  blob.move(new PVector(x, y));
  if (b == 1) {
    set_page();
  }
}


void set_page() {
  PImage page;
  if (blob.loc.x < width/2 & blob.loc.y < height/2) {
    page = pages[0];
  } else if (blob.loc.x > width/2 & blob.loc.y < height/2) {
    page = pages[1];
  } else if (blob.loc.x < width/2 & blob.loc.y > height/2) {
    page = pages[2];
  } else {
    page = pages[3];
  }

  //set PGraphics
  pg_page.beginDraw();
  pg_page.endDraw();
  pg_blob.beginDraw();
  pg_blob.background(page);
  pg_blob.endDraw();
  pg_pointer.beginDraw();
  pg_pointer.background(page);
  pg_pointer.endDraw();
  start_run = false;
  delay(100);
}


void func_finish_run() {
  fsr = 0;
  if (counter_walls > 0) {
    save_images(walls_json.getJSONObject(counter_walls-1), counter_walls-1);
    counter_walls--;
  } else {
    //println("Done");
    background(walls[0]);
    beginShape(QUAD);
    texture(pg_page);
    noStroke();
    vertex(0, 0, 0, 0);
    vertex(width, 0, width, 0);
    vertex(width, height, width, height);
    vertex(0, height, 0, height);
    endShape();
    //noLoop();
  }
}


void check_cap() {
  if (light1 ==1 & light2 ==1) {
    current_cap = skinny;
  } else if (light1 ==1 & light2 ==0) {
    current_cap = fat;
  } else if (light1 ==0 & light2 == 1) {
    current_cap = needle;
  } else {
    current_cap =BLANK;
    fsr = 0;
  }
}


void set_color() {
  if (arduino_color < 10) {
    blob.set_color(color(arduino_color, 100, 0));
  } else if (arduino_color > 1010) {
    blob.set_color(color(0, 0, 100));
  } else if (color(arduino_color, 100, 100) != blob.blob_col) {
    arduino_color = (int)map(arduino_color, 10, 1010, 0, 340);
    blob.set_color(color(arduino_color, 100, 100));
  }

}

//return this!
void serialEvent( Serial myPort) 
{
  val = myPort.readStringUntil('\n');
  //print(val);
  if (val != null)
  {
    val = trim(val);
    //x,y,b,fsr,sonar,color, light1, light2;
    float[] vals = float(splitTokens(val, ","));
    //println("X: ", vals[0], "Y: ", vals[1], "B: ", vals[2], "FSR: ", vals[3], "SONAR: ", vals[4], "COLOR: ", vals[5], "L1: ", vals[6], "L2: ", vals[7]);

    factor = fsr < 1 ? fastSpeed : current_cap.factor_speed;
    map_val(vals, factor);
    
    //make the square a circle
    x = vals[0];
    y = abs(y) <  sqrt( factor*factor - x*x) ? y : (y < 0 ? -(sqrt( factor*factor - x*x)) : sqrt( factor*factor - x*x));
    x= x<0? -(pow(-x, 0.8)): pow(x, 0.8);
    x = -x;
    y = vals[1] ;
    y= y<0? -(pow(-y, 0.8)): pow(y, 0.8);
    y = -y;
    //
    b = vals[2];
    fsr = vals[3];
    sonar= vals[4];
    arduino_color = vals[5];
    light1 = vals[6];
    light2 = vals[7];
    //println("MAP X: ", x, "Y: ", y, "B: ", b, "FSR: ", fsr, "SONAR: ", sonar, "COLOR: ", arduino_color, "L1: ", light1, "L2: ", light2);
  }
}
void map_val(float [] val, float factor) {
  //x,y,b,fsr,sonar,color, light1, light2;
  val[0] = map(val[0], 0, 1023, -factor, factor);
  val[1] = map(val[1], 0, 1023, -factor, factor);
  val[3] = val[3] > 80 ? val[3] : 0;
  val[3] = map(val[3], 54, 167, 500, 9000);
  val[3] = val[3] > 500 ? val[3] : 0;
  val[4] = min(val[4], 60);
  val[4] = map(val[4], 0, 60, 1, width/20);
}

void let_it_drip() {
  for (int i = driplist.size()-1; i >= 0; i--) {
    Drip d = driplist.get(i);
    d.show();
    d.move();

    if (d.isDead()) {
      driplist.remove(d);
    }
  }
}

void clear_screen() {
  pg_blob.beginDraw();
  pg_blob.background(251);
  pg_blob.endDraw();
}

void save_images(JSONObject wall, int i) {
  walls[i] = loadImage(wall.getString("name"));
  walls[i].resize(width, height);
  background(walls[i]);
  float top_l_x = 0 + wall.getFloat("top_l_x")*width;
  float top_l_y = 0 + wall.getFloat("top_l_y")* height;
  float top_r_x = 0 + wall.getFloat("top_r_x")*width;
  float top_r_y = 0 + wall.getFloat("top_r_y")* height;
  float bot_l_x = 0 + wall.getFloat("bot_l_x")*width;
  float bot_l_y = 0 + wall.getFloat("bot_l_y")* height;
  float bot_r_x = 0 + wall.getFloat("bot_r_x")*width;
  float bot_r_y = 0 + wall.getFloat("bot_r_y")* height;

  beginShape(QUAD);
  texture(pg_page);
  noStroke();
  vertex(top_l_x, top_l_y, 0, 0);
  vertex(top_r_x, top_r_y, width, 0);
  vertex(bot_r_x, bot_r_y, width, height);
  vertex(bot_l_x, bot_l_y, 0, height);
  endShape();

  saveFrame("Out/out-"+day()+month()+year()+"######.png");
}

//////////////////////////////////////DELTE
//void check_key() {
/////////////////////////////////////////DELETE
//arduino_color = arduino_color%360;

/////////////////////////////////////////////
//  if (keyPressed) {
//    if (keyCode == UP) {
//      arduino_color++;
//    }
//    if (keyCode == DOWN) {
//      arduino_color --;
//    }
//    if (keyCode == LEFT) {
//      current_cap = skinny;
//      println("skinny");
//    }
//    if (keyCode == RIGHT) {
//      current_cap = fat;
//      println("fat");
//    }
//    if (keyCode == 'N') {
//      current_cap = needle;
//      println("needle");
//    }
//    if (keyCode == 'S') {
//      fsr = 0;
//      println("STOP");
//    }
//    if (keyCode == 'F') {
//      fsr = 1500;
//      println("FSR");
//    }
//    if (keyCode == 'R') {
//      if (start_run) {
//        println("RUN");
//        set_page();
//      }
//    }
//    if (keyCode == 'B') {
//      finish_run = true;
//      println("END");
//    }
//  }
//}
////////////////////////////////////////
