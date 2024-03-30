class PlayerControlledBoid extends Boid {
    PlayerControlledBoid(float x, float y, Flock flock) {
        super(x, y, flock);
    }
    
    @Override
    void run(ArrayList<Boid> boids) {
        PVector mousePosition = getMousePosition();
        PVector steeringForce = getSteeringForce(boids, mousePosition);
        applyForce(steeringForce); 
        updatePosition();
        wrapAroundBorders();
        render();
    }
    
    private PVector getMousePosition() {
        if (isMouseOnScreen()) {
            return new PVector(mouseX, mouseY);
        }
        return null;
    }
    
    private boolean isMouseOnScreen() {
        return mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height;
    }
    
    private PVector getSteeringForce(ArrayList<Boid> boids, PVector mousePosition) {
        PVector steeringForce = new PVector(0, 0);
        
        if (mousePosition != null) {
            steeringForce = seekTarget(mousePosition);
        } else {
            steeringForce = getFlockingForce(boids);
        }
        
        PVector separationForce = getSeparationForce(boids);
        separationForce.mult(1.5f);
        steeringForce.add(separationForce);
        
        return steeringForce;
    }
    
    private PVector getFlockingForce(ArrayList<Boid> boids) {
        PVector alignmentForce = getAlignmentForce(boids);
        PVector cohesionForce = getCohesionForce(boids);
        alignmentForce.mult(1.0f);
        cohesionForce.mult(1.0f);
        
        PVector flockingForce = new PVector();
        flockingForce.add(alignmentForce);
        flockingForce.add(cohesionForce);
        
        return flockingForce;
    }
}