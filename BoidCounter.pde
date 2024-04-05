PFont customFont;

void setupCounter() {
    customFont = createFont("Kenney Space.ttf", 12);
}

void renderCounter(int value, float x, float y) {
    textFont(customFont);
    textAlign(LEFT, CENTER);
    fill(255);
    text(value, x, y);
}

void displayMessage(String message, float x, float y) {
    textFont(customFont);
    textAlign(CENTER, CENTER);
    fill(255);
    text(message, x, y);
}
