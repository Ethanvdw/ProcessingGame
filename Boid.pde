
// Boid.pde

class Boid {
    protected PVector position;
    protected PVector velocity;
    private PVector acceleration;
    protected final float r;
    private final float maxForce;
    private final float maxSpeed;
    
    Boid(float x, float y) {
        acceleration = new PVector(0, 0);
        float angle = random(TWO_PI);
        velocity = new PVector(cos(angle), sin(angle));
        position = new PVector(x, y);
        r = 2.0;
        maxSpeed = 2;
        maxForce = 0.03;
    }
    
    void run(ArrayList<Boid> boids) {
        flock(boids);
        updatePosition();
        borders();
        render();
    }
    
    protected void applyForce(PVector force) {
        acceleration.add(force);
    }
    
    private void flock(ArrayList<Boid> boids) {
        PVector sep = separate(boids);
        PVector ali = align(boids);
        PVector coh = cohesion(boids);
        
        sep.mult(1.5);
        ali.mult(1.0);
        coh.mult(1.0);
        
        applyForce(sep);
        applyForce(ali);
        applyForce(coh);
    }
    
    protected void updatePosition() {
        velocity.add(acceleration);
        velocity.limit(maxSpeed);
        position.add(velocity);
        acceleration.mult(0);
    }
    
    protected PVector seek(PVector target) {
        PVector desired = PVector.sub(target, position);
        desired.normalize();
        desired.mult(maxSpeed);
        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxForce);
        return steer;
    }
    
    protected void render() {
        float theta = velocity.heading2D() + radians(90);
        fill(255, 0, 0);
        stroke(255);
        pushMatrix();
        translate(position.x, position.y);
        rotate(theta);
        beginShape(TRIANGLES);
        vertex(0, -r * 2);
        vertex( -r, r * 2);
        vertex(r, r * 2);
        endShape();
        popMatrix();
    }
    
    protected void borders() {
        if (position.x < - r) position.x = width + r;
        if (position.y < - r) position.y = height + r;
        if (position.x > width + r) position.x = -r;
        if (position.y > height + r) position.y = -r;
    }
    
    private PVector separate(ArrayList<Boid> boids) {
        float desiredSeparation = 25.0f;
        PVector steer = new PVector(0, 0, 0);
        int count = 0;
        
        for (Boid other : boids) {
            float d = PVector.dist(position, other.position);
            if (d > 0 && d < desiredSeparation) {
                PVector diff = PVector.sub(position, other.position);
                diff.normalize();
                diff.div(d);
                steer.add(diff);
                count++;
            }
        }
        
        if (count > 0) {
            steer.div((float) count);
            if (steer.mag() > 0) {
                steer.normalize();
                steer.mult(maxSpeed);
                steer.sub(velocity);
                steer.limit(maxForce);
            }
        }
        
        return steer;
    }
    
    private PVector align(ArrayList<Boid> boids) {
        float neighborDist = 50;
        PVector sum = new PVector(0, 0);
        int count = 0;
        
        for (Boid other : boids) {
            float d = PVector.dist(position, other.position);
            if (d > 0 && d < neighborDist) {
                sum.add(other.velocity);
                count++;
            }
        }
        
        if (count > 0) {
            sum.div((float) count);
            sum.normalize();
            sum.mult(maxSpeed);
            PVector steer = PVector.sub(sum, velocity);
            steer.limit(maxForce);
            return steer;
        } else {
            return new PVector(0, 0);
        }
    }
    
    private PVector cohesion(ArrayList<Boid> boids) {
        float neighborDist = 50;
        PVector sum = new PVector(0, 0);
        int count = 0;
        
        for (Boid other : boids) {
            float d = PVector.dist(position, other.position);
            if (d > 0 && d < neighborDist) {
                sum.add(other.position);
                count++;
            }
        }
        
        if (count > 0) {
            sum.div(count);
            return seek(sum);
        } else {
            return new PVector(0, 0);
        }
    }
}
