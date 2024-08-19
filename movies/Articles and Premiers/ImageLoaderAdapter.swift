//
//  ImageLoaderAdapter.swift
//  movies
//
//  Created by Александр Крапивин on 27.07.2024.
//

import UIKit

class ImageLoaderAdapter: ImageLoaderProtocol {
    private let imageLoader: ImageLoader
    
    init(imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        imageLoader.loadImage(from: url, completion: completion)
    }
}
