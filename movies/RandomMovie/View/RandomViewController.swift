import UIKit

final class RandomViewController: UIViewController {
    
    private let viewModel = RandomViewModel()
    
    // MARK: - UI Elements
    
    private lazy var randomImages: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "random")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var randomButton: UIButton = {
        let element = UIButton(type: .custom)
        element.setTitle("Выбрать фильм...", for: .normal)
        element.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        element.setTitleColor(.white, for: .normal)
        element.backgroundColor = .buttons
        element.addTarget(self, action: #selector(didRandomButtonTapped), for: .touchUpInside)
        element.layer.cornerRadius = 25
        element.layer.masksToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var crashButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("crash", for: .normal)
        element.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        element.tintColor = .systemRed
        element.addTarget(self, action: #selector(didCrashButtonTapped), for: .touchUpInside)
        
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accent
        
        setView()
        setupConstraints()
        setupBindings()
    }
    
    private func setView() {
        view.addSubview(randomImages)
        view.addSubview(randomButton)
        view.addSubview(crashButton)
    }
    
    private func setupBindings() {
        viewModel.onFilmFetched = { [weak self] in
            self?.showFilmDetails()
        }
        viewModel.onError = { error in
            self.showError(error)
        }
    }
    
    @objc private func didRandomButtonTapped() {
        viewModel.fetchRandomFilm()
    }
    
    @objc private func didCrashButtonTapped() {
        fatalError("Test crash")
    }
    
    private func showFilmDetails() {
        let singleRandomVC = SingleRandomViewController()
        singleRandomVC.film = viewModel.film
        present(singleRandomVC, animated: true, completion: nil)
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Constraints

extension RandomViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            randomImages.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160),
            randomImages.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            randomImages.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            randomImages.heightAnchor.constraint(equalToConstant: 120),
            
            randomButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            randomButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            randomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            randomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            randomButton.heightAnchor.constraint(equalToConstant: 60),
            
            crashButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            crashButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
}
