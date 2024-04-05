import java.util.ArrayList;
import java.util.Arrays;
import java.util.Optional;

/**
* Represents a boid in a flocking simulation.
*/
class Boid {
    PImage boidImage;
    private PVector position;
    private PVector velocity;
    private PVector acceleration;
    private final float radius;
    private final float maxForce;
    private final float maxSpeed;
    private Flock flock;
    private color flockColor;
    
    /**
    * Constructs a new Boid object.
    *
    * @param x     The initial x-coordinate of the boid.
    * @param y     The initial y-coordinate of the boid.
    * @param flock The flock that the boid belongs to.
    */
    Boid(float x, float y, Flock flock) {
        acceleration = new PVector(0, 0);
        float angle = random(TWO_PI);
        velocity = new PVector(cos(angle), sin(angle));
        position = new PVector(x, y);
        radius = 4.0f;
        maxSpeed = 2.0f;
        maxForce = 0.03f;
        this.flock = flock;
        this.flockColor = flock.flockColor;
        boidImage = chooseRandomSprite("ships.png", 4, 4);	
    }
    
    /**
    * Runs the boid's behavior for each frame.
    *
    * @param boids The list of all boids in the simulation.
    */
    void run(ArrayList<Boid> boids) {
        applyFlockingBehaviors(boids);
        updatePosition();
        wrapAroundBorders();
        render();
    }
    
    /**
    * Applies a force to the boid.
    *
    * @param force The force to be applied.
    */
    protected void applyForce(PVector force) {
        acceleration.add(force);
    }
    
    /**
    * Updates the position of the boid based on its velocity and acceleration.
    */
    protected void updatePosition() {
        velocity.add(acceleration);
        velocity.limit(maxSpeed);
        position.add(velocity);
        acceleration.mult(0);
    }
    
    /**
    * Calculates and applies the flocking forces to the boid.
    *
    * @param boids The list of all boids in the simulation.
    */
    private void applyFlockingBehaviors(ArrayList<Boid> boids) {
        PVector separationForce = getSeparationForce(boids);
        PVector alignmentForce = getAlignmentForce(boids);
        PVector cohesionForce = getCohesionForce(boids);
        
        // Adjust the force magnitudes as needed
        separationForce.mult(1.5f);
        alignmentForce.mult(1.0f);
        cohesionForce.mult(1.0f);
        
        applyForce(separationForce);
        applyForce(alignmentForce);
        applyForce(cohesionForce);
    }
    
    /**
    * Calculates the separation force to avoid crowding with other boids.
    *
    * @param boids The list of all boids in the simulation.
    * @return The separation force.
    */
    protected PVector getSeparationForce(ArrayList<Boid> boids) {
        float desiredSeparation = 25.0f;
        PVector steer = new PVector(0, 0);
        int count = 0;
        
        for (Boid other : boids) {
            float distance = PVector.dist(position, other.position);
            if (distance > 0 && distance < desiredSeparation) {
                PVector diff = PVector.sub(position, other.position);
                diff.normalize();
                diff.div(distance);
                steer.add(diff);
                count++;
            }
        }
        
        if (count > 0) {
            steer.div(count);
            steer.setMag(maxSpeed);
            steer.sub(velocity);
            steer.limit(maxForce);
        }
        
        return steer;
    }
    
    /**
    * Calculates the alignment force to match the velocity of nearby boids.
    *
    * @param boids The list of all boids in the simulation.
    * @return The alignment force.
    */
    protected PVector getAlignmentForce(ArrayList<Boid> boids) {
        float neighborDistance = 50.0f;
        PVector sum = new PVector(0, 0);
        int count = 0;
        
        for (Boid other : boids) {
            float distance = PVector.dist(position, other.position);
            if (distance > 0 && distance < neighborDistance) {
                sum.add(other.velocity);
                count++;
            }
        }
        
        if (count > 0) {
            sum.div(count);
            sum.setMag(maxSpeed);
            PVector steer = PVector.sub(sum, velocity);
            steer.limit(maxForce);
            return steer;
        } else {
            return new PVector(0, 0);
        }
    }
    
    /**
    * Calculates the cohesion force to move towards the center of nearby boids.
    *
    * @param boids The list of all boids in the simulation.
    * @return The cohesion force.
    */
    protected PVector getCohesionForce(ArrayList<Boid> boids) {
        float neighborDistance = 50.0f;
        PVector sum = new PVector(0, 0);
        int count = 0;
        
        for (Boid other : boids) {
            float distance = PVector.dist(position, other.position);
            if (distance > 0 && distance < neighborDistance) {
                sum.add(other.position);
                count++;
            }
        }
        
        if (count > 0) {
            sum.div(count);
            return seekTarget(sum);
        } else {
            return new PVector(0, 0);
        }
    }
    
    /**
    * Renders the boid on the screen.
    */
    // protected void render() {
    //     float theta = velocity.heading2D() + radians(90);
    //     fill(flockColor);
    //     stroke(255);
    //     pushMatrix();
    //     translate(position.x, position.y);
    //     rotate(theta);
    //     renderBoidShape();
    //     popMatrix();
    // }

    protected void render() {
        float theta = velocity.heading2D() + radians(90);
        float scaleValue = 0.5; // Change this value to scale the image
        imageMode(CENTER);
        tint(flockColor); // Apply the tint
        pushMatrix();
        translate(position.x, position.y);
        rotate(theta);
        scale(scaleValue);
        image(boidImage, 0, 0);
        popMatrix();
        noTint(); // Remove the tint for other drawings
    }
    
    /**
    * Renders the shape of the boid.
    */
    private void renderBoidShape() {
        beginShape();
        vertex(0, -radius * 2);
        bezierVertex( -radius, -radius, -radius * 2, radius, 0, radius * 2);
        bezierVertex(radius * 2, radius, radius, -radius, 0, -radius * 2);
        endShape(CLOSE);
    }
    
    /**
    * Wraps the boid around the borders of the screen.
    */
    protected void wrapAroundBorders() {
        if (position.x < - radius || position.x > width + radius) {
            position.x = (position.x + width) % width;
        }
        if (position.y < - radius || position.y > height + radius) {
            position.y = (position.y + height) % height;
        }
    }
    
    /**
    * Calculates the steering force to seek a target position.
    *
    * @param target The target position to seek.
    * @return The steering force.
    */
    protected PVector seekTarget(PVector target) {
        PVector desired = PVector.sub(target, position);
        desired.normalize();
        desired.mult(maxSpeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxForce);
        return steer;
    }
    
    /**
    * Checks for collision with other flocks and handles the collision behavior.
    *
    * @param flocks The array of all flocks in the simulation.
    */
        protected void checkFlockCollision(Flock[] flocks) {
            Flock currentFlock = this.flock;

            // Filters to find the first boid that is:
            // 1. In a different flock
            // 2. Within a certain distance
            // 3. In a flock with more boids
            Optional<Flock> otherFlockOpt = Arrays.stream(flocks)
                .filter(otherFlock -> otherFlock != currentFlock)
                .filter(otherFlock -> {
                    return otherFlock.getBoids().stream().anyMatch(otherBoid -> {
                        float distance = PVector.dist(position, otherBoid.position);
                        return distance < 5.0f; // Adjust this value as needed
                    });
                })
                .filter(otherFlock -> currentFlock.getNumBoids() < otherFlock.getNumBoids())
                .findFirst();

            if (otherFlockOpt.isPresent()) {
                Flock otherFlock = otherFlockOpt.get();
                currentFlock.getBoids().remove(this);
                otherFlock.addBoid((otherFlock == flocks[0]) ? new PlayerControlledBoid(position.x, position.y, flocks[0]) : new Boid(position.x, position.y, otherFlock));

                this.flock = otherFlock;
                this.flockColor = otherFlock.flockColor;
            }
        }

    }