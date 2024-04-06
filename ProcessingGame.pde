/**
 * This is the main file of the Processing game.
 * It contains the setup and draw functions, as well as other helper functions
 * for initializing flocks, spawners, handling collisions, rendering, and checking game status.
 */


import java.util.Arrays;
import java.util.ArrayList;
import java.util.stream.IntStream;
import java.util.stream.Collectors;
import java.util.Iterator;
import java.util.List;

Crosshair crosshair;

Flock[] flocks;
final int N_FLOCKS = 5;
final int BOIDS = 10;
final int SPAWNERS = 10;
int delayFrames = 180;

ArrayList<BoidSpawner> boidSpawners = new ArrayList<>();

/**
 * The setup function is called once when the program starts.
 * It initializes the game window, crosshair, counters, flocks, and spawners.
 */
void setup() {
    frameRate(80);
    size(800, 800);
    surface.setTitle("Flock Off");
    crosshair = new Crosshair(); 
    setupCounter();
    initializeFlocks();
    initializeSpawners();
}

/**
 * The draw function is called continuously in a loop.
 * It updates the crosshair, renders spawners, runs flocks, handles boid collisions,
 * handles boid spawner collisions, renders counters, and checks the game status.
 */
void draw() {
    background(0);
    crosshair.update();
    renderSpawners();
    runFlocks();
    handleBoidCollisions();
    handleBoidSpawnerCollisions();
    renderCounters();
    checkGameStatus();
}

/**
 * Renders all the spawners by calling the render function on each spawner.
 */
void renderSpawners() {
    Arrays.stream(boidSpawners.toArray())
       .forEach(spawner -> ((BoidSpawner) spawner).render());
}

/**
 * Initializes the spawners by creating a specified number of boid spawners
 * with random positions and a given sprite image.
 */
void initializeSpawners() {
    IntStream.range(0, SPAWNERS)
       .forEach(i -> boidSpawners.add(new BoidSpawner(random(width), random(height), "stars.png", 4, 1)));
}

/**
 * Handles collisions between boids and boid spawners.
 * For each flock, it checks if any boid collides with a spawner.
 * If a collision occurs, a new boid is spawned from the spawner and added to the flock.
 * The collided spawner is removed, and new spawners are created.
 */
void handleBoidSpawnerCollisions() {
    for (Flock flock : flocks) {
        List<Boid> boidsCopy = new ArrayList<>(flock.getBoids());
        List<BoidSpawner> spawnersToRemove = new ArrayList<>();
        List<BoidSpawner> newSpawners = new ArrayList<>(); // Create a temporary list to hold new spawners
        
        boidsCopy.forEach(boid -> {
            boidSpawners.stream()
               .filter(spawner -> spawner.checkCollision(boid))
               .forEach(spawner -> {
                Boid newBoid = spawner.spawnBoid(boid.position.x, boid.position.y, flock);
                flock.addBoid(newBoid);
                spawnersToRemove.add(spawner);
                newSpawners.add(createNewSpawner()); // Add new spawners to the temporary list
            });
        });
        
        boidSpawners.removeAll(spawnersToRemove);
        boidSpawners.addAll(newSpawners); // Add new spawners to boidSpawners after the loop
    }
}

/**
 * Creates a new boid spawner with a random position and a given sprite image.
 * @return The newly created boid spawner.
 */
BoidSpawner createNewSpawner() {
    return new BoidSpawner(random(width), random(height), "stars.png", 4, 1);
}

/**
 * Initializes the flocks by creating an array of flocks.
 * The first flock is the player flock, and the rest are enemy flocks.
 * Each flock is assigned a random color and a random sprite image.
 */
void initializeFlocks() {
    flocks = new Flock[N_FLOCKS];
    
    flocks[0] = new Flock(generateRandomColor(), chooseRandomSprite("ships.png", 4, 4), BOIDS, true);
    
    IntStream.range(1, N_FLOCKS)
       .forEach(i -> flocks[i] = new Flock(generateRandomColor(), chooseRandomSprite("ships.png", 4, 4), BOIDS, false));
}

/**
 * Runs the update and render functions for each flock in the flocks array.
 */
void runFlocks() {
    Flock[] flocksCopy = Arrays.copyOf(flocks, flocks.length);
    Arrays.stream(flocksCopy)
       .forEach(Flock ::  run);
}

/**
 * Handles collisions between boids within the flocks.
 * It checks for collisions only after a certain number of frames (delayFrames) have passed.
 * For each boid in the flocks, it checks for collisions with other boids in the flocks.
 */
void handleBoidCollisions() {
    if (frameCount >= delayFrames) {
        List<Boid> boidsToCheck = Arrays.stream(flocks)
           .flatMap(flock -> flock.getBoids().stream())
           .collect(Collectors.toList());
        
        boidsToCheck.forEach(boid -> boid.checkFlockCollision(flocks));
    }
}

/**
 * Renders the counters for the player flock's boids and the enemy flocks' boids.
 * The counters display the number of boids in each flock.
 */
void renderCounters() {
    renderCounter(flocks[0].getNumBoids(), 20, height - 20);
    renderCounter(getEnemyCount(flocks), width - 40, height - 20);
}

/**
 * Calculates and returns the total number of boids in the enemy flocks.
 * @param flocks The array of flocks.
 * @return The total number of boids in the enemy flocks.
 */
int getEnemyCount(Flock[] flocks) {
    return Arrays.stream(flocks)
       .filter(flock -> !flock.isPlayerFlock())
       .mapToInt(Flock ::  getNumBoids)
       .sum();
}

/**
 * Checks the game status by checking the number of boids in the player flock and the enemy flocks.
 * If the player flock has no boids, it displays a "You lose!" message.
 * If all enemy flocks have no boids, it displays a "You win!" message.
 */
void checkGameStatus() {
    if (flocks[0].getNumBoids() == 0) {
        displayMessage("You lose!", width / 2, height / 2);
    } else if (getEnemyCount(flocks) == 0) {
        displayMessage("You win!", width / 2, height / 2);
    }
}
