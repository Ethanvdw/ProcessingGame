/**
 * The BoidSpawner class represents a spawner object that spawns boids in a game.
 */
class BoidSpawner {
    private PVector position;
    private static final float SPAWNER_SIZE = 25; // Fixed size for all spawners
    private PImage spriteSheet; // The sprite sheet
    private int spriteWidth, spriteHeight; // The size of each sprite in the sheet
    private int numFrames; // The number of frames in the sprite sheet
    private int currentFrame; // The current frame being displayed
    private static final int FRAME_DELAY = 14; // The number of draw calls to wait before changing frames
    private int frameCounter; // Counts the number of draw calls since the last frame change
    private int rows, cols; // The number of rows and columns in the sprite sheet

    /**
     * Constructs a new BoidSpawner object with the specified position, sprite sheet, and dimensions.
     * 
     * @param x                  The x-coordinate of the spawner's position.
     * @param y                  The y-coordinate of the spawner's position.
     * @param spriteSheetFilename The filename of the sprite sheet image.
     * @param rows               The number of rows in the sprite sheet.
     * @param cols               The number of columns in the sprite sheet.
     */
    BoidSpawner(float x, float y, String spriteSheetFilename, int rows, int cols) {
        this.position = new PVector(x, y);
        this.spriteSheet = loadImage(spriteSheetFilename);
        this.numFrames = rows * cols;
        this.rows = rows;
        this.cols = cols;
        this.spriteWidth = spriteSheet.width / cols;
        this.spriteHeight = spriteSheet.height / rows;
        this.currentFrame = 0;
        this.frameCounter = 0;
    }

    /**
     * Renders the spawner on the screen.
     */
    void render() {
        int row = currentFrame / cols;
        int col = currentFrame % cols;
        int spriteX = col * spriteWidth;
        int spriteY = row * spriteHeight;
        image(spriteSheet, position.x, position.y, SPAWNER_SIZE, SPAWNER_SIZE, spriteX, spriteY, spriteX + spriteWidth, spriteY + spriteHeight);
        frameCounter++;
        if (frameCounter >= FRAME_DELAY) {
            currentFrame = (currentFrame + 1) % numFrames; // Cycle to the next frame
            frameCounter = 0;
        }
    }

    /**
     * Checks if a collision has occurred between the spawner and a boid.
     * 
     * @param boid The boid to check for collision with.
     * @return True if a collision has occurred, false otherwise.
     */
    boolean checkCollision(Boid boid) {
        float distance = PVector.dist(position, boid.position);
        return distance < SPAWNER_SIZE / 2 + boid.radius;
    }

    /**
     * Spawns a new boid at the specified position and adds it to the given flock.
     * 
     * @param x     The x-coordinate of the boid's position.
     * @param y     The y-coordinate of the boid's position.
     * @param flock The flock to add the boid to.
     * @return The newly spawned boid.
     */
    Boid spawnBoid(float x, float y, Flock flock) {
        return new Boid(x, y, flock);
    }

    /**
     * Renders all the spawners in the game.
     */
    void renderSpawners() {
        Arrays.stream(boidSpawners.toArray())
            .forEach(spawner -> ((BoidSpawner) spawner).render());
    }
}
