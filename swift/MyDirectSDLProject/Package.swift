// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "MySDLProject",
    products: [
        .executable(name: "MySDLProject", targets: ["MySDLProject"]),
    ],
    dependencies: [],
    targets: [
        .systemLibrary(
            name: "CSDL2",
            pkgConfig: "sdl2",
            providers: [
                .brew(["sdl2"]),
                .apt(["libsdl2-dev"])
            ]
        ),
        .executableTarget(
            name: "MySDLProject",
            dependencies: ["CSDL2", "SDLWrapper"]
        ),
        .target(
            name: "SDLWrapper",
            dependencies: ["CSDL2"]
        )
    ]
)
