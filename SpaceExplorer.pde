import java.util.Vector;

abstract class Component {
  public float x, y, dir;
  public boolean visible;
  public float collisionDist;
  public abstract void render();
}

class Spacecraft extends Component {
  public Spacecraft() {
    collisionDist = 20;
  }
  public void render() {
    strokeWeight(2);
    if (!visible) return;
    quad((x + 20 * sin(dir)), (y - 20 * cos(dir)), 
    (x - 20 * sin(dir) + 10 * cos(dir)), (y + 20 * cos(dir) + 10 * sin(dir)), 
    (x - 10 * sin(dir)), (y + 10 * cos(dir)), 
    (x - 20 * sin(dir) - 10 * cos(dir)), (y + 20 * cos(dir) - 10 * sin(dir)));
    strokeWeight(1);
  }
}

class Bullet extends Component {
  public Bullet() {
    collisionDist = 5;
  }
  public void render() {
    if (!visible) return;
    ellipse(x, y, 3, 3);
  }
}

class Asteroid extends Component {
  public Asteroid() {
    collisionDist = 50;
  }
  public float[] vx = new float[6];
  public float[] vy = new float[6];
  public void make() {
    for (int i = 0; i < 6; i++) {
      float tmp = random(50);
      vx[i] = tmp * sin(PI/3 * i);
      vy[i] = tmp * cos(PI/3 * i);
    }
  }
  public void render() {
    if (!visible) return;
    beginShape();
    for (int i = 0; i < 6; i++) {
      vertex(x + vx[i], y + vy[i]);
    }
    endShape(CLOSE);
  }
}

int gunHeat;
int turn;
boolean forward, reverse, fire;
Spacecraft sc = new Spacecraft();
ArrayList<Bullet> vBullet = new ArrayList<Bullet>();
ArrayList<Asteroid> vAst = new ArrayList<Asteroid>();

boolean collision(Component a, Component b) {
  if (dist(a.x, a.y, b.x, b.y) < a.collisionDist + b.collisionDist) {
    return true;
  } 
  else return false;
}


void setup() {
  size(1000, 1000);
  background(0, 0, 0);
  stroke(255, 255, 255);
  strokeWeight(1);
  noFill();
  sc.x = width / 2;
  sc.y = height / 2;
  sc.dir = 0;
  sc.visible = true;
  sc.render();
}

void draw() {
  background(0, 0, 0);
  if (turn == -1) {
    sc.dir -= radians(5);
  }
  else if (turn == 1) {
    sc.dir += radians(5);
  }
  if (forward) {
    sc.x += 7 * sin(sc.dir);
    sc.y -= 7 * cos(sc.dir);
  } 
  else if (reverse) {
    sc.x -= 2 * sin(sc.dir);
    sc.y += 2 * cos(sc.dir);
  }
  if (fire) {
    if (gunHeat == 0) {
      Bullet newb = new Bullet();
      newb.x = sc.x + 20 * sin(sc.dir);
      newb.y = sc.y - 20 * cos(sc.dir);
      newb.dir = sc.dir;
      newb.visible = true;
      vBullet.add(newb);
      gunHeat += 10;
    }
  }
  if (gunHeat > 0) {
    gunHeat--;
  }
  if (sc.x > width) {
    sc.x -= width;
  }
  if (sc.x < 0) {
    sc.x += width;
  }
  if (sc.y > height) {
    sc.y -= height;
  }
  if (sc.y < 0) {
    sc.y += height;
  }
  sc.render();
  for (int i = 0; i < vAst.size() - 1; i++) {
    for (int j = 0; j < vBullet.size() - 1; j++) {
      Bullet b = vBullet.get(j);
      Asteroid a = vAst.get(i);
      if (collision(b, a)) {
        vBullet.remove(j);
        vAst.remove(i);
      }
    }
  }
  for (int i = 0; i < vBullet.size(); i++) {
    Bullet b = vBullet.get(i);
    b.x += 8 * sin(b.dir);
    b.y -= 8 * cos(b.dir);
    if (b.x > width || b.y > height || b.x < 0 || b.y < 0) {
      vBullet.remove(i);
    }
    b.render();
  }
  int rand = int(random(20));
  if (rand == 5) {
    Asteroid ast = new Asteroid();
    int tmp = int(random(4));
    if (tmp == 1) {
      ast.x = 10;
      ast.y = random(height);
    }
    else if (tmp == 2) {
      ast.x = random(width);
      ast.y = 10;
    }
    else if (tmp == 3) {
      ast.x = width - 10;
      ast.y = random(height);
    }
    else if (tmp == 4) {
      ast.x = random(width);
      ast.y = height - 10;
    }
    ast.dir = random(TWO_PI);
    ast.make();
    ast.visible = true;
    vAst.add(ast);
  }
  for (int i = 0; i < vAst.size(); i++) {
    Asteroid b = vAst.get(i);
    b.x += 2 * sin(b.dir);
    b.y -= 2 * cos(b.dir);
    if (b.x > width || b.y > height || b.x < 0 || b.y < 0) {
      vAst.remove(i);
    }
    b.render();
  }

  println(vBullet.size() +  "      " + vAst.size());
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      turn = -1;
    }
    else if (keyCode == RIGHT) {
      turn = +1;
    }
    else if (keyCode == UP) {
      forward = true;
    }
    else if (keyCode == DOWN) {
      reverse = true;
    }
  } 
  else if (key == ' ') {
    fire = true;
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      turn = 0;
    }
    else if (keyCode == RIGHT) {
      turn = 0;
    }
    else if (keyCode == UP) {
      forward = false;
    }
    else if (keyCode == DOWN) {
      reverse = false;
    }
  } 
  else if (key == ' ') {
    fire = false;
  }
}

