//
//  ViewController.swift
//  VCWaitingView
//
//  Created by qihaijun on 9/9/15.
//  Copyright (c) 2015 VictorChee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func show(sender: UIButton) {
        let hud = VCWaitingView(addToView: self.view)
        hud.show(true)
        delay(5.0) {
            hud.hide(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

