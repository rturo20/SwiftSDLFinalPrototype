import CSDL2

public struct SDLWrapper {
    public static let SDL_WINDOWPOS_UNDEFINED = Int32(0x1FFF0000)
    public static let SDL_WINDOW_SHOWN = UInt32(0x00000004)
    public static let SDL_QUIT = UInt32(0x100)
    
    public static func initialize() -> Bool {
        return SDL_Init(UInt32(SDL_INIT_VIDEO)) == 0
    }
    
    public static func createWindow(title: String, x: Int32, y: Int32, w: Int32, h: Int32, flags: UInt32) -> OpaquePointer? {
        return SDL_CreateWindow(title, x, y, w, h, flags)
    }
    
    public static func createRenderer(window: OpaquePointer?, index: Int32, flags: UInt32) -> OpaquePointer? {
        return SDL_CreateRenderer(window, index, flags)
    }
    
    public static func pollEvent(_ event: UnsafeMutablePointer<SDL_Event>) -> Int32 {
        return SDL_PollEvent(event)
    }
    
    public static func setRenderDrawColor(_ renderer: OpaquePointer?, r: UInt8, g: UInt8, b: UInt8, a: UInt8) -> Int32 {
        return SDL_SetRenderDrawColor(renderer, r, g, b, a)
    }
    
    public static func renderClear(_ renderer: OpaquePointer?) -> Int32 {
        return SDL_RenderClear(renderer)
    }
    
    public static func renderDrawPoint(_ renderer: OpaquePointer?, x: Int32, y: Int32) -> Int32 {
        return SDL_RenderDrawPoint(renderer, x, y)
    }
    
    public static func renderPresent(_ renderer: OpaquePointer?) {
        SDL_RenderPresent(renderer)
    }
    
    public static func delay(_ ms: UInt32) {
        SDL_Delay(ms)
    }
    
    public static func destroyWindow(_ window: OpaquePointer?) {
        SDL_DestroyWindow(window)
    }
    
    public static func quit() {
        SDL_Quit()
    }
    
    public static func getError() -> String {
        return String(cString: SDL_GetError())
    }
}
