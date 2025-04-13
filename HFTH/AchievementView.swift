import SwiftUI

struct AchievementView: View {
    @Binding var achievement: Achievement
    var onTick: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(Color("DarkBlue")) // Text now visible on white

                Text("\(achievement.tickCount)/10")
                    .font(.subheadline)
                    .foregroundColor(Color("DarkBlue")) // Same here
            }

            Spacer()

            Button(action: {
                if achievement.canTick() {
                    achievement.tick()
                    onTick()
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(achievement.canTick() ? Color("Red") : .gray)
            }
            .disabled(!achievement.canTick())
        }
        .padding()
        .background(Color.white) // Match the app background
        .cornerRadius(12)
        .shadow(color: Color.gray.opacity(0.2), radius: 4, x: 0, y: 2) // Optional: soft shadow
    }
}
