import UIKit
import FirebaseCrashlytics
import FirebaseAnalytics

final class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let articleService = ArticlesService()
    let premieresService = PremieresService()
    
    var activity: UIActivityIndicatorView = .init()
    var articles: [Article] = []
    var premieres: [Premiere] = []
    
    // MARK: - UI and Life Cycle
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Главное на сегодня"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        label.text = dateFormatter.string(from: Date())
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Новости", "Премьеры"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        
        // Устанавливаем фон
        control.backgroundColor = .white
        
        // Настройка активного сегмента
        control.selectedSegmentTintColor = .black
        
        // Настройка текста в сегментах
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    
    private lazy var articlesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isHidden = false
        return tableView
    }()
    
    private lazy var premieresTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PremiereTableViewCell.self, forCellReuseIdentifier: "PremiereCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(segmentedControl)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accent
        
        setupViews()
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activity)
        loadArticles()
        
        Analytics.logEvent("Открыт экран со списком новостных статей", parameters: ["LogLvl": "Info"])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func fetchFilmDetails(for filmID: Int, completion: @escaping (Film) -> Void) {
        let endpoint = "https://kinopoiskapiunofficial.tech/api/v2.2/films/\(filmID)"
        guard let url = URL(string: endpoint) else { return }

        var request = URLRequest(url: url)
        request.addValue("\(Constants.standart.apiKey)", forHTTPHeaderField: "X-API-KEY")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            if let film = try? decoder.decode(Film.self, from: data) {
                completion(film)
            }
        }.resume()
    }

    
    // MARK: - Segmented Control Action
    
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            articlesTableView.isHidden = false
            premieresTableView.isHidden = true
            loadArticles()
        } else {
            articlesTableView.isHidden = true
            premieresTableView.isHidden = false
            loadPremieres()
        }
    }
    
    // MARK: - TableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == articlesTableView {
            return articles.count
        } else {
            return premieres.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == articlesTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleTableViewCell else {
                return UITableViewCell()
            }
            
            let article = articles[indexPath.row]
            cell.configure(with: article)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PremiereCell", for: indexPath) as? PremiereTableViewCell else {
                return UITableViewCell()
            }
            
            let premiere = premieres[indexPath.row]
            cell.configure(with: premiere)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == articlesTableView {
            let article = articles[indexPath.row]
            let webViewController = ArticleWebViewController()
            webViewController.url = article.url
            navigationController?.pushViewController(webViewController, animated: true)
        } else if tableView == premieresTableView {
            let premiere = premieres[indexPath.row]
            
            fetchFilmDetails(for: premiere.kinopoiskId) { [weak self] film in
                DispatchQueue.main.async {
                    let detailVC = FilmDetailViewController()
                    detailVC.film = film
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        }
    }

    
    
    
    // MARK: - Load Content
    
    private func loadArticles() {
        activity.startAnimating()
        articleService.fetchArticles { [weak self] result in
            DispatchQueue.main.async {
                self?.activity.stopAnimating()
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.articlesTableView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: error.localizedDescription)
                }
            }
        }
    }
    
    private func loadPremieres() {
        activity.startAnimating()
        premieresService.fetchPremieres { [weak self] result in
            DispatchQueue.main.async {
                self?.activity.stopAnimating()
                switch result {
                case .success(let premieres):
                    self?.premieres = premieres
                    self?.premieresTableView.reloadData()
                case .failure(let error):
                    self?.showAlert(title: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Show Alert
    
    private func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Set Up Views
    
    private func setupViews() {
        view.addSubview(headerView)
        view.addSubview(articlesTableView)
        view.addSubview(premieresTableView)
    }
    
    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    
                    dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                    dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            segmentedControl.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10),
            
            articlesTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            articlesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            articlesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            articlesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            premieresTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            premieresTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            premieresTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            premieresTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
