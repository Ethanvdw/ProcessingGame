class Boid {
    private PVector position;
    protected PVector velocity;
    protected PVector acceleration;
    private final float radius;
    private final float maxForce;
    private final float maxSpeed;
    Flock flock;
    private color flockColor;
    
    
    Boid(float x, float y, Flock flock) {
        acceleration = new PVector(0, 0);
        float angle = random(TWO_PI);
        velocity = new PVector(cos(angle), sin(angle));
        position = new PVector(x, y);
        radius = 2.0f;
        maxSpeed = 2.0f;
        maxForce = 0.03f;
        this.flock = flock;
        this.flockColor = flock.flockColor;
    }
    
    void run(ArrayList<Boid> boids) {
        flock(boids);
        
        updatePosition();
        wrapAroundBorders();
        render();
    }
    
    protected void applyForce(PVector force) {
        acceleration.add(force);
    }
    
    private void flock(ArrayList<Boid> boids) {
        PVector separationForce = getSeparationForce(boids);
        PVector alignmentForce = getAlignmentForce(boids);
        PVector cohesionForce = getCohesionForce(boids);
        
        separationForce.mult(1.5f);
        alignmentForce.mult(1.0f);
        cohesionForce.mult(1.0f);
        
        applyForce(separationForce);
        applyForce(alignmentForce);
        applyForce(cohesionForce);
    }
    
    protected void updatePosition() {
        velocity.add(acceleration);
        velocity.limit(maxSpeed);
        position.add(velocity);
        acceleration.mult(0);
    }
    
    protected PVector seekTarget(PVector target) {
        PVector desired = PVector.sub(target, position);
        desired.normalize();
        desired.mult(maxSpeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxForce);
        return steer;
    }
    
    protected void render() {
        float theta = velocity.heading2D() + radians(90);
        fill(flockColor);
        stroke(255);
        pushMatrix();
        translate(position.x, position.y);
        rotate(theta);
        renderBoidShape();
        popMatrix();
    }
    
    private void renderBoidShape() {
        beginShape(TRIANGLES);
        vertex(0, -radius * 2);
        vertex( -radius, radius * 2);
        vertex(radius, radius * 2);
        endShape();
    }
    
    protected void wrapAroundBorders() {
        if (position.x < - radius) position.x = width + radius;
        if (position.y < - radius) position.y = height + radius;
        if (position.x > width + radius) position.x = -radius;
        if (position.y > height + radius) position.y = -radius;
    }
    
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
    
    protected void checkFlockCollision(Flock[] flocks) {
        Flock currentFlock = this.flock;
        Flock playerFlock = flocks[0]; // The player's flock is the first flock (index 0)
        
        // Skip collision check if the boid belongs to the player's flock
        if (currentFlock == playerFlock) {
            return;
        }
        
        PVector playerFlockCenter = getLargestFlockCenter(playerFlock);
        float distance = PVector.dist(position, playerFlockCenter);
        float collisionThreshold = 50.0f; // Adjust this value as needed
        
        if (distance < collisionThreshold) {
            currentFlock.getBoids().remove(this);
            
            // If the boid is joining the player's flock, create a PlayerControlledBoid instance
            if (playerFlock == flocks[0]) {
                PlayerControlledBoid newBoid = new PlayerControlledBoid(position.x, position.y, playerFlock);
                newBoid.velocity = this.velocity;
                newBoid.acceleration = this.acceleration;
                playerFlock.addBoid(newBoid);
            } else {
                // If joining another flock, add the original Boid instance
                playerFlock.addBoid(this);
                this.flock = playerFlock;
                this.flockColor = playerFlock.flockColor;
            }
        }
    }
    
    private PVector getLargestFlockCenter(Flock flock) {
        PVector center = new PVector(0, 0);
        List<Boid> boids = flock.getBoids();
        for (Boid boid : boids) {
            center.add(boid.position);
        }
        center.div(boids.size());
        return center;
    }
}
