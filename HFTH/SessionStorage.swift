import Foundation

struct SessionStorage {
    private static let key = "climbingSessionHistory"

    static func save(_ sessions: [ClimbingSession]) {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func load() -> [ClimbingSession] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let sessions = try? JSONDecoder().decode([ClimbingSession].self, from: data) else {
            return []
        }
        return sessions
    }
}
