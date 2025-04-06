import SDLWrapper
import CSDL2

// Initialize SDL
guard SDLWrapper.initialize() else {
    fatalError("SDL could not initialize! SDL_Error: \(SDLWrapper.getError())")
}

// Create window
let window = SDLWrapper.createWindow(title: "SDL2 Window",
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

// Ball properties
var ballX: Float = 320.0
var ballY: Float = 240.0
let ballRadius: Float = 15.0
var ballSpeedX: Float = 2.0
var ballSpeedY: Float = 2.0

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

    // Update ball position
    ballX += ballSpeedX
    ballY += ballSpeedY

    // Bounce off walls
    if ballX - ballRadius < 0 || ballX + ballRadius > 640 {
        ballSpeedX = -ballSpeedX
    }
    if ballY - ballRadius < 0 || ballY + ballRadius > 480 {
        ballSpeedY = -ballSpeedY
    }

    // Clear screen
    if SDLWrapper.setRenderDrawColor(renderer, r: 100, g: 100, b: 100, a: 255) != 0 {
        print("Warning: Failed to set render draw color: \(SDLWrapper.getError())")
    }
    if SDLWrapper.renderClear(renderer) != 0 {
        print("Warning: Failed to clear renderer: \(SDLWrapper.getError())")
    }

    // Draw ball
    if SDLWrapper.setRenderDrawColor(renderer, r: 255, g: 0, b: 0, a: 255) != 0 {
        print("Warning: Failed to set render draw color: \(SDLWrapper.getError())")
    }
    if !drawCircle(renderer: renderer, centerX: Int32(ballX), centerY: Int32(ballY), radius: Int32(ballRadius)) {
        print("Warning: Failed to draw circle: \(SDLWrapper.getError())")
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
