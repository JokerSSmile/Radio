import UIKit
import AVFoundation
import MediaPlayer

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var menuShift: NSLayoutConstraint!
    @IBOutlet weak var musicAnimationContainer: UIView!
    @IBOutlet weak var headerTitle: UINavigationItem!
    @IBOutlet weak var onlineSwitcher: UISwitch!
    @IBOutlet weak var tableList: UITableView!
    @IBOutlet weak var onlineText: UIButton!
    
    var equalizerView: AnimatedEqualizerView!
    var menuShowing = 	false
    let universityList = ["Волгатех", "МарГУ", "МОСИ"];
    let playlistGenre = ["Рок", "Поп", "Джаз"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        equalizerView = AnimatedEqualizerView(containerView: musicAnimationContainer)
        self.musicAnimationContainer.backgroundColor = UIColor.clear
        self.musicAnimationContainer.addSubview(equalizerView)
        equalizerView.animate()
        
        headerTitle.title = "Волгатех"
        
        if NSClassFromString("MPNowPlayingInfoCenter") != nil {
            let image:UIImage = UIImage(named: "logo-dark")!
            let albumArt = MPMediaItemArtwork(image: image)
            let songInfo = [
                MPMediaItemPropertyTitle: "o5radio",
                MPMediaItemPropertyArtwork: albumArt
            ] as [String : Any]
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (onlineSwitcher.isOn) {
            return universityList.count
        } else {
            return playlistGenre.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "universityCell", for: indexPath)
        cell.textLabel?.textColor = UIColor.white
        cell.imageView?.image = UIImage(named: "star")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        if (onlineSwitcher.isOn) {
            cell.textLabel?.text = universityList[indexPath.row]
        } else {
            cell.textLabel?.text = playlistGenre[indexPath.row]
            
        }

        return cell
    }
    
    @IBAction func onlineStateChanged(_ sender: UISwitch) {
        if (onlineText.currentTitle == "Онлайн") {
            onlineText.setTitle("Офлайн", for: UIControlState.normal)
        } else {
            onlineText.setTitle("Онлайн", for: UIControlState.normal)
        }
        tableList.reloadData()
    }
    
    func playButtonPressed(_ sender: UIButton) {
        toggle()
    }
    
    @IBAction func onSettingsPressed(_ sender: UIButton) {
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
        equalizerView.startAnimation()
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
        equalizerView.stopAnimation()
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

