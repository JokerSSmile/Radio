
import Foundation
import AVFoundation

class RadioPlayer {
    static let sharedInstance = RadioPlayer()
    static let streamUrl = URL(string: "http://edge.live.mp3.mdn.newmedia.nacamar.net/radiosalueclassicrock/livestream96s.mp3")
    private var player = AVPlayer	(url:streamUrl!)
    private var isPlaying = false
    
    func play() {
        player.play()
        isPlaying = true
    }
    
    func pause() {
        player.pause()
        isPlaying = false
    }
    
    func toggle() {
        if isPlaying == true {
            pause()
        } else {
            play()
        }
    }
    
    func currentlyPlaying() -> Bool {
        return isPlaying
    }
}
  
