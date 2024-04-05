class Crosshair {
    PImage sprite;
    int x, y;
    
    Crosshair() {
        sprite = loadImage("crosshair.png");
        sprite.resize(25, 25);
        noCursor();
    }
    
    void update() {
        x = mouseX;
        y = mouseY;
    }
    
    void display() {
        image(sprite, x, y);
    }
}