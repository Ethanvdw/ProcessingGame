import java.util.Arrays;
import java.util.stream.IntStream;

Flock[] flocks;

final int N_FLOCKS = 5; // Number of flocks including the player
final int BOIDS = 100;

void setup() {
    size(800, 800);
    surface.setTitle("Flock Off");
    setupCounter();

    flocks = IntStream.range(0, N_FLOCKS)
                      .mapToObj(i -> new Flock(generateRandomColor(), BOIDS, i == 0)) // Create flocks
                      .toArray(Flock[]::new);
}

void draw() {
    background(50);

    // Run all flocks
    Arrays.stream(flocks).forEach(Flock::run);

    renderCounter(flocks[0].boids.size(), 20, height - 20); // Player flock size

    // Sum of all other flocks
    int sum = Arrays.stream(flocks, 1, N_FLOCKS)
                    .mapToInt(flock -> flock.boids.size())
                    .sum();
    renderCounter(sum, width - 40, height - 20);
}

color generateRandomColor() {
    return color(random(255), random(255), random(255));
}