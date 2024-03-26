class PlayerControlledBoid extends Boid {
    PlayerControlledBoid(float x, float y) {
        super(x, y);
    }
    
    @Override
    void run(ArrayList<Boid> boids) {
        PVector mousePos = new PVector(mouseX, mouseY);
        PVector steer = seek(mousePos);
        applyForce(steer);
        
        updatePosition();
        borders();
        render();
    }
    
    @Override
    void render() {
        float theta = velocity.heading2D() + radians(90);
        
        // Set the fill color to blue
        fill(0, 0, 255);
        
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
}