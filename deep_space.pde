Planet[] planets;
int numPlanets = 500;
int currentPlanet = 0;

//Gravitational Constant
float G = .03;

void setup(){
  size(500, 500);
  background(8, 126, 139);
  cursor(CROSS);
  planets = new Planet[numPlanets];
  for (int i = 0; i < planets.length; i++) {
    planets[i] = new Planet(color(0));
  }
}

void draw() {
  background(8, 126, 139);
  for (int i = 0; i < numPlanets; i++) {
    planets[i].display();
    planets[i].move();
    
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    double randX = Math.random() * 5 - 2.5;
    double randY = Math.random() * 5 - 2.5;
    float X = (float) randX;
    float Y = (float) randY;
    double rand = Math.random() * 6 + 3;
    float r = (float) rand;
    planets[currentPlanet].start(mouseX, mouseY, X, Y, r);
    currentPlanet++;
    if (currentPlanet >= numPlanets) {
      currentPlanet = 0;
    }
  } else if (mouseButton == RIGHT) {
    background(8, 126, 139);
    for (int i = 0; i < numPlanets; i++) {
      planets[i].on = false;
    }
  }
}

class Planet {
  float rad;
  float mass;
  float size;
  float xAcc;
  float yAcc;
  float xVel;
  float yVel;
  float xPos;
  float yPos;
  color c;
  boolean on = false;

  Planet (color newColor) {
    c = newColor;
  }
  
  void start(float newXPos, float newYPos, float newXVel, float newYVel, float newRad) {
    xVel = newXVel;
    yVel = newYVel;
    xPos = newXPos;
    yPos = newYPos;
    rad = newRad;
    mass = rad * rad;
    on = true;
  }
  
  void move() {
    if (on == true) {
      
      //Merges planets if need be
      for (int i = 0; i < numPlanets; i++) {
        if (planets[i].on == true && planets[i] != this) {
          if (abs(planets[i].xPos - xPos) < (rad + planets[i].rad - 7) && abs(planets[i].yPos - yPos) < (rad + planets[i].rad - 7)) {
            this.merge(mass, rad, xPos, yPos, xVel, yVel, i, planets[i].mass, planets[i].rad, planets[i].xPos, planets[i].yPos, planets[i].xVel, planets[i].yVel);
            //Bouncy walls (I put it up here because otherwise it won't happen to newly-mergeds
            if (xPos > width-rad || xPos < rad) {
              xVel *= -1;
            }
            if (yPos > height-rad || yPos < rad) {
              yVel *= -1;
            }
            break; //This is necessary. I don't know why.  Just leave it there and forget about this whole if loop.
          }
        }
      }
      
      xAcc = 0;
      yAcc = 0;
      float theta = 0;
      
      //Sends "gravitation particles"
      for (int i = 0; i < numPlanets; i++) {
        if (planets[i].on == true && planets[i] != this) {
          float xDist = planets[i].xPos - xPos;
          float yDist = planets[i].yPos - yPos;
          
          //Calculate the angle between them
          if (xDist == 0 && yDist > 0) { 
            double thta = Math.PI / 2;
            theta = (float) thta;
          } else if (xDist == 0 && yDist < 0) {
            double thta = 3 * Math.PI / 2;
            theta = (float) thta;
          } else if (xDist > 0) {
            theta = atan(yDist/xDist);
          } else if (xDist < 0) { 
            theta = atan(yDist/xDist) + (float) Math.PI;
          }
          
          //Calculate the distance between them
          float dist = sqrt((xDist * xDist) + (yDist * yDist));
          
          //Calculate the force between them
          float force = ((G * mass * planets[i].mass)/(dist));
          xAcc += (force * cos(theta))/mass;
          yAcc += (force * sin(theta))/mass;
          }
      }
      
      
      
      //Forces have effect now
      xVel += xAcc;
      yVel += yAcc;
      xPos += xVel;
      yPos += yVel;
      
      //Bouncy walls
      if (xPos > width-rad || xPos < rad) {
        xVel *= -1;
      }
      if (yPos > height-rad || yPos < rad) {
        yVel *= -1;
      }
      
      
    }
  }
  
  void display() {
    if (on == true) {
      stroke(c);
      fill(c);
      ellipse(xPos, yPos, 2 * rad, 2 * rad);
    }
  }
  
  void merge(float mass1, float rad1, float xPos1, float yPos1, float xVel1, float yVel1, int NUMPLANET2, float mass2, float rad2, float xPos2, float yPos2, float xVel2, float yVel2) {
    this.on = false;
    planets[NUMPLANET2].mass = mass1 + mass2;
    planets[NUMPLANET2].rad = sqrt(planets[NUMPLANET2].mass);
    planets[NUMPLANET2].xVel = (mass1 * xVel1 + mass2 * xVel2)/(mass1 + mass2);
    planets[NUMPLANET2].yVel = (mass1 * yVel1 + mass2 * yVel2)/(mass1 + mass2);

      planets[NUMPLANET2].xPos += ( ((mass1 * xPos1 + mass2 * xPos2)/(mass1 + mass2)) - xPos2 );
      planets[NUMPLANET2].yPos += ( ((mass1 * yPos1 + mass2 * yPos2)/(mass1 + mass2)) - yPos2 );
    
  }
}