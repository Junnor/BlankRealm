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
        
        // 1
        Example.of("Getting all objects") {
            let people = realm.objects(Person.self)
            let articles = realm.objects(Article.self)
            
            print("people count \(people.count),  article count = \(articles.count)")
        }
        
        //2
        Example.of("Get an object with primary key") {
            if let person = realm.object(ofType: Person.self, forPrimaryKey: "test-key") {
                print("Person with primary key 'test-key': \(person.firstName)")
            } else {
                print("Not found")
            }
        }
        
        // 3
        Example.of("Accessing Results") {
            let people = realm.objects(Person.self)
            
            print("people count: \(people.count)")
            print("First person is: \(people.first!.fullName)")
            print("Second person is: \(people[1].fullName)  ")
            print("Last person is: \(people.last!.fullName)  ")
            
            let s = people.map { $0.fullName }.joined(separator: ", ")
            print(s)
            
            let e = people.enumerated().map { "\($0.offset): \($0.element.fullName)" }.joined(separator: ", ")
            print(e)

        }
        
        // 4
        Example.of("Results index") {
            let people = realm.objects(Person.self)
            let person = people[1]
            
            if let index = people.index(of: person) {
                print("person : \(person.fullName), at: \(index)")
            }
            
            if let index = people.index(where: { $0.firstName.starts(with: "J") } ) {
                print("J at \(index)")
            }
            
            if let index = people.index(matching: "hairCount < %s", 10000) {
                print("haricount < 10000 index = \(index)")
            }
        }
        
        // 5
        Example.of("Filteing") {
            let people = realm.objects(Person.self)
            print("All people count: \(people.count)")
            
            let living = realm.objects(Person.self).filter("deceased = nil")
            print("Living people count: \(living.count)")
            
            let predicate = NSPredicate(
                format: "hairCount < %d AND deceased = nil", 1000)
            let balding = realm.objects(Person.self).filter(predicate)
            print("Likely balding living people: \(balding.count)")
            
//            let baldingStatic = Person.allAliveLiklyBalding(in: realm)
//            print("Balding static people: \(baldingStatic.count)")
            
        }
        
        // 6
        
        Example.of("More predicate") {
            let janesAndFrank = realm.objects(Person.self).filter("firstName IN %@", ["Jane", "Frank"])
            print("janesAndFrand people: \(janesAndFrank.count)")
            
            let balding = realm.objects(Person.self).filter("hairCount BETWEEN {%d, %d}", 10, 10000)
            print("badling people = \(balding.count)")
            
            let search = realm.objects(Person.self).filter("""
firstName BEGINSWITH %@ OR
(lastName CONTAINS %@ AND hairCount > %d)
""", "J", "er", 1000)
            print("Search people \(search.count)")
        }
        
        // 7
        Example.of("Sorting") {
            let sort = realm.objects(Person.self).filter("firstName BEGINSWITH %@", "J").sorted(byKeyPath: "firstName")
            let asendingNames = sort.map { $0.firstName }.joined(separator: ", ")
            print("asendingNames \(asendingNames)")
            
            let deceadingSort = realm.objects(Person.self).filter("firstName BEGINSWITH %@", "J").sorted(byKeyPath: "firstName", ascending: false)
            let deceadingNames = deceadingSort.map { $0.firstName }.joined(separator: ", ")
            print("deceadingNames \(deceadingNames)")

            let sortedArticles = realm.objects(Article.self).sorted(byKeyPath: "author.firstName")
            print("Sorted articles by author: \n\(sortedArticles.map { "- \($0.author!.fullName): \($0.title!)" }.joined(separator: "\n"))")
            
            let sortedPeopleMultiple = realm.objects(Person.self)
                .sorted(by: [
                    SortDescriptor(keyPath: "firstName", ascending: true),
                    SortDescriptor(keyPath: "born", ascending: false)
                    ])
            
            print(sortedPeopleMultiple.map { "\($0.firstName) @ \($0.born)" }.joined(separator: "\n"))
            
        }
        
        // 8
        Example.of("Living results") {
            let people = realm.objects(Person.self).filter("key == 'key'")
            print("people key = 'key' \(people.count)")
            
            let newPerson1 = Person()
            newPerson1.key = "key"
            try! realm.write {
                realm.add(newPerson1)
            }
            
            print("people key = 'key' \(people.count)")
        }
        
        // 9
        Example.of("Cascading insert") {
            let newAuthor = Person()
            newAuthor.firstName = "New"
            newAuthor.lastName = "Author"

            let newArticle = Article()
            newArticle.author = newAuthor
            
            try! realm.write {
                realm.add(newArticle)
            }
            
            if let xxoo = realm.objects(Person.self).filter("firstName == 'New'").first {
                print("Author \(xxoo.fullName), wu la la")
            }
            
        }
        
        // 10
        Example.of("Updating") {
            let person = realm.objects(Person.self).first!
            print("\(person.fullName) initially - isVIP: \(person.isVIP), allowedPublication: \(person.allowedPublicationOn != nil ? "yes" : "no")")

            try! realm.write {
                person.isVIP = true
                person.allowedPublicationOn = Date()
            }
                
            print("\(person.fullName) initially - isVIP: \(person.isVIP), allowedPublication: \(person.allowedPublicationOn != nil ? "yes" : "no")")

        }
        
        // 11
        
        Example.of("Deleting") {
            let people = realm.objects(Person.self)
            print("There are \(people.count) before deletion: \(people.map { $0.firstName }.joined(separator: ", "))")
            
            try! realm.write {
                realm.delete(people[0])
                realm.delete([people[1], people[5]])
            }
            
            print("There are \(people.count) before deletion: \(people.map { $0.firstName }.joined(separator: ", "))")
            
            print("Empty before deleteAll ? \(realm.isEmpty)")
            try! realm.write {
                realm.deleteAll()
            }
            print("Empty after deleteAll ? \(realm.isEmpty)")
        }
        
        // 12
        Example.of("Chalenges") {
            let article = Article()
            let author = Person(firstName: "Zhu", born: Date(timeIntervalSince1970: 0))
            
            let jim = Person()
            jim.firstName = "Jim"
            
            article.author = author
            article.people.append(jim)
            
            try! realm.write {
                realm.add(article)
            }
            
            let containJimArticles = realm.objects(Article.self).filter("ANY people.firstName == 'Jim'")
            print("containJimArticles list is Jim \(containJimArticles)")
            
            let notcontainJimArticles = realm.objects(Article.self).filter("NONE people.firstName == 'Jim'")
            print("notcontainJimArticles list is Jim \(notcontainJimArticles)")
            
            let hasPeopleArticle = realm.objects(Article.self).filter("people.@count > 0")
            print("hasPeopleArticle \(hasPeopleArticle)")
            
            let people = realm.objects(Person.self).filter("firstName == 'Jim'")
            realm.beginWrite()
            
            print("people = \(people)")

            for i in people {
                i.firstName = "John"
            }
            try! realm.commitWrite()
            
            print("Johns: \(realm.objects(Person.self).filter("firstName == 'John'").count)")
        }
        
    }
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            
            collectionView.register(UINib(nibName: "MessageExhibitionCell", bundle: nil),
                                    forCellWithReuseIdentifier: "MessageExhibitionCell")
            
            collectionView.register( UINib(nibName: "MessageExhibitionHeaderView", bundle: nil),
                                     forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                     withReuseIdentifier: "MessageExhibitionHeaderView")
            
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        indicator.startAnimating()
        collectionView.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.indicator.stopAnimating()
            self.collectionView.isHidden = false
        }
    }
    
    private let edgeSpace: CGFloat = 15
    private let gap: CGFloat = 8
    private let numberInRows = 3
}


extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataAPI.demoUrlStrings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MessageExhibitionCell", for: indexPath)
        
        if let cell = cell as? MessageExhibitionCell {
            
            cell.titleLabel.text = String(DataAPI.demoUrlStrings[indexPath.item])

            if let url = URL(string: DataAPI.demoUrlStrings[indexPath.item]) {
                
                ImageLoader.loadImageFromUrl(url) { (image, response, error) in
                    if image != nil {
                        cell.imageView.image = image
                    }
                }
            }
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "MessageExhibitionHeaderView", for: indexPath)
        if let header = header as? MessageExhibitionHeaderView {
            header.titleLabel.text = "漫展看看看"
        }
        return header
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // image ratio: 33/45
        let imageRatio: CGFloat = 33.0/45
        let width = ((collectionView.bounds.width - 2 * edgeSpace) - (CGFloat(numberInRows - 1) * gap)) / CGFloat(numberInRows)
        let height = width/imageRatio + 30
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: edgeSpace, bottom: edgeSpace, right: edgeSpace)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return edgeSpace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return gap
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44)
    }
}



