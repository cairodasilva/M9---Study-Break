float hue;
boolean isPaused = false;

color currentColor;
int brushSize = 20;

float prevX, prevY;

void setup() {
  size(800, 800);
  colorMode(HSB, 360, 100, 100);
  currentColor = color(random(255), random(255), random(255));
}

void draw() {
  if (!isPaused) {
    loadPixels();
    float mouse = (mouseX * 10.0) / width;
    float w_factor = 16.0;         
    float h_factor = 16.0;         
    float dx = w_factor / width;    
    float dy = h_factor / height;   
    float x = -w_factor / 2;          
    for (int i = 0; i < width; i++) {
      float y = -h_factor / 2;        
      for (int j = 0; j < height; j++) {
        float r = sqrt((x * x) + (y * y));    
        float theta = atan2(y, x);         
        float brightness = sin(cos(mouse) * cos(mouse) + 9 * mouse * theta); 
        hue = mouseY % 360;
        pixels[i + j * width] = color((hue) % 360, 100, 100 - (brightness + 1) * 30);
        y += dy;              
      }
      x += dx;                  
    }
    updatePixels();
  } else {
    
    if (mousePressed && Moved()) {
      strokeWeight(brushSize);
      stroke(currentColor);
      line(prevX, prevY, mouseX, mouseY);
      line(width - prevX,  prevY, width-mouseX,  mouseY);
      prevX = mouseX;
      prevY = mouseY;
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    currentColor = color(random(255), random(255), random(255));
  }

  if (key == 'x' || key == 'X') {
    isPaused = !isPaused; // Toggle the pause state
    // Reset previous position when toggling pause
    if (!isPaused) {
      prevX = mouseX;
      prevY = mouseY;
    }
  }

  // Change brush size with arrow keys only when paused
  if (isPaused) {
    if (keyCode == UP) {
      brushSize += 5;
    } else if (keyCode == DOWN && brushSize > 5) {
      brushSize -= 5;
    }
  }
}

boolean Moved() {
  return pmouseX != mouseX || pmouseY != mouseY;
}

void mousePressed() {
  // Store the initial position when starting to draw
  prevX = mouseX;
  prevY = mouseY;
}
