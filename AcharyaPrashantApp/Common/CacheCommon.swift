//
//  CacheCommon.swift
//  AcharyaPrashantApp
//
//  Created by Sathiyaraj on 05/05/24.
//

import Foundation
import UIKit
class Cache {
    
    static let shared : NSCache<AnyObject,UIImage> = {
        
        return NSCache<AnyObject,UIImage>()
        
    }()
    
    class func image(forUrl urlString : String?, completion : @escaping (UIImage?)-> ()){
        
        DispatchQueue(label: ProcessInfo().globallyUniqueString, qos: .background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: nil) .async {
            var image : UIImage? = nil
            guard  let url = urlString else {
                completion(image)
                return
            }
            image = Cache.shared.object(forKey: url as AnyObject) // Retrieve Image From cache If available
            if image == nil, !url.isEmpty, let _url = URL(string: url) {  // If Image is not available, then download
                URLSession.shared.dataTask(with: _url, completionHandler: { (data, response, error) in
                    guard data != nil, let imageData = UIImage(data: data!), let responseUrl = response?.url?.absoluteString else {
                        completion(nil)
                        return
                    }
                    Cache.shared.setObject(imageData, forKey: responseUrl as AnyObject)
                    completion(imageData) // return Image
                }).resume()
            }
            completion(image)
        }
    }
}

extension UIImageView {
    
    func setImage(with urlString : String?,placeHolder placeHolderImage : UIImage?) {
        self.image = placeHolderImage
        guard urlString != nil, let imageUrl = URL(string: urlString!) else {
            return
        }
        if let image = Cache.shared.object(forKey: urlString! as AnyObject) {
            self.image = image
        } else {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                guard data != nil, let imagePic = UIImage(data: data!), let responseUrl = response?.url?.absoluteString else {
                    return
                }
                DispatchQueue.main.async {
                     self.image = imagePic
                }
                Cache.shared.setObject(imagePic, forKey: responseUrl as AnyObject)
                }.resume()
        }
    }
}
    
