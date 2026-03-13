import Foundation

enum Accent: Int {
    case blush = 15
    case citrus = 16
    case indigo = 17

    var wallpaperFileName: String {
        switch self {
        case .blush: return "Neo_Blush.heic"
        case .citrus: return "Neo_Citrus.heic"
        case .indigo: return "Neo_Indigo.heic"
        }
    }
}

func run(_ command: String, args: [String]) {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: command)
    process.arguments = args

    do {
        try process.run()
        process.waitUntilExit()
    } catch {
        print("Failed to run \(command)")
    }
}

func setAccent(_ accent: Accent) {

    run("/usr/bin/defaults", args: [
        "write",
        "-g",
        "NSColorSimulateHardwareAccent",
        "-bool",
        "YES"
    ])

    run("/usr/bin/defaults", args: [
        "write",
        "-g",
        "NSColorSimulatedHardwareEnclosureNumber",
        "-int",
        "\(accent.rawValue)"
    ])

    let currentDir = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
    let wallpaperURL = currentDir.appendingPathComponent("wallpapers").appendingPathComponent(accent.wallpaperFileName)
    let script = "tell application \"System Events\" to tell every desktop to set picture to \"\(wallpaperURL.path)\""
    run("/usr/bin/osascript", args: ["-e", script])

    run("/usr/bin/osascript", args: ["-e", "tell application \"Finder\" to quit"])
    run("/usr/bin/open", args: ["-a", "Finder"])
    run("/usr/bin/killall", args: ["Dock"])

    print("Accent set to \(accent)")
}

func resetAccent() {

    run("/usr/bin/defaults", args: [
        "delete",
        "-g",
        "NSColorSimulateHardwareAccent"
    ])

    run("/usr/bin/defaults", args: [
        "delete",
        "-g",
        "NSColorSimulatedHardwareEnclosureNumber"
    ])

    let script = "tell application \"System Events\" to tell every desktop to set picture to \"/System/Library/Desktop Pictures/Sonoma.heic\""
    run("/usr/bin/osascript", args: ["-e", script])

    run("/usr/bin/osascript", args: ["-e", "tell application \"Finder\" to quit"])
    run("/usr/bin/open", args: ["-a", "Finder"])
    run("/usr/bin/killall", args: ["Dock"])

    print("Accent reset")
}

let args = CommandLine.arguments

guard args.count > 1 else {
    print("Usage: macaccent [blush|citrus|indigo|reset]")
    exit(1)
}

switch args[1] {

case "blush":
    setAccent(.blush)

case "citrus":
    setAccent(.citrus)

case "indigo":
    setAccent(.indigo)

case "reset":
    resetAccent()

default:
    print("Unknown option")
}