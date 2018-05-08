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
        
        // 1
        Example.of("New Configuration") {
            let config = Realm.Configuration()
            print(config)
        }
        
        Example.of("Default Configuration") {
            print(Realm.Configuration.defaultConfiguration)
        }
        
        // 2
        Example.of("In-Memory Configuration") {
            let config1 = Realm.Configuration(inMemoryIdentifier: "InMemoryRealm1")
            print(config1)
            
            let config2 = Realm.Configuration(inMemoryIdentifier: "InMemoryRealm2")
            print(config2)
            
            let realm1 = try! Realm(configuration: config1)
            let people1 = realm1.objects(Person.self)
            
            try! realm1.write {
                realm1.add(Person())
            }
            
            print("people1 count = \(people1.count)")
            
            let realm2 = try! Realm(configuration: config2)
            let people2 = realm2.objects(Person.self)
            print("people2 count = \(people2.count)")

        }
        
        
        // 3
        Example.of("Documents Folder Configuration") {
            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("myRealm.realm")
            let documentsConfig = Realm.Configuration(fileURL: documentsUrl)
            
            print("Document folder realm in: \(documentsConfig.fileURL!)")
        }
        
        Example.of("Library Folder Configuration") {
        let libraryUrl = try! FileManager.default
            .url(for: .libraryDirectory, in: .userDomainMask,
                 appropriateFor: nil, create: false)
            .appendingPathComponent("myRealm.realm")
        
        let libraryConfig = Realm.Configuration(fileURL: libraryUrl)
        print("Realm in Library folder: \(libraryConfig.fileURL!)")
          }
        
        // 4
        Example.of("Object Schema in Realm") {
            let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "Realm"))
            print(realm.schema.objectSchema)
        }
        
        
        Example.of("Object Schema - Specific Object") {
        let config = Realm.Configuration(
            inMemoryIdentifier: "Realm2",
            objectTypes: [Person.self]
        )
        
        let realm = try! Realm(configuration: config)
        print(realm.schema.objectSchema)
    }
    
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.cyan
        
        test()
    }

}

