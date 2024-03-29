PFont customFont;

void setupCounter() {
    customFont = createFont("Kenney Bold.ttf", 12);
}

void renderCounter(int value, float x, float y) {
    textFont(customFont);
    textAlign(LEFT, CENTER);
    fill(255);
    text(value, x, y);
}