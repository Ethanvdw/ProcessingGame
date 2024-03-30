import java.util.ArrayList;
import java.util.List;

class Flock {
    private final List<Boid> boids;
    private final color flockColor;

    Flock(color flockColor, int numBoids, boolean isPlayerControlled) {
        boids = new ArrayList<>();
        this.flockColor = flockColor;
        initializeBoids(numBoids, isPlayerControlled);
    }

    void initializeBoids(int numBoids, boolean isPlayerControlled) {
        for (int i = 0; i < numBoids; i++) {
            if (isPlayerControlled) {
                boids.add(new PlayerControlledBoid(width / 2, height / 2, this));
            } else {
                boids.add(new Boid(width / 2, height / 2, this));
            }
        }
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
}