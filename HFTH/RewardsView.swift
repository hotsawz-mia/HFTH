import SwiftUI

struct RewardsView: View {
    @Binding var showingRewards: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                ScrollView {
                    VStack(spacing: 8) {
                        RewardRow(points: 5, reward: "Pick a route for Daddy to try")
                        RewardRow(points: 10, reward: "Pick something fun from the shop (up to £1)")
                        RewardRow(points: 15, reward: "Climbing Smoothie of your choice")
                    }
                    .padding()
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Rewards")
            }

            // Top-right back button styled as an icon
            Button(action: {
                withAnimation(.easeInOut(duration: 0.6)) {
                    showingRewards = false
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }
}

struct RewardRow: View {
    let points: Int
    let reward: String

    var body: some View {
        HStack(alignment: .center) {
            Text("\(points)")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(Color("DarkBlue"))
                .frame(width: 36, height: 36)
                .background(Color("LightYellow"))
                .clipShape(Circle())

            Text(reward)
                .font(.subheadline)
                .foregroundColor(Color("DarkBlue"))
                .padding(.leading, 8)

            Spacer()
        }
        .padding()
        .background(Color("Yellow"))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.vertical, 4)
    }
}
