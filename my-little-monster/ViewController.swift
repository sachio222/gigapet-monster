//
//  ViewController.swift
//  my-little-monster
//
//  Created by Jake Krajewski on 10/12/15.
//  Copyright © 2015 Jake Krajewski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var monsterImg: MonsterImg!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        
    }
}

