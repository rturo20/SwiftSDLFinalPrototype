import SDLWrapper
import CSDL2

// Initialize SDL
guard SDLWrapper.initialize() else {
    fatalError("SDL could not initialize! SDL_Error: \(SDLWrapper.getError())")
}

// Create window
let window = SDLWrapper.createWindow(title: "Dans SDL2 Window",
                                     x: SDLWrapper.SDL_WINDOWPOS_UNDEFINED,
                                     y: SDLWrapper.SDL_WINDOWPOS_UNDEFINED,
                                     w: 640, h: 480,
                                     flags: SDLWrapper.SDL_WINDOW_SHOWN)

guard window != nil else {
    fatalError("Window could not be created! SDL_Error: \(SDLWrapper.getError())")
}

// Create renderer
let renderer = SDLWrapper.createRenderer(window: window, index: -1, flags: 0)
guard renderer != nil else {
    fatalError("Renderer could not be created! SDL_Error: \(SDLWrapper.getError())")
}

// Create array of 100 balls with random properties
var balls: [Ball] = (0..<100).map { _ in
    Ball(
        x: Float.random(in: 0...640),
        y: Float.random(in: 0...480),
        radius: Float.random(in: 3...8),
        speedX: Float.random(in: -3...3),
        speedY: Float.random(in: -3...3),
        color: (
            r: UInt8.random(in: 0...255),
            g: UInt8.random(in: 0...255),
            b: UInt8.random(in: 0...255)
        )
    )
}

// Main loop flag
var quit = false

// Event handler
var e = SDL_Event()

// Main loop
while !quit {
    // Handle events on queue
    while SDLWrapper.pollEvent(&e) != 0 {
        if e.type == SDLWrapper.SDL_QUIT {
            quit = true
        }
    }

    // First update positions
    for i in 0..<balls.count {
        balls[i].update(width: 640, height: 480)
    }
    
    // Then handle collisions
    for i in 0..<balls.count {
        for j in (i+1)..<balls.count {
            if balls[i].isColliding(with: balls[j]) {
                let (newSpeedX1, newSpeedY1) = balls[i].calculateCollisionResponse(with: balls[j])
                let (newSpeedX2, newSpeedY2) = balls[j].calculateCollisionResponse(with: balls[i])
                
                balls[i].speedX = newSpeedX1
                balls[i].speedY = newSpeedY1
                balls[j].speedX = newSpeedX2
                balls[j].speedY = newSpeedY2
            }
        }
    }

    // Clear screen with dark blue background
    if SDLWrapper.setRenderDrawColor(renderer, r: 20, g: 20, b: 50, a: 255) != 0 {
        print("Warning: Failed to set render draw color: \(SDLWrapper.getError())")
    }
    if SDLWrapper.renderClear(renderer) != 0 {
        print("Warning: Failed to clear renderer: \(SDLWrapper.getError())")
    }

    // Draw all balls
    for ball in balls {
        if SDLWrapper.setRenderDrawColor(renderer, r: ball.color.r, g: ball.color.g, b: ball.color.b, a: 255) != 0 {
            print("Warning: Failed to set render draw color: \(SDLWrapper.getError())")
        }
        if !drawCircle(renderer: renderer, centerX: Int32(ball.x), centerY: Int32(ball.y), radius: Int32(ball.radius)) {
            print("Warning: Failed to draw circle: \(SDLWrapper.getError())")
        }
    }

    // Update screen
    SDLWrapper.renderPresent(renderer)

    // Add a small delay to control frame rate
    SDLWrapper.delay(16)
}

// Destroy window
if window != nil {
    SDLWrapper.destroyWindow(window)
}

// Quit SDL subsystems
SDLWrapper.quit()

// Helper function to draw a circle
func drawCircle(renderer: OpaquePointer?, centerX: Int32, centerY: Int32, radius: Int32) -> Bool {
    for w in -radius...radius {
        for h in -radius...radius {
            if w*w + h*h <= radius*radius {
                if SDLWrapper.renderDrawPoint(renderer, x: centerX + w, y: centerY + h) != 0 {
                    return false
                }
            }
        }
    }
    return true
}
