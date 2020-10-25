//
//  ImageLoader.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 22.10.2020.
//

import UIKit

fileprivate class ImageLoader {
    
    private lazy var cache = Cache()
    
    func load(_ url: URL, completion: @escaping (Result<UIImage?, Error>) -> Void) {
        
        let imageName = url.lastPathComponent
        if let image = cache.getImage(name: imageName) {
            return completion(.success(image))
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, resp, err in
            if let e = err {
                return completion(.failure(e))
            }
            
            if 200..<300 ~= (resp as? HTTPURLResponse)?.statusCode ?? 0 {
                if let d = data, let img = UIImage(data: d) {
                    do {
                        try self?.cache.add(img, with: imageName)
                    } catch {
                        return completion(.failure(GlobalError.custom("Image loading error wrong data")))
                    }
                    completion(.success(img))
                } else {
                    completion(.success(nil))
                    completion(.failure(GlobalError.custom("Image loading error wrong data")))
                }
            } else {
                completion(.failure(GlobalError.custom("Image loading with error code: \((resp as? HTTPURLResponse)?.statusCode ?? 0)\nResource: \(url)")))
            }
        }.resume()
    }
}

extension UIImageView {
    
    fileprivate static let imageLoader = ImageLoader()
    
    private var indicator: UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView = (subviews.first(where: { $0 is UIActivityIndicatorView }) ?? UIActivityIndicatorView(style: .medium)) as! UIActivityIndicatorView
        if !subviews.contains(indicator) {
            
            indicator.hidesWhenStopped = true
            let offset = (bounds.width / 2)
            indicator.center = CGPoint(x: offset, y: offset)
            addSubview(indicator)
        }
        
        return indicator
    }
    
    func setImage(_ url: URL) {
        
        indicator.startAnimating()
        image = nil
        isHidden = false
        
        UIImageView.imageLoader.load(url) { (result) in
            
            DispatchQueue.main.async {
                switch result {
                case let .failure(err):
                    self.image = UIImage(named: "noimage")
                    Utilities.Logger.log(err)
                    self.indicator.stopAnimating()
                case let .success(image):
                    self.indicator.stopAnimating()
                    self.image = image
                }
            }
        }
    }
}
