//
//  StockUpdateDateCell.swift
//
//
//  Created by user on 11.06.2024.
//

import UIKit
import SnapKit
import Colors

public final class StockUpdateDateCell: UITableViewCell {
    
    public struct ViewProperties {
        public let text: String?
        public let accessibilityIdentifier: String?
        
        public init(
            text: String?, 
            accessibilityIdentifier: String? = nil
        ) {
            self.text = text
            self.accessibilityIdentifier = accessibilityIdentifier
        }
    }
    
    // MARK: - Private properties
    
    private lazy var containerView = UIView()
    
    private lazy var infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        
        return label
    }()
    
    // MARK: - Life cycle
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
        setupAccessibility()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        infoLabel.attributedText = nil
        infoImageView.image = nil
    }
    
    // MARK: - Methods
    
    public func configure(with properties: ViewProperties) {
        infoLabel.attributedText = properties.text?.textS(color: .contentPrimary)
        infoImageView.image = .ic24InfoCircleFilled.withTintColor(.contentSecondary)
        accessibilityIdentifier = properties.accessibilityIdentifier
    }
    
    // MARK: - Private methods

    private func commonInit() {
        contentView.addSubview(containerView)
        containerView.layer.cornerRadius = 8
        containerView.backgroundColor = .backgroundDisabled
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
        
        containerView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
        }
        
        containerView.addSubview(infoImageView)
        infoImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(12)
        }
    }
    
    private func setupAccessibility() {
        containerView.accessibilityIdentifier = "ContainerView"
        infoLabel.accessibilityIdentifier = "InfoLabel"
        infoImageView.accessibilityIdentifier = "InfoImageView"
    }
}
