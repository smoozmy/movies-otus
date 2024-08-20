import UIKit

final class RegistrationViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Твое имя"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.tintColor = .lightGrayText
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Придумай логин"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.tintColor = .lightGrayText
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Придумай пароль"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.tintColor = .lightGrayText
        textField.isSecureTextEntry = true
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = .buttons
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .accent
        
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, loginTextField, passwordTextField, registerButton, cancelButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            loginTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func didTapRegisterButton() {
        guard let name = nameTextField.text, !name.isEmpty,
              let login = loginTextField.text, !login.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showErrorAlert(message: "Все поля обязательны для заполнения.")
            return
        }
        
        let newUser = User(name: name, login: login, password: password)
        
        do {
            let userData = try JSONEncoder().encode(newUser)
            UserDefaults.standard.set(userData, forKey: "user_\(login)")
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(login, forKey: "loggedInUser")
            
            switchToMainInterface()
        } catch {
            showErrorAlert(message: "Не удалось зарегистрировать пользователя.")
        }
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func switchToMainInterface() {
        let mainVC = TabBarController()
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }
}
