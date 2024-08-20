import UIKit

final class ProfileViewController: UIViewController {
    
    private var user: User?
    
    // MARK: - UI and Life Cycle
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 24
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var headerStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.alignment = .center
        element.distribution = .equalSpacing
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var infoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 8
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var favoriteStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 8
        element.alignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var userPhoto: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "UserPhotoDefault")
        element.contentMode = .scaleAspectFill
        element.layer.cornerRadius = 35
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var logoutButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setImage(UIImage(named: "Logout"), for: .normal)
        element.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
        element.accessibilityIdentifier = "Logout Button"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var nameLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        element.textColor = .blackText
        element.textAlignment = .left
        element.numberOfLines = 1
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var loginLabel: UILabel = {
        let element = UILabel()
        element.font = UIFont.systemFont(ofSize: 13)
        element.textColor = .grayText
        element.textAlignment = .left
        element.numberOfLines = 1
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var favoriteLabel: UILabel = {
        let element = UILabel()
        element.text = "Избранное"
        element.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        element.textColor = .blackText
        element.textAlignment = .left
        element.numberOfLines = 1
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var notificationLabel: UILabel = {
        let element = UILabel()
        element.backgroundColor = .buttons
        element.textColor = .white
        element.font = UIFont.systemFont(ofSize: 13)
        element.textAlignment = .center
        element.layer.cornerRadius = 11
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var spacer: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accent
        
        if let login = UserDefaults.standard.string(forKey: "loggedInUser"),
           let userData = UserDefaults.standard.data(forKey: "user_\(login)"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.user = user
        }
        
        setView()
        setupConstraints()
        updateUI()
    }
    
    private func setView() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(headerStackView)
        mainStackView.addArrangedSubview(infoStackView)
        mainStackView.addArrangedSubview(favoriteStackView)
        
        favoriteStackView.addArrangedSubview(favoriteLabel)
        favoriteStackView.addArrangedSubview(notificationLabel)
        favoriteStackView.addArrangedSubview(spacer)
        
        headerStackView.addArrangedSubview(userPhoto)
        headerStackView.addArrangedSubview(logoutButton)
        
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(loginLabel)
    }
    
    // MARK: - Actions
    
    @objc private func didTapLogoutButton() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "loggedInUser")
        
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true, completion: nil)
    }
    
    private func updateUI() {
        nameLabel.text = user?.name
        loginLabel.text = user?.login
        notificationLabel.text = "\(user?.favoriteMovies.count ?? 0)"
    }
}

// MARK: - Constraints

extension ProfileViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            headerStackView.heightAnchor.constraint(equalToConstant: 70),
            
            userPhoto.widthAnchor.constraint(equalToConstant: 70),
            userPhoto.heightAnchor.constraint(equalToConstant: 70),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            notificationLabel.widthAnchor.constraint(equalToConstant: 40),
            notificationLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
