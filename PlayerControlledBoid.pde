/**
 * The PlayerControlledBoid class represents a boid that is controlled by the player.
 * It extends the Boid class and overrides the run method to implement player-controlled behavior.
 */
class PlayerControlledBoid extends Boid {
    
    /**
     * Constructs a new PlayerControlledBoid object with the specified position and flock.
     * 
     * @param x     The x-coordinate of the boid's position.
     * @param y     The y-coordinate of the boid's position.
     * @param flock The flock that the boid belongs to.
     */
    PlayerControlledBoid(float x, float y, Flock flock) {
        super(x, y, flock);
    }
    
    /**
     * Overrides the run method of the Boid class to implement player-controlled behavior.
     * It calculates the steering force based on the mouse position and applies it to the boid.
     * It also updates the position, wraps around the borders, and renders the boid.
     * 
     * @param boids The list of all boids in the flock.
     */
    @Override
    void run(ArrayList<Boid> boids) {
        PVector mousePosition = getMousePosition();
        PVector steeringForce = getSteeringForce(boids, mousePosition);
        applyForce(steeringForce);
        updatePosition();
        wrapAroundBorders();
        render();
    }
    
    /**
     * Returns the current mouse position as a PVector object.
     * If the mouse is not on the screen, it returns null.
     * 
     * @return The current mouse position as a PVector object, or null if the mouse is not on the screen.
     */
    private PVector getMousePosition() {
        if (isMouseOnScreen()) {
            return new PVector(mouseX, mouseY);
        }
        return null;
    }
    
    /**
     * Checks if the mouse is on the screen.
     * 
     * @return true if the mouse is on the screen, false otherwise.
     */
    private boolean isMouseOnScreen() {
        return mouseX >= 0 && mouseX < width && mouseY >= 0 && mouseY < height;
    }
    
    /**
     * Calculates the steering force for the boid based on the mouse position.
     * If the mouse is on the screen, it seeks the mouse position.
     * Otherwise, it gets the flocking force from the other boids.
     * It also adds separation force to the steering force.
     * 
     * @param boids         The list of all boids in the flock.
     * @param mousePosition The current mouse position.
     * @return The steering force for the boid.
     */
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
    
    /**
     * Calculates the flocking force for the boid based on the other boids in the flock.
     * It gets the alignment force and cohesion force from the other boids.
     * It also adds the alignment force and cohesion force to the flocking force.
     * 
     * @param boids The list of all boids in the flock.
     * @return The flocking force for the boid.
     */
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