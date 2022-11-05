class Blob {
  float radius;
  float pressure;
  public PVector loc;
  color blob_col;
  Blob() {
    radius = 49;
    pressure = 0;
    loc = new PVector(width/2, height/2);
    blob_col = color(0, 100, 100);
  }

  void show(float p, float r, Cap cap) {

    //convolution
    //pressure = pressure*0.95 + p*0.05;
    pressure = p;
    radius = radius*0.8 +r*0.2;

    pg_blob.beginDraw();
    pg_page.beginDraw();
    for (int i = 0; i < pressure; i++) {     

      pg_blob.fill(blob_col);
      pg_blob.noStroke();
      float rnd = random(1);
      //rnd = sqrt(rnd);//uniform distribution
      float rad = radius * pow(rnd, cap.spary_dist);
      float theta = 2 * PI * random(1);
      float s = random(cap.circle_size_min, cap.circle_size_max);

      pg_blob.circle(rad*cos(theta)+loc.x, rad*sin(theta)+loc.y, s);

      //pg_page
      pg_page.fill(blob_col);
      pg_page.noStroke();
      pg_page.circle(rad*cos(theta)+loc.x, rad*sin(theta)+loc.y, s);
    }
    pg_blob.endDraw();
    pg_page.endDraw();
  }

  void pointer() {
    pg_pointer.beginDraw();
    pg_pointer.clear();
    pg_pointer.background(251, 0);
    pg_pointer.fill(blob_col, 200);
    pg_pointer.noStroke();
    pg_pointer.circle(loc.x, loc.y, 10);
    pg_pointer.endDraw();
    noTint();
    image(pg_pointer, 0, 0);
  }

  void move(PVector vel) {
    loc.add(vel);
    loc.x = loc.x > width ? width: loc.x;
    loc.x = loc.x < 0 ? 0: loc.x;
    loc.y = loc.y > height ? height: loc.y;
    loc.y = loc.y < 0 ? 0: loc.y;
  }

  void set_color(color new_col) {
    blob_col = new_col;
  }
}
