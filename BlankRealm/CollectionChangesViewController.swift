//
//  CollectionChangesViewController.swift
//  BlankRealm
//
//  Created by dq on 2018/5/7.
//  Copyright © 2018年 moelove. All rights reserved.
//

import UIKit
import RealmSwift

class CollectionChangesViewController: UIViewController {

    var token: NotificationToken?
    
    
    func test() {
        
        Example.of("Collection Changes")
        
        //: **Setup Realm and preload some data**
        let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
        let realm = try! Realm(configuration: configuration)
        
        try! TestDataSet.create(in: realm)
        
        // 1
        let article = Article()
        article.id = "New Article"
        
        try! realm.write {
            realm.add(article)
        }
        
        
        token = article.people.observe({ (changes) in
            switch changes {
            case .initial(let people):
                print("Initial count: \(people.count)")
            case .update(let people, let deletions, let insertions, let updates):
                print("Current count: \(people.count)")
                print("Inserted \(insertions), Updated \(updates), Deleted \(deletions)")
            case .error(let error):
                print("Error: \(error)")
            }
        })
        
        try! realm.write {
            article.people.append(Person())
            article.people.append(Person())
            article.people.append(Person())
        }
        
        try! realm.write {
            article.people[1].isVIP = true
       }
        
        try! realm.write {
            article.people.remove(at: 0)
            article.people[1].firstName = "Joel"
        }
        try! realm.write {
            article.people.removeAll()
        }


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        test()
    }


}
