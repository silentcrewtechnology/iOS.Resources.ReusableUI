//
//  ChangePinVC.swift
//
//
//  Created by Ilnur Mugaev on 04.06.2024.
//

import Architecture
import UIKit
import SnapKit

// TODO: Временный вью контроллер, заменить после получения макета от дизайнеров
final public class ChangePinVC: UIViewController, ViewProtocol {
    
    // MARK: - ViewProperties
    
    public struct ViewProperties {
        
        public struct DeleteButton {
            public var isHidden: Bool
            public var onTap: () -> Void
            
            public init(
                isHidden: Bool = true,
                onTap: @escaping () -> Void = { }
            ) {
                self.isHidden = isHidden
                self.onTap = onTap
            }
        }
        
        public struct BackButton {
            public var icon: UIImage
            public var onTap: () -> Void
            
            public init(
                icon: UIImage = .init(),
                onTap: @escaping () -> Void = { }
            ) {
                self.icon = icon
                self.onTap = onTap
            }
        }
        
        public struct Alert {
            public var title: String
            public var message: String
            public var buttonTitle: String
            public var buttonTapped: () -> Void
            
            public init(
                title: String = "",
                message: String = "",
                buttonTitle: String = "",
                buttonTapped: @escaping () -> Void = { }
            ) {
                self.title = title
                self.message = message
                self.buttonTitle = buttonTitle
                self.buttonTapped = buttonTapped
            }
        }
        
        public var title: NSMutableAttributedString
        public var alert: Alert?
        public var isLoading: Bool
        public var pinLength: Int
        public var currentCount: Int
        public var enterPin: (String) -> Void
        public var deleteButton: DeleteButton
        public var backButton: BackButton
        
        public init(
            title: NSMutableAttributedString = .init(string: ""),
            alert: Alert? = nil,
            isLoading: Bool = false,
            pinLength: Int = 0,
            currentCount: Int = 0,
            enterPin: @escaping (String) -> Void = { _ in },
            deleteButton: DeleteButton = .init(),
            backButton: BackButton = .init()
        ) {
            self.title = title
            self.alert = alert
            self.isLoading = isLoading
            self.pinLength = pinLength
            self.currentCount = currentCount
            self.enterPin = enterPin
            self.deleteButton = deleteButton
            self.backButton = backButton
        }
    }
    
    private var viewProperties: ViewProperties
    
    // MARK: - UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dotsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }()
    
    private var dotViews: [UIView] = []
    
    private lazy var keyboardStackView: UIStackView = {
        let leftStackView = createVerticalStack([
            pinButtons[1],
            pinButtons[4],
            pinButtons[7]
        ])
        let middleStackView = createVerticalStack([
            pinButtons[2],
            pinButtons[5],
            pinButtons[8],
            pinButtons[0]
        ])
        let rightStackView = createVerticalStack([
            pinButtons[3],
            pinButtons[6],
            pinButtons[9],
            deleteButton
        ])
        let mainStackView = createHorizontalStack([
            leftStackView,
            middleStackView,
            rightStackView
        ])
        return mainStackView
    }()
    
    private lazy var pinButtons: [UIButton] = {
        return (0...9).map { number -> UIButton in
            let button = UIButton()
            button.setTitle("\(number)", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            button.backgroundColor = .lightGray
            button.layer.cornerRadius = 30
            button.snp.makeConstraints {
                $0.size.equalTo(60)
            }
            button.addTarget(self, action: #selector(pinButtonTapped(_:)), for: .touchUpInside)
            return button
        }
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("⌫", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.layer.cornerRadius = 30
        button.snp.makeConstraints {
            $0.size.equalTo(60)
        }
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }()
    
    // MARK: - init
    
    public init(
        viewProperties: ViewProperties
    ) {
        self.viewProperties = viewProperties
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupNavBar()
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(dotsStackView)
        view.addSubview(keyboardStackView)
        view.addSubview(activityIndicator)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(120)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        dotsStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        keyboardStackView.snp.makeConstraints {
            $0.top.equalTo(dotsStackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupNavBar() {
        let barItem = UIBarButtonItem(
            image: viewProperties.backButton.icon,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = barItem
    }
    
    // MARK: - public method
    
    public func update(with viewProperties: ViewProperties) {
        titleLabel.attributedText = viewProperties.title
        createDotViews(pinLength: viewProperties.pinLength)
        updateDotViews(currentCount: viewProperties.currentCount)
        updateDeleteButton(viewProperties.deleteButton.isHidden)
        updateActivityIndicator(viewProperties.isLoading)
        showErrorAlert(viewProperties.alert)
        self.viewProperties = viewProperties
    }
    
    // MARK: - private method
    
    private func createDotViews(pinLength: Int) {
        guard pinLength != dotViews.count else { return }
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews = (0..<pinLength).map { _ in
            let view = UIView()
            view.backgroundColor = .lightGray
            view.layer.cornerRadius = 5
            view.snp.makeConstraints {
                $0.width.height.equalTo(10)
            }
            return view
        }
        dotViews.forEach { dotsStackView.addArrangedSubview($0) }
    }
    
    private func updateDotViews(currentCount: Int) {
        dotViews.enumerated().forEach { index, view in
            view.backgroundColor = index < currentCount ? .black : .lightGray
        }
    }
    
    private func updateDeleteButton(_ isHidden: Bool) {
        deleteButton.isHidden = isHidden
    }
    
    private func updateActivityIndicator(_ isLoading: Bool) {
        view.isUserInteractionEnabled = !isLoading
        isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
    
    private func showErrorAlert(_ alert: ViewProperties.Alert?) {
        guard let alert else { return }
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: alert.buttonTitle,
            style: .default
        ) { [weak self] _ in
            guard let self else { return }
            self.errorAlertButtonTapped()
        }
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func createVerticalStack(_ arrangedSubviews: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        return stackView
    }
    
    private func createHorizontalStack(_ arrangedSubviews: [UIStackView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .top
        stackView.spacing = 10
        return stackView
    }
    
    // MARK: Actions
    
    @objc private func pinButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal), !title.isEmpty else { return }
        sender.backgroundColor = .gray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            sender.backgroundColor = .lightGray
        }
        viewProperties.enterPin(title)
    }
    
    @objc private func deleteButtonTapped() {
        viewProperties.deleteButton.onTap()
    }
    
    private func errorAlertButtonTapped() {
        viewProperties.alert?.buttonTapped()
    }
    
    @objc private func backButtonTapped() {
        viewProperties.backButton.onTap()
    }
    
    // MARK: Deinit
    
    deinit {
        print("💀 удалился ChangePinVC")
    }
}
