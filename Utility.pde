/**
 * Generates a random color.
 * 
 * @return The randomly generated color.
 */
color generateRandomColor() {
    return color(random(255), random(255), random(255));
}

/**
 * Sets up the cursor to be hidden.
 */
void cursorSetup() {
    noCursor();
}

/**
 * Chooses a random sprite from a sprite sheet.
 * 
 * @param filename The filename of the sprite sheet.
 * @param rows The number of rows in the sprite sheet.
 * @param cols The number of columns in the sprite sheet.
 * @return The randomly chosen sprite.
 */
PImage chooseRandomSprite(String filename, int rows, int cols) {
    PImage spriteSheet = loadImage(filename);
    int totalSprites = rows * cols;
    int spriteSize = spriteSheet.width / cols;
    int spriteIndex = int(random(0, totalSprites));
    int row = spriteIndex / cols;
    int col = spriteIndex % cols;
    PImage sprite = spriteSheet.get(col * spriteSize, row * spriteSize, spriteSize, spriteSize);
    return sprite;
}