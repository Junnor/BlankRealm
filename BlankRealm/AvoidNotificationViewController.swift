//
//  AvoidNotificationViewController.swift
//  BlankRealm
//
//  Created by dq on 2018/5/7.
//  Copyright © 2018年 moelove. All rights reserved.
//

import UIKit
import RealmSwift

class AvoidNotificationViewController: UIViewController {
    
    
    var token1: NotificationToken?
    var token2: NotificationToken?

    func test() {
        Example.of("Avoid notifications for given tokens")
        
        //: **Setup Realm and preload some data**
        let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
        let realm = try! Realm(configuration: configuration)
        
        try! TestDataSet.create(in: realm)
        
        
        
        // 1
        let people = realm.objects(Person.self)
        
        
        token1 = people.observe { changes in
            switch changes {
            case .initial:
            print("Initial notification for token1")
            case .update:
            print("Change notification for token1")
            default: break
            }
        }
        
        token2 = people.observe { changes in
            switch changes {
            case .initial:
            print("Initial notification for token2")
            case .update:
            print("Change notification for token2")
            default: break
            }
        }
        
        
        realm.beginWrite()
        realm.add(Person())
        try! realm.commitWrite(withoutNotifying: [token2!])
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        test()
        
    }

}
