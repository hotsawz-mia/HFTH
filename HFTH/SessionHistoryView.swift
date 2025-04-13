import SwiftUI

struct SessionHistoryView: View {
    let sessions: [ClimbingSession]

    var body: some View {
        List(sessions) { session in
            VStack(alignment: .leading) {
                Text(session.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.headline)
                Text("Points: \(session.totalPoints)")
                    .font(.subheadline)
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Session History")
    }
}
