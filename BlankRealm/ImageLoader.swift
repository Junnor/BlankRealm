//
//  ImageLoader.swift
//  BlankRealm
//
//  Created by dq on 2018/5/4.
//  Copyright © 2018年 moelove. All rights reserved.
//

import UIKit

class ImageLoader: NSObject {
    
    static func loadImageFromUrl(_ url: URL, completion: @escaping (_ image: UIImage?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        DispatchQueue.global().async {
            let tmpUrl = url
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if data != nil, let image =  UIImage(data: data!) {
                    DispatchQueue.main.async {
                        if url == tmpUrl {
                            completion(image, response, error)
                        } else {
                            completion(nil, response, error)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, response, error)
                    }
                }
            }
            task.resume()
        }
        
    }
    
}
