PFont customFont;

/**
 * Initializes the Boid counter by loading the custom font.
 */
void setupCounter() {
    customFont = createFont("Kenney Space.ttf", 12);
}

/**
 * Renders the Boid counter with the specified value at the given position.
 * 
 * @param value The value to be displayed on the counter.
 * @param x The x-coordinate of the counter's position.
 * @param y The y-coordinate of the counter's position.
 */
void renderCounter(int value, float x, float y) {
    textFont(customFont);
    textAlign(LEFT, CENTER);
    fill(255);
    text(value, x, y);
}

/**
 * Displays a message on the screen at the specified position.
 * 
 * @param message The message to be displayed.
 * @param x The x-coordinate of the message's position.
 * @param y The y-coordinate of the message's position.
 */
void displayMessage(String message, float x, float y) {
    textFont(customFont);
    textAlign(CENTER, CENTER);
    fill(255);
    text(message, x, y);
}
