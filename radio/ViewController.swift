//
//  ViewController.swift
//  radio
//
//  Created by Admin on 23/03/2017.
//  Copyright © 2017 freeStudetsProduction. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var menuView: UIView!
    
    var menuShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        toggle()
    }
    
    @IBAction func openMenu(_ sender: Any) {
        
        if (menuShowing) {
            leadingConstraint.constant = -250
        }
        else {
            leadingConstraint.constant = 0
        }
    
        //animate sidebar appearing/disappearing
        UIView.animate(withDuration: 0.3,
            animations: {
            self.view.layoutIfNeeded()
        })
    
        menuShowing = !menuShowing
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func toggle() {
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            pauseRadio()
            let playImage = UIImage(named: "play-btn");
            playButton.setImage(playImage, for: UIControlState.normal)
        } else {
            playRadio()
            let pauseImage = UIImage(named: "pause-btn");
            playButton.setImage(pauseImage, for: UIControlState.normal)
        }
    }
    
    func playRadio() {
        RadioPlayer.sharedInstance.play()
        playButton.setTitle("Pause", for: UIControlState.normal)
    }
    
    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        playButton.setTitle("Play", for: UIControlState.normal)
        
    }
}

