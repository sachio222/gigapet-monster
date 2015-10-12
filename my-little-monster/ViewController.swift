//
//  ViewController.swift
//  my-little-monster
//
//  Created by Jake Krajewski on 10/12/15.
//  Copyright © 2015 Jake Krajewski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var monsterImg :UIImageView!
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadIdleAnimation()
    }
    
    func loadIdleAnimation(){
        var imgAry = [UIImage]()
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "idle\(x).png")
            imgAry.append(img!)
        }
        
        monsterImg.animationImages = imgAry
        monsterImg.animationDuration = 0.8
        monsterImg.animationRepeatCount = 0
        monsterImg.startAnimating()
    }
    
}

