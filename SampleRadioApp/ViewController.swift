import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var menuShift: NSLayoutConstraint!
    
    var menuShowing = 	false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if NSClassFromString("MPNowPlayingInfoCenter") != nil {
//            let image:UIImage = UIImage(named: "logo_player_background")!
//            let albumArt = MPMediaItemArtwork(image: image)
            let songInfo = [
                MPMediaItemPropertyTitle: "o5radio",
//                MPMediaItemPropertyArtist: "87,8fm",
//                MPMediaItemPropertyArtwork: albumArt
            ]
            MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } catch {
            print("Audio Session error.\n")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playButtonPressed(_ sender: UIButton) {
        toggle()
    }
    
    @IBAction func onSettingsPressed(_ sender: Any) {
        onMenuPressed(UIBarButtonItem.self)
    }
    
    @IBAction func onMenuPressed(_ sender: Any) {
        if (menuShowing) {
            menuShift.constant = -250
        }
        else {
            menuShift.constant = 0
        }
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.view.layoutIfNeeded()
        })
        
        menuShowing = !menuShowing
    }

    func toggle() {
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            pauseRadio()
        } else {
            playRadio()
        }
    }
    
    func playRadio() {
        RadioPlayer.sharedInstance.play()
        playButton.setImage(#imageLiteral(resourceName: "pause-btn"), for: UIControlState())
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
        } catch {
            print("play radio err")
        }
    }
    
    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        playButton.setImage(#imageLiteral(resourceName: "play-btn"), for: UIControlState())
        do {
            try AVAudioSession.sharedInstance().setActive(false)
            MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
        } catch {
            print("pause radio err")
        }
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        guard let event = event else {
            return
        }
        guard event.type == UIEventType.remoteControl else {
            return
        }
        switch event.subtype {
        case UIEventSubtype.remoteControlPlay:
            self.playRadio()
        case UIEventSubtype.remoteControlPause:
            self.pauseRadio()
        default:
            break
        }
    }
}

