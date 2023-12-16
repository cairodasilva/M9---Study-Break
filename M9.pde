float hue;
boolean isPaused = false;

color currentColor;
int brushSize = 20;

float prevX, prevY;

void setup() {
  size(640, 360);
  colorMode(HSB, 360, 100, 100);
  currentColor = color(random(255), random(255), random(255));
}

void draw() {
  if (!isPaused) {
    loadPixels();

    float n = (mouseX * 10.0) / width;
    float w = 16.0;         // 2D space width
    float h = 16.0;         // 2D space height
    float dx = w / width;    // Increment x this amount per pixel
    float dy = h / height;   // Increment y this amount per pixel
    float x = -w / 2;          // Start x at -1 * width / 2
    for (int i = 0; i < width; i++) {
      float y = -h / 2;        // Start y at -1 * height / 2
      for (int j = 0; j < height; j++) {
        float r = sqrt((x * x) + (y * y));    // Convert cartesian to polar
        float theta = atan2(y, x);         // Convert cartesian to polar
        // Compute 2D polar coordinate function
        float val = sin(cos(n) * cos(n) + 5 * n * theta); // Results in a value between -1 and 1
        hue = mouseY % 360;
        // Map resulting value to grayscale value
        pixels[i + j * width] = color((hue) % 360, 100, 100 - (val + 1) * 30);
        // Scale to between 0 and 255
        y += dy;                // Increment y
      }
      x += dx;                  // Increment x
    }
    updatePixels();
  } else {
    // Only draw when the mouse is being dragged
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
