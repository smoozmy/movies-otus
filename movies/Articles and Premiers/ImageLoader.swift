//
//  ImageLoader.swift
//  movies
//
//  Created by Александр Крапивин on 24.07.2024.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}

class ImageLoader: ImageLoaderProtocol {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    private let operationQueue = OperationQueue()
    
    private init() {
        operationQueue.maxConcurrentOperationCount = 5 // Задаем количество одновременных загрузок
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }
        
        let operation = BlockOperation {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: url as NSURL)
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        
        operationQueue.addOperation(operation)
    }
}

