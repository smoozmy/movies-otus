import UIKit

final class FilmDetailViewController: UIViewController {

    var film: Film?
    var user: User?
    var onFavoriteStatusChanged: (() -> Void)?
    private var actors: [Actor] = []

    // MARK: - UI Elements
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Буду смотреть", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var originalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var yearAndGenreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var actorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Актеры"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var actorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ActorCell.self, forCellWithReuseIdentifier: ActorCell.identifier)
        return collectionView
    }()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let savedLogin = UserDefaults.standard.string(forKey: "loggedInUser"),
           let savedUserData = UserDefaults.standard.data(forKey: "user_\(savedLogin)") {
            user = try? JSONDecoder().decode(User.self, from: savedUserData)
        }

        setupView()
        setupConstraints()
        updateUI()
        fetchActors()
        
        // Изменение кнопки назад
        setupBackButton()
    }

    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(originalTitleLabel)
        contentView.addSubview(yearAndGenreLabel)
        contentView.addSubview(countryLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextLabel)
        contentView.addSubview(actorsLabel)
        contentView.addSubview(actorsCollectionView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            posterImageView.heightAnchor.constraint(equalToConstant: 160),
            
            favoriteButton.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8),
            favoriteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 120),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            
            originalTitleLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),
            originalTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            
            yearAndGenreLabel.topAnchor.constraint(equalTo: originalTitleLabel.bottomAnchor, constant: 8),
            yearAndGenreLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            yearAndGenreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            countryLabel.topAnchor.constraint(equalTo: yearAndGenreLabel.bottomAnchor, constant: 8),
            countryLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionTextLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            actorsLabel.topAnchor.constraint(equalTo: descriptionTextLabel.bottomAnchor, constant: 16),
            actorsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            actorsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            actorsCollectionView.topAnchor.constraint(equalTo: actorsLabel.bottomAnchor, constant: 8),
            actorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            actorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            actorsCollectionView.heightAnchor.constraint(equalToConstant: 120),
            
            actorsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    private func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .red
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func updateUI() {
        guard let film = film else { return }
        titleLabel.text = film.nameRu ?? film.nameOriginal
        originalTitleLabel.text = film.nameOriginal
        let ratingValue = film.ratingKinopoisk ?? 0.0
        ratingLabel.text = String(format: "%.1f", ratingValue)
        ratingLabel.textColor = ratingColor(for: ratingValue)
        yearAndGenreLabel.text = "\(film.year ?? 0), \(film.genres?.map { $0.genre }.joined(separator: ", ") ?? "")"
        countryLabel.text = film.countries?.map { $0.country }.joined(separator: ", ")
        descriptionTextLabel.text = film.description
        if let url = URL(string: film.posterUrl) {
            loadImage(from: url)
        }
        
        // Проверка, добавлен ли фильм в избранное
        if let user = user, user.favoriteMovies.contains(film.kinopoiskId) {
            favoriteButton.backgroundColor = .red
        } else {
            favoriteButton.backgroundColor = .lightGray
        }
    }

    private func ratingColor(for rating: Double) -> UIColor {
        switch rating {
        case 0.1..<4.0:
            return .systemRed
        case 4.0..<6.5:
            return .systemYellow
        case 0.0:
            return .gray
        default:
            return .systemGreen
        }
    }

    private func loadImage(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: data)
            }
        }
        task.resume()
    }

    @objc private func didTapFavoriteButton() {
        guard let film = film, var user = user else { return }

        if let index = user.favoriteMovies.firstIndex(of: film.kinopoiskId) {
            user.favoriteMovies.remove(at: index)
            favoriteButton.backgroundColor = .gray
        } else {
            user.favoriteMovies.append(film.kinopoiskId)
            favoriteButton.backgroundColor = .red
        }

        if let encodedUser = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: "user_\(user.login)")
        }
        onFavoriteStatusChanged?()
    }
    
    private func fetchActors() {
        guard let film = film else { return }
        let endpoint = "https://kinopoiskapiunofficial.tech/api/v1/staff?filmId=\(film.kinopoiskId)"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.addValue("\(Constants.standart.apiKey)", forHTTPHeaderField: "X-API-KEY")

        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            if let fetchedActors = try? decoder.decode([Actor].self, from: data) {
                DispatchQueue.main.async {
                    self?.actors = fetchedActors.filter { $0.professionKey == "ACTOR" }
                    self?.actorsCollectionView.reloadData()
                }
            }
        }.resume()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension FilmDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActorCell.identifier, for: indexPath) as? ActorCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: actors[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FilmDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 120)
    }
}
