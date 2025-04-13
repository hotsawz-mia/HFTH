// SoundManager.swift
import AVFoundation // Import for audio playback

class SoundManager {
    static var player: AVAudioPlayer?

    // Play a random sound from your bundle
    static func playRandomSound() {
        // List of file names without extension
        let soundNames = ["woohoo",  "cheer", "woohoo", "whoopee"]

        // Randomly pick one
        guard let name = soundNames.randomElement(),
              let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
