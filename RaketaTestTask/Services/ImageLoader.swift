//
//  ImageLoader.swift
//  RaketaTestTask
//
//  Created by Dima Virych on 22.10.2020.
//

import UIKit

fileprivate class ImageLoader {
    
    private let cache = NSCache<NSString, UIImage>()
    
    func load(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        let imageName = url.lastPathComponent
        if let image = cache.object(forKey: imageName as NSString) {
            return completion(.success(image))
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, resp, err in
            if let e = err {
                return completion(.failure(e))
            }
            
            if 200..<300 ~= (resp as? HTTPURLResponse)?.statusCode ?? 0 {
                if let d = data, let img = UIImage(data: d) {
                    self?.cache.setObject(img, forKey: imageName as NSString)
                    completion(.success(img))
                } else {
                    completion(.failure(GlobalError.custom("Image loading error wrong data")))
                }
            } else {
                completion(.failure(GlobalError.custom("Image loading error code: \((resp as? HTTPURLResponse)?.statusCode ?? 0)")))
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
            let offset = (bounds.width / 2) - indicator.bounds.width / 2
            indicator.center = CGPoint(x: offset, y: offset)
            addSubview(indicator)
        }
        
        return indicator
    }
    
    func setImage(_ url: URL) {
        
        indicator.startAnimating()
        image = nil
        
        UIImageView.imageLoader.load(url) { (result) in
            
            switch result {
            case let .failure(err):
                Utilities.Logger.log(err)
            case let .success(image):
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.image = image
                }
            }
        }
    }
}

import AVKit
import AVFoundation

extension UIImageView {
    
    func playVideo(_ video: URL) {
        
        layer.sublayers?.filter { $0 is AVPlayerLayer }.forEach {
            ($0 as! AVPlayerLayer).player?.pause()
            $0.removeFromSuperlayer()
        }
        
        let player = AVPlayer(url: video)
        
        let _layer = AVPlayerLayer(player: player)
        _layer.frame = bounds
        layer.addSublayer(_layer)
        player.play()
        isUserInteractionEnabled = true
    }
}
