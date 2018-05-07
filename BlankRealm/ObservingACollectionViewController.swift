//
//  ObservingACollectionViewController.swift
//  BlankRealm
//
//  Created by dq on 2018/5/7.
//  Copyright © 2018年 moelove. All rights reserved.
//

import UIKit
import RealmSwift

class ObservingACollectionViewController: UIViewController {

    var token: NotificationToken?
    
    func test() {
        Example.of("Observing a Collection")
        
        //: **Setup Realm and preload some data**
        let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
        let realm = try! Realm(configuration: configuration)
        
        try! TestDataSet.create(in: realm)
        
        
        // 1
        let people = realm.objects(Person.self).sorted(byKeyPath: "firstName")
        token = people.observe({ (change) in
            print("Current count = \(people.count)")
        })
        
        
        try! realm.write {
            realm.add(Person())
        }
        
        try! realm.write {
            realm.add(Person())
        }
        
        DispatchQueue.global(qos: .background).async {
            let realm = try! Realm(configuration: configuration)
            try! realm.write {
                realm.add(Person())
            }
        }
        
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1.0) {
            self.token?.invalidate()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("0 all count = \(people.count)")
            try! realm.write {
                print("xxx")
                realm.add(Person())
                print("ooo")
                
            }
            print("1 all count = \(people.count)")
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        test()
    }

}
