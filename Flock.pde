/**
 * The Flock class represents a group of boids.
 * A flock has a color, an image for the boids, and a flag indicating whether it is a player-controlled flock.
 * It maintains a list of boids and provides methods to initialize and manipulate the flock.
 */
import java.util.ArrayList;
import java.util.List;

class Flock {
    private final List<Boid> boids;
    private final color flockColor;
    private final PImage boidImage;
    private final boolean isPlayerFlock;
    
    /**
     * Constructs a new Flock object with the specified color, boid image, number of boids, and player-controlled flag.
     * Initializes the list of boids and adds the specified number of boids to the flock.
     * @param flockColor the color of the flock
     * @param boidImage the image for the boids
     * @param numBoids the number of boids to initialize in the flock
     * @param isPlayerFlock a flag indicating whether the flock is player-controlled
     */
    Flock(color flockColor, PImage boidImage ,int numBoids, boolean isPlayerFlock) {
        boids = new ArrayList<>();
        this.flockColor = flockColor;
        this.boidImage = boidImage;
        this.isPlayerFlock = isPlayerFlock;
        initializeBoids(numBoids, isPlayerFlock);
    }
    
    /**
     * Initializes the flock with the specified number of boids.
     * The boids are initially positioned at the center of the screen.
     * If the flock is player-controlled, it creates PlayerControlledBoid objects, otherwise it creates Boid objects.
     * @param numBoids the number of boids to initialize in the flock
     * @param isPlayerControlled a flag indicating whether the boids are player-controlled
     */
    void initializeBoids(int numBoids, boolean isPlayerControlled) {
        int boidX = width / 2;
        int boidY = height / 2;
        IntStream.range(0, numBoids).forEach(i -> {
            Boid boid = isPlayerControlled ? new PlayerControlledBoid(boidX, boidY, this) : new Boid(boidX, boidY, this);
            boids.add(boid);
        });
    }
    
    /**
     * Runs the flock by updating and rendering each boid in the flock.
     */
    void run() {
        ArrayList<Boid> boidsArrayList = new ArrayList<>(boids);
        boids.forEach(boid -> boid.run(boidsArrayList));
    }
    
    /**
     * Adds a boid to the flock.
     * @param boid the boid to add
     */
    void addBoid(Boid boid) {
        boids.add(boid);
    }
    
    /**
     * Returns the list of boids in the flock.
     * @return the list of boids
     */
    List<Boid> getBoids() {
        return boids;
    }
    
    /**
     * Returns the number of boids in the flock.
     * @return the number of boids
     */
    int getNumBoids() {
        return boids.size();
    }
    
    /**
     * Checks if the flock is player-controlled.
     * @return true if the flock is player-controlled, false otherwise
     */
    boolean isPlayerFlock() {
        return isPlayerFlock;
    }
}