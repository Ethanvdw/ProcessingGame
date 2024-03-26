// Flock.pde

import java.util.ArrayList;
import java.util.List;

class Flock {
    private final List<Boid> boids;

    Flock() {
        boids = new ArrayList<>();
    }

    void run() {
        ArrayList<Boid> boidsArrayList = new ArrayList<>(boids);
        boids.forEach(boid -> boid.run(boidsArrayList));
    }

    void addBoid(Boid boid) {
        boids.add(boid);
    }
}
