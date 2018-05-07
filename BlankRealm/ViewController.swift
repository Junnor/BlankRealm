//
//  ViewController.swift
//  BlankRealm
//
//  Created by dq on 2018/5/3.
//  Copyright © 2018年 moelove. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    func test() {
        Example.of("Observing an Object")
        
        //: **Setup Realm**
        let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
        let realm = try! Realm(configuration: configuration)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.cyan
        
        test()
    }
    
}

