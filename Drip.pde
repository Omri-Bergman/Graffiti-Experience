class Drip {
  float x, y, size;
  int lifespan;
  color col;
  float speed = random(0.9, 1.1);
  float shrink = random(0.99, 0.999);
  Drip(float _x, float _y, float _size, color _col, int _span_min, int _span_max) {
    x = _x;
    y = _y;
    size = _size;
    col = _col;
    lifespan = (int)random(_span_min, _span_max);
  }
  void show() {
    pg_blob.beginDraw();
    pg_blob.noStroke();
    pg_blob.fill(col, 30);
    pg_blob.circle(x, y, size);
    pg_blob.endDraw();
    
     pg_page.beginDraw();
    pg_page.noStroke();
    pg_page.fill(col, 30);
    pg_page.circle(x, y, size);
    pg_page.endDraw();
  }

  void move() {
    y+=speed;
    size *=shrink;
    lifespan -= 1;
  }

  boolean isDead() {return (lifespan <= 0); }
}
