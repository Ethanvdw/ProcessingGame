Flock regularFlock;
Flock playerControlledFlock;

final int BOIDS = 10;
final int PLAYER_BOIDS = 10;

void setup() {
    size(640, 360);

    regularFlock = new Flock();
    playerControlledFlock = new Flock();

    // Add regular boids
    for (int i = 0; i < BOIDS; i++) {
        regularFlock.addBoid(new Boid(width/2, height/2));
    }

    // Add player-controlled boid
    for (int i = 0; i < PLAYER_BOIDS; i++) {
        playerControlledFlock.addBoid(new PlayerControlledBoid(width/2, height/2));
    }
}

void draw() {
    background(50);
    regularFlock.run();
    playerControlledFlock.run();
}