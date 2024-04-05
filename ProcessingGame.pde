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

void setup() {
    frameRate(80);
    size(800, 800);
    surface.setTitle("Flock Off");
    crosshair = new Crosshair(); 
    setupCounter();
    initializeFlocks();
    initializeSpawners();
}


void draw() {
    background(50);
    crosshair.update(); // Update the crosshair's position
    crosshair.display(); // Display the crosshair
    renderSpawners();
    runFlocks();
    handleBoidCollisions();
    handleBoidSpawnerCollisions();
    renderCounters();
    checkGameStatus();
}

void renderSpawners() {
    Arrays.stream(boidSpawners.toArray())
       .forEach(spawner -> ((BoidSpawner) spawner).render());
}

void initializeSpawners() {
    IntStream.range(0, SPAWNERS)
       .forEach(i -> boidSpawners.add(new BoidSpawner(random(width), random(height))));
}

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

BoidSpawner createNewSpawner() {
    return new BoidSpawner(random(width), random(height));
}

void initializeFlocks() {
    flocks = new Flock[N_FLOCKS];
    
    flocks[0] = new Flock(generateRandomColor(), BOIDS, true);
    
    IntStream.range(1, N_FLOCKS)
       .forEach(i -> flocks[i] = new Flock(generateRandomColor(), BOIDS, false));
}

void runFlocks() {
    Flock[] flocksCopy = Arrays.copyOf(flocks, flocks.length);
    Arrays.stream(flocksCopy)
       .forEach(Flock ::  run);
}

void handleBoidCollisions() {
    if (frameCount >= delayFrames) {
        List<Boid> boidsToCheck = Arrays.stream(flocks)
           .flatMap(flock -> flock.getBoids().stream())
           .collect(Collectors.toList());
        
        boidsToCheck.forEach(boid -> boid.checkFlockCollision(flocks));
    }
}

void renderCounters() {
    renderCounter(flocks[0].getNumBoids(), 20, height - 20);
    renderCounter(getEnemyCount(flocks), width - 40, height - 20);
}

int getEnemyCount(Flock[] flocks) {
    return Arrays.stream(flocks)
       .filter(flock -> !flock.isPlayerFlock())
       .mapToInt(Flock ::  getNumBoids)
       .sum();
}

void checkGameStatus() {
    if (flocks[0].getNumBoids() == 0) {
        displayMessage("You lose!", width / 2, height / 2);
    } else if (getEnemyCount(flocks) == 0) {
        displayMessage("You win!", width / 2, height / 2);
    }
}
