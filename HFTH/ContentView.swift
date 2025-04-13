import SwiftUI

// MARK: - Session Model (shared across views)
struct ClimbingSession: Identifiable, Codable {
    let id: UUID
    let date: Date
    let totalPoints: Int

    init(id: UUID = UUID(), date: Date, totalPoints: Int) {
        self.id = id
        self.date = date
        self.totalPoints = totalPoints
    }
}

// MARK: - Main Content View
struct ContentView: View {
    @State private var achievements: [Achievement] = [
        Achievement(title: "Tried something scary"),
        Achievement(title: "Took a fall!"),
        Achievement(title: "Tried something scary"),
        Achievement(title: "Reached a new hold"),
        Achievement(title: "Asked for a beta"),
        Achievement(title: "Rested and came back stronger")
    ]
    @State private var showAnimation = false
    @State private var selectedGif = "celebration1"
    @State private var sessionHistory: [ClimbingSession] = SessionStorage.load()
    @State private var showingRewards = false

    var sessionTotal: Int {
        achievements.map { $0.tickCount }.reduce(0, +)
    }

    var body: some View {
        ZStack {
            if showingRewards {
                RewardsView(showingRewards: $showingRewards)
                    .transition(.flipFromRight)
                    .zIndex(1)
            } else {
                mainSessionView
                    .transition(.flipFromLeft)
                    .zIndex(0)
            }
        }
        .overlay(
            Group {
                if showAnimation {
                    // Tappable background to dismiss the animation
                    CelebrationView(gifName: selectedGif)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation {
                                showAnimation = false
                            }
                        }
                }
            }
        )
    }

    var mainSessionView: some View {
        NavigationView {
            VStack {
                List {
                    ForEach($achievements) { $achievement in
                        AchievementView(achievement: $achievement) {
                            SoundManager.playRandomSound()
                            let gifOptions = ["nans", "cat", "basketball", "sponge", "cat", "fall", "cat"]
                            selectedGif = gifOptions.randomElement() ?? "celebration1"

                            // Delay the animation slightly to allow batching points
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation {
                                    showAnimation = true
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                                    withAnimation {
                                        showAnimation = false
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color.white)
                    }
                }
                .listStyle(.plain)
                .listRowSeparator(.hidden)
                .scrollContentBackground(.hidden)
                .background(Color.white)

                Text("Session Total: \(sessionTotal)")
                    .font(.beastly(size: 32))
                    .foregroundColor(Color("DarkBlue"))
                    .padding(.top)

                

                HStack {
                    NavigationLink("History") {
                        SessionHistoryView(sessions: sessionHistory)
                    }
                    
                    Button("Submit Session") {
                        let newSession = ClimbingSession(date: Date(), totalPoints: sessionTotal)
                        sessionHistory.append(newSession)
                        SessionStorage.save(sessionHistory) // ✅ Save to UserDefaults

                        // Reset tick counts to 0
                        for index in achievements.indices {
                            achievements[index].tickCount = 0
                        }
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .tint(Color("Yellow"))
                    .foregroundColor(.white)
                    
                    Button("Rewards") {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            showingRewards = true
                        }
                    }
                }
                
            }
            .padding()
            .background(Color.white.ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("HAVE FUN, TRY HARD")
                        .font(.beastly(size: 20))
                        .foregroundColor(Color("DarkBlue"))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func playFunSound() {
        // Placeholder
    }
}

// MARK: - Custom Font Extension
extension Font {
    static func beastly(size: CGFloat) -> Font {
        .custom("RubikBeastly-Regular", size: size)
    }
}

// MARK: - Custom Flip Transition
extension AnyTransition {
    static var flipFromLeft: AnyTransition {
        .modifier(
            active: FlipEffect(angle: -180),
            identity: FlipEffect(angle: 0)
        )
    }

    static var flipFromRight: AnyTransition {
        .modifier(
            active: FlipEffect(angle: 180),
            identity: FlipEffect(angle: 0)
        )
    }
}

struct FlipEffect: ViewModifier {
    let angle: Double

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: (x: 0, y: 1, z: 0),
                perspective: 0.6
            )
    }
}

