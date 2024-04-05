
/**
* Generates a random color.
* @return The randomly generated color.
*/
color generateRandomColor() {
    return color(random(255), random(255), random(255));
}


void cursorSetup() {
    noCursor();
}

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