class BoidSpawner {
    private PVector position;
    private static final float SPAWNER_SIZE = 10; // Fixed size for all spawners
    
    BoidSpawner(float x, float y) {
        this.position = new PVector(x, y);
    }
    

        
        void render() {
            fill(255, 0, 0); // Red color for the spawner
            noStroke();
            ellipse(position.x, position.y, SPAWNER_SIZE, SPAWNER_SIZE);
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