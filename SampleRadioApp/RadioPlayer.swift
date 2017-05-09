import Foundation
import AVFoundation

class RadioPlayer {
    static let sharedInstance = RadioPlayer()
    fileprivate var player = AVPlayer(url: URL(string: "http://45.79.186.124:8181/stream")!)
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func toggle() {
        if currentlyPlaying() {
            pause()
        } else {
            play()
        }
    }

    func currentlyPlaying() -> Bool {
        return player.rate != 0
    }
}
