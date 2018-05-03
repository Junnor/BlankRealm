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
        // setup
        let realm = try! Realm(configuration:
            Realm.Configuration(inMemoryIdentifier: "TemporaryRealm"))
        try! TestDataSet.create(in: realm)
        
        print("Ready to play!")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        test()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

