int sx = 1000;
int sy = 400;

float gx[][] = {{-1, 0, 1}, {-2, 0, 2}, {-1, 0, 1}};
float gy[][] = {{1, 2, 1}, {0, 0, 0}, {-1, -2, -1}};

PImage inputImage;
PImage outputImage;

float threshold = 200;

void setup() { 
  size(sx, sy);
  noLoop();

  inputImage = loadImage("picture3.jpg");
  outputImage = createImage(inputImage.width, inputImage.height, RGB);
}

void displayResults() {  
  int heightd = inputImage.height > sy ? inputImage.height - sy : 0;
  int widthd = inputImage.width > sx/2 ? inputImage.width - sx/2 : 0;
  
  if (heightd > widthd) {
    inputImage.resize(inputImage.width * (sy/inputImage.height), sy);
    outputImage.resize(inputImage.width * (sy/inputImage.height), sy);
  } else if (heightd < widthd) {
    inputImage.resize(sx/2, inputImage.height * ((sx/2)/inputImage.width));
    outputImage.resize(sx/2, inputImage.height * ((sx/2)/inputImage.width));
  }
  
  image(inputImage, 0, 0);
  image(outputImage, sx - outputImage.width, 0);
}

void draw() {
  inputImage.filter(GRAY);
  inputImage.loadPixels();
  outputImage.loadPixels();
     
  for (int i = 1; i < inputImage.height - 1; i++) {
    for (int j = 1; j < inputImage.width - 1; j++) {
      float sumx = 0;
      float sumy = 0;
      float magnitude = 0;
      
      for (int k = -1; k < 2; ++k) {
        for (int l = -1; l < 2; ++l) {
           int pindex = inputImage.width * (i + k) + j + l;
           float brightness = red(inputImage.pixels[pindex]);
           sumx += gx[l+1][k+1] * brightness;
           sumy += gy[l+1][k+1] * brightness;
        }
      }
      
      if (magnitude < 0) magnitude = 0;
      if (magnitude > 255) magnitude = 255;
      
      float brightness = 255 - sqrt(sumx*sumx + sumy*sumy);
      brightness = brightness < threshold ? 0 : 255;
      outputImage.pixels[i * inputImage.width + j] = color(brightness, brightness, brightness);
    }
  }
 
  outputImage.updatePixels();

  displayResults();
}

