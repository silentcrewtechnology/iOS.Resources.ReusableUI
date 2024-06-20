//
//  PensionEsiaEntryVC.swift
//  ABOL
//
//  Created by Ilnur Mugaev on 06.09.2022.
//  Copyright © 2022 ps. All rights reserved.
//

import UIKit
import ImagesService

public final class PensionEsiaEntryVC: UIViewController, ViewControllerRules {
    
    typealias Presenter = PensionEsiaEntryPresenter
    typealias ViewState = PensionEsiaEntryViewState
    
    let presenter: Presenter
    
    public var idsReceived: ((_ sessionId: String, _ userId: String) -> Void)?
    
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.image =  .ic24Book
        view.contentMode = .center
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Зайдите на Госуслуги"
        label.textColor = .contentPrimary
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .contentSecondary
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.addSubview(iconView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        
        iconView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(iconView.snp.bottom).offset(24)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        return view
    }()
    
    private lazy var esiaEntryButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor(hexString: "#0D4CD3").cgColor
        button.layer.cornerRadius = 8.0
        button.setTitle("Войти через Госуслуги", for: .normal)
        button.setTitleColor(UIColor(hexString: "#0D4CD3"), for: .normal)
        button.titleLabel?.font = .textM
        button.setImage(.ic24Book.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.addTarget(self, action: #selector(esiaEntryButtonTapped), for: .touchUpInside)
        button.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        return button
    }()
    
    public init(
        request: URLRequest,
        entryType: PensionEsiaEntryPresenter.EntryType
    ) {
        self.presenter = .init(
            request: request,
            entryType: entryType)
        super.init(nibName: nil, bundle: nil)
        subtitleLabel.text = entryType.subtitle
        presenter.viewController = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupView()
        setupNavBar()
        
        presenter.handle(.viewDidLoad)
    }
    
    // MARK: - Rules
    
    func setViewState(_ viewState: ViewState) {
        
        if viewState.errorAlertVisible {
            presentErrorAlert()
        }
    }
    
    // MARK: - Setup
    
    private func setupView() {
        
        let insetView = UIView()
        insetView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(insetView)
        view.addSubview(esiaEntryButton)
        
        insetView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
        
        esiaEntryButton.snp.makeConstraints {
            $0.top.equalTo(insetView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.snp.bottomMargin).inset(16)
        }
    }
    
    private func setupNavBar() {
        let barItem = UIBarButtonItem(
            image: .ic24Close,
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped))
        navigationItem.leftBarButtonItem = barItem
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonTapped() {
        presenter.handle(.closeButtonTapped)
    }
    
    @objc private func esiaEntryButtonTapped() {
        presenter.handle(.esiaEntryButtonTapped)
    }
    
    private func presentErrorAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "Что-то пошло не так",
            preferredStyle: .alert)
        alert.addAction(.init(
            title: "Понятно",
            style: .default,
            handler: { [weak self] _ in
                self?.presenter.handle(.errorOptionTapped(.ok))
            }))
        alert.addAction(.init(
            title: "Повторить",
            style: .default,
            handler: { [weak self] _ in
                self?.presenter.handle(.errorOptionTapped(.retry))
            }))
        alert.preferredAction = alert.actions.last
        present(alert, animated: true)
    }
}
