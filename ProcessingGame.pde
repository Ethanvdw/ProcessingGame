import java.util.Arrays;
import java.util.stream.IntStream;
import java.util.stream.Collectors;

Flock[] flocks;
final int N_FLOCKS = 5;
final int BOIDS = 10;
int delayFrames = 180;

void setup() {
    frameRate(80);
    size(800, 800);
    surface.setTitle("Flock Off");
    setupCounter();
    initializeFlocks();
}

void initializeFlocks() {
    flocks = new Flock[N_FLOCKS];

    // Create the player's flock
    flocks[0] = new Flock(generateRandomColor(), BOIDS + 1, true);

    // Create the remaining flocks
    IntStream.range(1, N_FLOCKS)
             .forEach(i -> flocks[i] = new Flock(generateRandomColor(), BOIDS, false));

}

void draw() {
    background(50);
    Arrays.stream(flocks).forEach(Flock::run);

    if (frameCount >= delayFrames) {
        List<Boid> boidsToCheck = Arrays.stream(flocks)
                                        .flatMap(flock -> flock.getBoids().stream())
                                        .collect(Collectors.toList());
        boidsToCheck.forEach(boid -> boid.checkFlockCollision(flocks));
    }

    renderCounter(flocks[0].getNumBoids(), 20, height - 20);
    renderCounter(GetEnemyCount(flocks), width - 40, height - 20);
}

int GetEnemyCount(Flock[] flocks) {
    return Arrays.stream(flocks)
                 .filter(flock -> !flock.isPlayerFlock())
                 .mapToInt(Flock::getNumBoids)
                 .sum();
}