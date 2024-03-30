/**
 * The ProcessingGame class represents a game that simulates the behavior of multiple flocks of boids.
 * Each flock consists of a group of boids that exhibit flocking behavior.
 * The game window has a size of 800x800 pixels and is titled "Flock Off".
 * The game initializes with 5 flocks, each containing 100 boids.
 * The background color of the game window is set to a dark gray (RGB: 50, 50, 50).
 * The number of boids in the first flock is displayed in the top left corner of the window.
 * The total number of boids in all flocks, excluding the first flock, is displayed in the top right corner of the window.
 * The color of each flock is randomly generated.
 */
import java.util.Arrays;
import java.util.stream.IntStream;

Flock[] flocks;
final int N_FLOCKS = 5;
final int BOIDS = 10;

/**
 * Delay the collision detection for a certain number of frames.
 * Gives them time to spread out before they start colliding.
 **/
int delayFrames = 180;
int currentFrame = 0;

/**
 * The setup function is called once when the program starts.
 * It sets up the size of the canvas, the title of the window,
 * initializes the counter, and creates the flocks.
 **/
void setup() {
    frameRate(80);
    size(800, 800);
    surface.setTitle("Flock Off");
    setupCounter();
    flocks = IntStream.range(0, N_FLOCKS)
                      .mapToObj(i -> new Flock(generateRandomColor(), BOIDS, i == 0))
                      .toArray(Flock[]::new);


                          // Add an extra boid to the player's flock, for testing purposes
    Boid extraBoid = new PlayerControlledBoid(width / 2, height / 2, flocks[0]);
    flocks[0].addBoid(extraBoid);
}

/**
 * The draw function is called repeatedly in a loop.
 * It clears the background, runs the flock simulation,
 * and renders the counters for the number of boids in each flock.
 */
void draw() {
    background(50);
    Arrays.stream(flocks).forEach(Flock::run);

    if (currentFrame >= delayFrames) {
        for (Flock flock : flocks) {
            List<Boid> boidsSnapshot = new ArrayList<>(flock.getBoids());
            for (Boid boid : boidsSnapshot) {
                boid.checkFlockCollision(flocks);
            }
        }
    }

    renderCounter(flocks[0].getBoids().size(), 20, height - 20); // Player's flock
    int sum = Arrays.stream(flocks, 1, N_FLOCKS)
                    .mapToInt(flock -> flock.getBoids().size())
                    .sum();
    renderCounter(sum, width - 40, height - 20); // All other flocks

    println(frameRate);

    
    currentFrame++; // Increment the frame counter
}

/**
 * Generates a random color.
 * @return The randomly generated color.
 */
color generateRandomColor() {
    return color(random(255), random(255), random(255));
}