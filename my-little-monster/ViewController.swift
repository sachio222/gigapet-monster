//
//  ViewController.swift
//  my-little-monster
//
//  Created by Jake Krajewski on 10/12/15.
//  Copyright © 2015 Jake Krajewski. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var monsterImg: MonsterImg!
    
    @IBOutlet weak var gameOverImg: UIStackView!
    
    @IBOutlet weak var skull1Img: UIImageView!
    @IBOutlet weak var skull2Img: UIImageView!
    @IBOutlet weak var skull3Img: UIImageView!

    let DIM_ALPHA: CGFloat = 0.0
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTY = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        initializeGame()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxDeath.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA + 0.2
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA + 0.2
        foodImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy {
        penalties++
        
            sfxSkull.play()
            
            if penalties == 1 {
                skull1Img.alpha = OPAQUE
                skull2Img.alpha = DIM_ALPHA
            } else if penalties == 2 {
                skull2Img.alpha = OPAQUE
            } else if penalties >= 3 {
                skull3Img.alpha = OPAQUE
            } else {
                skull1Img.alpha = DIM_ALPHA
                skull2Img.alpha = DIM_ALPHA
                skull3Img.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTY {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(2) // give me 0 or 1
        
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA + 0.2
            foodImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
            
        } else {
            heartImg.alpha = DIM_ALPHA + 0.2
            heartImg.userInteractionEnabled = false
            
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
        }
        
        currentItem = rand
        monsterHappy = false
        
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImg.playDeathAnimation()
        sfxDeath.play()
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "restartGameOption", userInfo: nil, repeats: false)
    }
    
    @IBAction func playAgainPressed(sender: AnyObject) {
        initializeGame()
    }
    
    func restartGameOption() {
        gameOverImg.hidden = false
    }
    
    func initializeGame() {
        
        gameOverImg.hidden = true
        
        skull1Img.alpha = DIM_ALPHA
        skull2Img.alpha = DIM_ALPHA
        skull3Img.alpha = DIM_ALPHA
        
        penalties = 0
        monsterHappy = false
        currentItem = 0
        
        monsterImg.playIdleAnimation()
        
        startTimer()
    }
}

