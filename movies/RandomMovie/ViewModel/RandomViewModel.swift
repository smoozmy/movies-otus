//
//  RandomViewModel.swift
//  movies
//
//  Created by Александр Крапивин on 27.07.2024.
//

import UIKit

class RandomViewModel {
    private let randomService: RandomService
    var film: Film?
    
    var onFilmFetched: (() -> Void)?
    var onError: ((Error) -> Void)?

    init(randomService: RandomService = RandomService()) {
        self.randomService = randomService
    }

    func fetchRandomFilm() {
        randomService.fetchRandomFilm { [weak self] result in
            switch result {
            case .success(let film):
                self?.film = film
                self?.onFilmFetched?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
}


