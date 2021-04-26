import processing.serial.*;

Serial serial;
long  x = 0;
long  y = 0;
float  xr = 356;
float  yr = 356;
int points = 1;
int offset = 350;

void setup()
{
  size(712, 712);
  String port = Serial.list()[0];
  serial = new Serial(this, port, 115200);
}

void draw() {
  x = serial.read();
  y = serial.read();
  if (x != -1 && y != -1)
  {
    clear();
    background(200);
    line(100 + x * 2 - 10, 100 + y * 2, 100 + x * 2, 100 + y * 2);
    line(100 + x * 2 + 10, 100 + y * 2, 100 + x * 2, 100 + y * 2);
    line(100 + x * 2, 100 + y * 2 - 10, 100 + x * 2, 100 + y * 2);
    line(100 + x * 2, 100 + y * 2 + 10, 100 + x * 2, 100 + y * 2);
    rect(xr-150, yr-150, 300, 300);
    if (((100 + x * 2 < xr - 150) || (100 + x * 2 > xr + 150)) && key != ' ')
    {
      serial.write(255);
      points++;
    }
    else
      serial.write(0);
    if (((100 + y * 2 < yr - 150) || (100 + y * 2 > yr + 150)) && key != ' ')
    {
      serial.write(255);
      points++;
    }
    else
      serial.write(0);
  }
  if (key == ' ')
  {
    xr = random(712);
    yr = random(712);
  }
  println(points);
  delay(20);
}
