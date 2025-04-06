import Foundation

struct Ball {
    var x: Float
    var y: Float
    var radius: Float
    var speedX: Float
    var speedY: Float
    var color: (r: UInt8, g: UInt8, b: UInt8)
    
    init(x: Float, y: Float, radius: Float, speedX: Float, speedY: Float, color: (r: UInt8, g: UInt8, b: UInt8)) {
        self.x = x
        self.y = y
        self.radius = radius
        self.speedX = speedX
        self.speedY = speedY
        self.color = color
    }
    
    mutating func update(width: Float, height: Float) {
        // Update position
        x += speedX
        y += speedY
        
        // Bounce off walls
        if x - radius < 0 || x + radius > width {
            speedX = -speedX
        }
        if y - radius < 0 || y + radius > height {
            speedY = -speedY
        }
    }
    
    // Check if two balls are colliding
    func isColliding(with other: Ball) -> Bool {
        // Skip if it's the same ball
        if self.x == other.x && self.y == other.y { return false }
        
        // Calculate distance between centers
        let dx = self.x - other.x
        let dy = self.y - other.y
        let distance = sqrt(dx * dx + dy * dy)
        
        // Collision occurs if distance is less than sum of radii
        return distance < (self.radius + other.radius)
    }
    
    // Calculate collision response
    func calculateCollisionResponse(with other: Ball) -> (speedX: Float, speedY: Float) {
        let dx = other.x - self.x
        let dy = other.y - self.y
        let distance = sqrt(dx * dx + dy * dy)
        
        // Normal vector
        let nx = dx / distance
        let ny = dy / distance
        
        // Relative velocity
        let dvx = other.speedX - self.speedX
        let dvy = other.speedY - self.speedY
        
        // Relative velocity along normal
        let velocityAlongNormal = dvx * nx + dvy * ny
        
        // Don't collide if balls are moving apart
        if velocityAlongNormal > 0 { return (self.speedX, self.speedY) }
        
        // Simple elastic collision
        let restitution: Float = 1.0 // Perfect elasticity
        let impulse = (-(1 + restitution) * velocityAlongNormal) / 2
        
        // Calculate new velocities
        let newSpeedX = self.speedX - impulse * nx
        let newSpeedY = self.speedY - impulse * ny
        
        return (newSpeedX, newSpeedY)
    }
} 