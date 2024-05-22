//
//  GibddFineView.swift
//
//
//  Created by user on 22.05.2024.
//

import UIKit
import DesignSystem
import Components

public class GibddFineView: UIView {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        let date: String?
        let saleDate: String?
        let status: String?
        let amount: String?
        let allAmount: String?
        let buttonViewProperties: ButtonView.ViewProperties
    }
    
    // MARK: - Private properties
    
    private let dateLabel = UILabel()
    private let saleDateLabel = UILabel()
    private let statusLabel = UILabel()
    private let amountLabel = UILabel()
    private let button = ButtonView()
    
    // MARK: - Life cycle
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Methods

    public func configure(with properties: ViewProperties) {
        dateLabel.attributedText = properties.date?.textM(color: .contentPrimary)
        saleDateLabel.attributedText = properties.saleDate?.textS(color: .contentSecondary)
        statusLabel.attributedText = properties.status?.textS(color: .contentSecondary)
        amountLabel.attributedText = properties.allAmount?.textS(color: .contentSecondary)
        button.update(with: properties.buttonViewProperties)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        addSubview(dateLabel)
        dateLabel.numberOfLines = .zero
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalToSuperview().inset(16)
        }
        
        addSubview(saleDateLabel)
        saleDateLabel.numberOfLines = .zero
        saleDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
        }
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(16)
            make.height.equalTo(24)
            make.width.equalTo(62)
        }
        
        addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(button.snp.bottom).offset(8)
        }
        
        addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(button.snp.centerY)
            make.trailing.equalTo(button.snp.leading).inset(-8)
        }
    }
}
