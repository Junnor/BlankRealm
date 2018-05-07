//
//  TestViewController.swift
//  BlankRealm
//
//  Created by dq on 2018/5/4.
//  Copyright © 2018年 moelove. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testButton.backgroundColor = UIColor.cyan
        
        // 1
//        testButton.setBackgroundImage(#imageLiteral(resourceName: "bg"), for: .normal)
        
        // 2
        testButton.setImage(#imageLiteral(resourceName: "bg"), for: .normal)
        
//        testButton.setTitle("Love", for: .normal)

    }


}
