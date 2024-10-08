import UIKit

final class SingleRandomViewController: UIViewController {
    
    var film: Film?
    var user: User?
    var onFavoriteStatusChanged: (() -> Void)?
    private let viewModel = RandomViewModel()

    // MARK: - UI and Life Cycle
    
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
    
    private lazy var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var gradientImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gradient")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleMovie: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .systemFont(ofSize: 42, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var rating: UILabel = {
        let label = UILabel()
        label.text = ".."
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var originalName: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var moreInfo: UILabel = {
        let label = UILabel()
        label.text = "..."
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var country: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shortDescriptionMovie: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .buttons
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionMovie: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        button.setImage(UIImage(systemName: "arrow.triangle.2.circlepath", withConfiguration: config), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapRefreshButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accentLight

        if let savedLogin = UserDefaults.standard.string(forKey: "loggedInUser"),
           let savedUserData = UserDefaults.standard.data(forKey: "user_\(savedLogin)") {
            user = try? JSONDecoder().decode(User.self, from: savedUserData)
        }

        setupView()
        setupConstraints()
        updateUI()
    }
    
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(posterImage)
        contentView.addSubview(gradientImage)
        contentView.addSubview(titleMovie)
        contentView.addSubview(movieInfoStackView)
        movieInfoStackView.addArrangedSubview(rating)
        movieInfoStackView.addArrangedSubview(originalName)
        contentView.addSubview(moreInfo)
        contentView.addSubview(country)
        contentView.addSubview(shortDescriptionMovie)
        contentView.addSubview(descriptionMovie)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(refreshButton)
    }
    
    @objc private func didTapFavoriteButton() {
        guard let film = film, var user = user else { return }

        if let index = user.favoriteMovies.firstIndex(of: film.kinopoiskId) {
            user.favoriteMovies.remove(at: index)
            favoriteButton.backgroundColor = .lightGray
        } else {
            user.favoriteMovies.append(film.kinopoiskId)
            favoriteButton.backgroundColor = .buttons
            favoriteButton.setTitle("Смотрю", for: .normal)
        }

        if let encodedUser = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedUser, forKey: "user_\(user.login)")
        }

        NotificationCenter.default.post(name: NSNotification.Name("FavoritesChanged"), object: nil)
        
        onFavoriteStatusChanged?()
    }
    
    @objc private func didTapRefreshButton() {
        viewModel.fetchRandomFilm()
    }
    
    private func updateUI() {
        guard let film = film else { return }
        titleMovie.text = film.nameRu ?? film.nameOriginal
        let ratingValue = film.ratingKinopoisk ?? 0.0
        rating.text = String(format: "%.1f", ratingValue)
        rating.textColor = ratingColor(for: ratingValue)
        moreInfo.text = "\(film.year ?? 0), \(film.genres?.map { $0.genre }.joined(separator: ", ") ?? "")"
        country.text = film.countries?.map { $0.country }.joined(separator: ", ")
        originalName.text = film.nameOriginal
        shortDescriptionMovie.text = film.shortDescription
        descriptionMovie.text = film.description
        if let url = URL(string: film.posterUrl) {
            loadImage(from: url)
        }
    }
    
    private func ratingColor(for rating: Double) -> UIColor {
        switch rating {
        case ..<4.0:
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
                self.posterImage.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}

// MARK: - Constraints

extension SingleRandomViewController {
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
            
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImage.heightAnchor.constraint(equalTo: posterImage.widthAnchor, multiplier: 3.0 / 2.0),
            
            gradientImage.leadingAnchor.constraint(equalTo: posterImage.leadingAnchor),
            gradientImage.trailingAnchor.constraint(equalTo: posterImage.trailingAnchor),
            gradientImage.bottomAnchor.constraint(equalTo: posterImage.bottomAnchor),
            gradientImage.heightAnchor.constraint(equalToConstant: 500),
            
            titleMovie.centerXAnchor.constraint(equalTo: gradientImage.centerXAnchor),
            titleMovie.bottomAnchor.constraint(equalTo: movieInfoStackView.topAnchor, constant: -8),
            titleMovie.leadingAnchor.constraint(equalTo: gradientImage.leadingAnchor, constant: 16),
            titleMovie.trailingAnchor.constraint(equalTo: gradientImage.trailingAnchor, constant: -16),
            
            movieInfoStackView.centerXAnchor.constraint(equalTo: gradientImage.centerXAnchor),
            movieInfoStackView.bottomAnchor.constraint(equalTo: moreInfo.topAnchor, constant: -8),
            
            moreInfo.centerXAnchor.constraint(equalTo: gradientImage.centerXAnchor),
            moreInfo.bottomAnchor.constraint(equalTo: country.topAnchor, constant: -8),
            
            country.centerXAnchor.constraint(equalTo: gradientImage.centerXAnchor),
            country.bottomAnchor.constraint(equalTo: gradientImage.bottomAnchor, constant: -16),
            
            shortDescriptionMovie.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 16),
            shortDescriptionMovie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shortDescriptionMovie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionMovie.topAnchor.constraint(equalTo: shortDescriptionMovie.bottomAnchor, constant: 16),
            descriptionMovie.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionMovie.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            favoriteButton.topAnchor.constraint(equalTo: gradientImage.bottomAnchor, constant: 16),
            favoriteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 70),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            refreshButton.leadingAnchor.constraint(equalTo: favoriteButton.trailingAnchor, constant: 30),
            refreshButton.centerYAnchor.constraint(equalTo: favoriteButton.centerYAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -70),
            refreshButton.widthAnchor.constraint(equalToConstant: 40),
            refreshButton.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionMovie.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }
}
