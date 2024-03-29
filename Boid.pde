class Boid {
    private PVector position;
    private PVector velocity;
    private PVector acceleration;
    private final float radius;
    private final float maxForce;
    private final float maxSpeed;

    Boid(float x, float y) {
        acceleration = new PVector(0, 0);
        float angle = random(TWO_PI);
        velocity = new PVector(cos(angle), sin(angle));
        position = new PVector(x, y);
        radius = 2.0f;
        maxSpeed = 2.0f;
        maxForce = 0.03f;
    }

    void run(ArrayList<Boid> boids, color flockColor) {
        flock(boids);
        updatePosition();
        wrapAroundBorders();
        render(flockColor);
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

    protected void render(color flockColor) {
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
        vertex(-radius, radius * 2);
        vertex(radius, radius * 2);

        endShape();
    }

    protected void wrapAroundBorders() {
        if (position.x < -radius) position.x = width + radius;
        if (position.y < -radius) position.y = height + radius;
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
}