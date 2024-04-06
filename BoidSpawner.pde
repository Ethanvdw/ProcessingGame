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



        
        boolean checkCollision(Boid boid) {
            float distance = PVector.dist(position, boid.position);
            return distance < SPAWNER_SIZE / 2 + boid.radius;
        }
        
        Boid spawnBoid(float x, float y, Flock flock) {
            return new Boid(x, y, flock);
        }
        
        void renderSpawners() {
            Arrays.stream(boidSpawners.toArray())
               .forEach(spawner -> ((BoidSpawner) spawner).render());
        }
    }