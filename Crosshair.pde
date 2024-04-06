/**
 * The Crosshair class represents a crosshair object in a game.
 * It displays a crosshair image at the current mouse position.
 */
class Crosshair {
    PImage sprite;
    int x, y;
    
    /**
     * Constructs a new Crosshair object.
     * It loads the crosshair image, resizes it to 25x25 pixels, and hides the cursor.
     */
    Crosshair() {
        sprite = loadImage("crosshair.png");
        sprite.resize(25, 25);
        noCursor();
    }
    
    /**
     * Updates the position of the crosshair based on the current mouse position.
     * It displays the crosshair image at the updated position.
     */
    void update() {
        x = mouseX;
        y = mouseY;
        image(sprite, x, y);
    }
}