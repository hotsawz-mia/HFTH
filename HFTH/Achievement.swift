import Foundation // We use Foundation for basic types like UUID and Codable

// Define a simple model to track an achievement in a session
struct Achievement: Identifiable, Codable {
    let id = UUID() // Unique ID for use in lists
    let title: String // Description of the achievement
    var tickCount: Int = 0 // Number of times it's been ticked in this session (0–10)

    // Method to increase tick count if under the limit
    mutating func tick() {
        if tickCount < 10 {
            tickCount += 1
        }
    }

    // Check if we can still tick this achievement
    func canTick() -> Bool {
        tickCount < 10
    }
}
