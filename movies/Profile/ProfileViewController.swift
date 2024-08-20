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
        element.image = UIImage(named: "UserPhotoOtus")
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
    
    private lazy var favoriteTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .accent
        tableView.register(FavoriteFilmCell.self, forCellReuseIdentifier: FavoriteFilmCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.separatorStyle = .none // Убираем разделительные линии
        return tableView
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
        mainStackView.addArrangedSubview(favoriteTableView)
        
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
        print("Logout")
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
        favoriteTableView.reloadData()
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
            headerStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            headerStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: -40),
            
            userPhoto.widthAnchor.constraint(equalToConstant: 70),
            userPhoto.heightAnchor.constraint(equalToConstant: 70),
            
            logoutButton.widthAnchor.constraint(equalToConstant: 24),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            notificationLabel.widthAnchor.constraint(equalToConstant: 40),
            notificationLabel.heightAnchor.constraint(equalToConstant: 22),
            
            favoriteTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            favoriteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoriteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user?.favoriteMovies.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteFilmCell.identifier, for: indexPath) as? FavoriteFilmCell,
              let filmID = user?.favoriteMovies[indexPath.row] else {
            return UITableViewCell()
        }

        // Загружаем данные о фильме по ID и обновляем ячейку
        fetchFilmDetails(for: filmID) { film in
            DispatchQueue.main.async {
                cell.configure(with: film)
            }
        }

        return cell
    }

    private func fetchFilmDetails(for filmID: Int, completion: @escaping (Film) -> Void) {
        let endpoint = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(filmID)"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.addValue("a9f1a40f-2e58-4d6d-9fb4-757ff9ac2619", forHTTPHeaderField: "X-API-KEY")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            if let film = try? decoder.decode(Film.self, from: data) {
                completion(film)
            }
        }.resume()
    }

    // Добавляем отступы между ячейками
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5 // Высота отступа между ячейками
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
}
