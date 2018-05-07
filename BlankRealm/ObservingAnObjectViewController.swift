//
//  ObservingAnObjectViewController.swift
//  BlankRealm
//
//  Created by dq on 2018/5/7.
//  Copyright © 2018年 moelove. All rights reserved.
//

import UIKit
import RealmSwift

class ObservingAnObjectViewController: UIViewController {
    
    var token: NotificationToken?
    
    func test() {
        Example.of("Observing an Object")
        
        //: **Setup Realm**
        let configuration = Realm.Configuration(inMemoryIdentifier: "TemporaryRealm")
        let realm = try! Realm(configuration: configuration)
        
        // 1
        let article = Article()
        article.id = "new-article"
        try! realm.write {
            realm.add(article)
        }
        
        token = article.observe { (change) in
            switch change {
            case .change(let properties):
                for property in properties {
                    
                    if properties.contains(where: { $0.name == "date" }) {
                        print("date changed to \(String(describing: article.date))")
                    }
                    
                    switch property.name {
                    case "title":
                        print("Article title changed from \(property.oldValue ?? "nil") to \(property.newValue ?? "nil")")
                    case "author":
                        print("Author changed to \(property.newValue ?? "nil")")
                    default: break
                    }
                }
            case .deleted:
                print("Article was deleted")
            case .error(let error):
                print("Error occured: \(error)")
            }
        }
        print("token = \(String(describing: token))")
        
        try! realm.write {
            article.title = "Work in progress"
        }
        
        
        // 2
        
        DispatchQueue.global(qos: .background).async {
            let realm = try! Realm(configuration: configuration)
            if let article = realm.object(ofType: Article.self, forPrimaryKey: "new-article") {
                
                try! realm.write {
                    article.title = "Actual title"
                    article.author = Person()
                }
   
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.cyan
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        test()
    }
}
