class Spacecraft {
  public float x, y, dir;
  public void render() {
    quad((x + 20 * sin(dir)), (y - 20 * cos(dir)), 
        (x - 20 * sin(dir) + 10 * cos(dir)), (y + 20 * cos(dir) + 10 * sin(dir)),
        (x - 10 * sin(dir)), (y + 10 * cos(dir)), 
        (x - 20 * sin(dir) - 10 * cos(dir)), (y + 20 * cos(dir) - 10 * sin(dir)));
  }
}

void setup() {
  size(500, 500);
  background(0, 0, 0);
  stroke(255, 255, 255);
  strokeWeight(1);
  noFill();
}

void draw() {
  Spacecraft sc = new Spacecraft();
  sc.x = 250;
  sc.y = 250;
  sc.dir = 0;
  sc.render();
}
