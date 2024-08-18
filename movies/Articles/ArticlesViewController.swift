import UIKit
import FirebaseCrashlytics
import FirebaseAnalytics

final class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let articleService = ArticlesService()
    
    var activity: UIActivityIndicatorView = .init()
    var articles: [Article] = []
    
    // MARK: - UI and Life Cycle
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accent
        
        setView()
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activity)
        loadNews()
        
//        Crashlytics.crashlytics().log("Открыт экран со списком новостных статей")
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
    
    // MARK: - TableView DataSource & Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleTableViewCell else {
            return UITableViewCell()
        }
        
        let article = articles[indexPath.row]
        cell.configure(with: article)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        let webViewController = ArticleWebViewController()
        webViewController.url = article.url
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    // MARK: - Load News
    
    func loadNews() {
        activity.startAnimating()
        articleService.fetchArticles { [weak self] result in
            DispatchQueue.main.async {
                self?.activity.stopAnimating()
                switch result {
                case .success(let articles):
                    self?.articles = articles
                    self?.tableView.reloadData()
                case .failure(let error):
                    let title: String
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .unknown:
                            title = "Неизвестная ошибка"
                        case .invalidMimeType, .invalidStatusCode, .client, .server, .emptyData, .invalidURL:
                            title = "Неверный контент"
                        }
                    } else {
                        title = error.localizedDescription
                    }
                    self?.showAlert(title: title)
                }
            }
        }
    }
    
    // MARK: - Show Alert
    
    func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    // MARK: - Set View
    
    private func setView() {
        view.addSubview(tableView)
    }
}

// MARK: - Constraints

extension ArticlesViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
