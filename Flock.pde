import java.util.ArrayList;
import java.util.List;

class Flock {
    private final List<Boid> boids;
    private final color flockColor;
    private final boolean isPlayerFlock;
    
    Flock(color flockColor, int numBoids, boolean isPlayerFlock) {
        boids = new ArrayList<>();
        this.flockColor = flockColor;
        this.isPlayerFlock = isPlayerFlock;
        initializeBoids(numBoids, isPlayerFlock);
    }
    
    void initializeBoids(int numBoids, boolean isPlayerControlled) {
        int boidX = width / 2;
        int boidY = height / 2;
        IntStream.range(0, numBoids).forEach(i -> {
            Boid boid = isPlayerControlled ? new PlayerControlledBoid(boidX, boidY, this) : new Boid(boidX, boidY, this);
            boids.add(boid);
        });
    }
    
    void run() {
        ArrayList<Boid> boidsArrayList = new ArrayList<>(boids);
        boids.forEach(boid -> boid.run(boidsArrayList));
    }
    
    void addBoid(Boid boid) {
        boids.add(boid);
    }
    
    List<Boid> getBoids() {
        return boids;
    }
    
    int getNumBoids() {
        return boids.size();
    }
    
    boolean isPlayerFlock() {
        return isPlayerFlock;
    }
}