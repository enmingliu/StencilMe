//
//  LaunchScreenController.swift
//  SARS
//
//  Created by Nikil Roashan Selvam on 3/12/19.
//  Copyright © 2019 Neil Sonnenberg. All rights reserved.
//

import Foundation

import UIKit


class LaunchScreenController : UIViewController {

    @IBOutlet weak var spray: UIImageView!
    @IBOutlet weak var pencil: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pencil.alpha=0
        self.spray.alpha=0
        self.logo.alpha=0
        self.pencil.isHidden=false;
        self.logo.isHidden=false;
        self.spray.isHidden=false;
        self.pencil.center.x-=100;
        self.spray.center.x+=100;
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 2.0, animations: {
            self.pencil.transform = CGAffineTransform(translationX: 100, y: 0)
            self.spray.transform = CGAffineTransform(translationX: -100, y: 0)
            
            self.pencil.alpha=1
            self.spray.alpha=1
            self.logo.alpha=1
            
        })
        {(success) in
            
            usleep(2000000)
            self.performSegue(withIdentifier: "segueMainScreen", sender: self)
        }
        
    }
    
}
