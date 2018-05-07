//
//  EntireRealmViewController.swift
//  BlankRealm
//
//  Created by dq on 2018/5/7.
//  Copyright © 2018年 moelove. All rights reserved.
//

import UIKit
import RealmSwift

class EntireRealmViewController: UIViewController {
    
    var token: NotificationToken?
    
    func test() {
        Example.of("Realm wide notifications")
        
        //: **Setup Realm**
        let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
        let realm = try! Realm(configuration: configuration)
        
        token = realm.observe({ (notification, realm) in
            print(notification)
        })
        
        try! realm.write {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        test()
    }


}
