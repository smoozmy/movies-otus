import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let defaults = UserDefaults.standard
    private let favoritesKey = "favorites"
    
    private init() {}
    
    func addFavorite(filmId: Int) {
        var favorites = getFavorites()
        if !favorites.contains(filmId) {
            favorites.append(filmId)
            defaults.set(favorites, forKey: favoritesKey)
        }
    }
    
    func removeFavorite(filmId: Int) {
        var favorites = getFavorites()
        if let index = favorites.firstIndex(of: filmId) {
            favorites.remove(at: index)
            defaults.set(favorites, forKey: favoritesKey)
        }
    }
    
    func isFavorite(filmId: Int) -> Bool {
        return getFavorites().contains(filmId)
    }
    
    func getFavorites() -> [Int] {
        return defaults.array(forKey: favoritesKey) as? [Int] ?? []
    }
}
