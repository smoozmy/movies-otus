import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let random = RandomViewController()
        let news = ArticlesViewController()
        
        let randomNavController = UINavigationController(rootViewController: random)
        let newsNavController = UINavigationController(rootViewController: news)
        
        randomNavController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "popcorn.circle"),
            selectedImage: UIImage(systemName: "popcorn.circle.fill")
        )
        randomNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        newsNavController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "newspaper.circle"),
            selectedImage: UIImage(systemName: "newspaper.circle.fill")
        )
        newsNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        self.viewControllers = [
            randomNavController,
            newsNavController
        ]
        
        configureTabBarAppearance()
        setViewControllersBackgroundColor()
    }
    
    private func configureTabBarAppearance() {
        let tabBar = self.tabBar
        tabBar.barTintColor = .accent
        tabBar.unselectedItemTintColor = .white
        tabBar.tintColor = .buttons
        tabBar.isTranslucent = false
        
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .accent
            appearance.shadowColor = .accent
            
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabBar.standardAppearance
            }
        } else {
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
    }
    
    private func setViewControllersBackgroundColor() {
        if let viewControllers = viewControllers {
            for viewController in viewControllers {
                if let navController = viewController as? UINavigationController {
                    navController.view.backgroundColor = .accent
                } else {
                    viewController.view.backgroundColor = .accent
                }
            }
        }
    }
}
