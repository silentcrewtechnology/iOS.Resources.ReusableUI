//
//  StockCell.swift
//
//
//  Created by user on 11.06.2024.
//

import UIKit
import Colors
import Kingfisher
import FontService
import DesignSystem

public final class StockCell: UITableViewCell {
    
    public struct ViewProperties {
        public let stockModel: StockModel
        public let accessibilityIds: AccessibilityIds?

        public struct AccessibilityIds {
            public let id: String?
            public let logoImage: String?
            public let nameLabel: String?
            public let classcodeLabel: String?
            public let priceLabel: String?
            public var priceDynamicsLabelGreen: String?
            public let priceDynamicsLabelRed: String?
            
            public init(
                id: String?,
                logoImage: String?,
                nameLabel: String?,
                classcodeLabel: String?,
                priceLabel: String?,
                priceDynamicsLabelGreen: String?,
                priceDynamicsLabelRed: String?
            ) {
                self.id = id
                self.logoImage = logoImage
                self.nameLabel = nameLabel
                self.classcodeLabel = classcodeLabel
                self.priceLabel = priceLabel
                self.priceDynamicsLabelGreen = priceDynamicsLabelGreen
                self.priceDynamicsLabelRed = priceDynamicsLabelRed
            }
        }
        
        public init(
            stockModel: StockModel,
            accessibilityIds: AccessibilityIds? = nil
        ) {
            self.stockModel = stockModel
            self.accessibilityIds = accessibilityIds
        }
    }
    
    // MARK: - Private properties
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
 
        return label
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines
       
        return label
    }()

    private lazy var priceDynamicsLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines

        return label
    }()

    private lazy var classcodeLabel: UILabel = {
        let label = UILabel()
        label.contentMode = .left
        label.lineBreakMode = .byTruncatingTail
        label.baselineAdjustment = .alignBaselines

        return label
    }()
    
    // MARK: - Life cycle
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.attributedText = nil
        classcodeLabel.attributedText = nil
        priceLabel.attributedText = nil
        priceDynamicsLabel.attributedText = nil
        logoImage.image = nil
    }
    
    // MARK: - Methods
    
    public func configure(with properties: ViewProperties) {
        setupAccessibilityIds(with: properties)
        
        // TODO: - Перейти Currency
        nameLabel.attributedText = properties.stockModel.name?.attributed
            .fontStyle(.textL)
            .foregroundColor(.contentPrimary)
        classcodeLabel.attributedText = properties.stockModel.securcode?.attributed
            .fontStyle(.textM)
            .foregroundColor(.contentSecondary)
        
        if let priceDynamics = properties.stockModel.priceDynamics,
           let priceDynamicsInPercent = properties.stockModel.priceDynamicsInPercent {
            
            var textColor: UIColor
            
            if priceDynamicsInPercent >= 0 {
                textColor = .contentAction
                priceDynamicsLabel.accessibilityIdentifier = properties.accessibilityIds?.priceDynamicsLabelGreen
            }  else {
                textColor = .contentError
                priceDynamicsLabel.accessibilityIdentifier = properties.accessibilityIds?.priceDynamicsLabelRed
            }
            
            if let formattedPriceDynamicsInPercent = formatPercent(priceDynamicsInPercent) {
                priceDynamicsLabel.attributedText =
                "\(formatPrice(priceDynamics, 0)) ₽ (\(formattedPriceDynamicsInPercent))".attributed
                    .fontStyle(.textL)
                    .foregroundColor(textColor)
            }
        }
        
        if let price = properties.stockModel.price {
            let formattedPrice = formatPrice(price)
            priceLabel.attributedText = "\(String(describing: formattedPrice)) ₽".attributed
                .fontStyle(.textL_1)
                .foregroundColor(.contentPrimary)
        }
        
        guard let stringUrl = properties.stockModel.imageUrl,
              let url = URL(string: stringUrl)
        else { return }
        logoImage.kf.setImage(with: url)
    }
    
    // MARK: - Private methods

    private func commonInit() {
        contentView.addSubview(logoImage)
        logoImage.layer.cornerRadius = 20
        logoImage.clipsToBounds = true
        logoImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(logoImage.snp.trailing).offset(16)
        }
        
        contentView.addSubview(classcodeLabel)
        classcodeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel.snp.leading)
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(nameLabel.snp.trailing).inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(priceDynamicsLabel)
        priceDynamicsLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupAccessibilityIds(with viewProperties: ViewProperties) {
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        logoImage.accessibilityIdentifier = viewProperties.accessibilityIds?.logoImage
        nameLabel.accessibilityIdentifier = viewProperties.accessibilityIds?.nameLabel
        classcodeLabel.accessibilityIdentifier = viewProperties.accessibilityIds?.classcodeLabel
        priceLabel.accessibilityIdentifier = viewProperties.accessibilityIds?.priceLabel
    }
    
    private func formatPrice(_ price: Decimal,
                             _ minimumFractionDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = 2
        return formatter.string(for: price) ?? "\(price)"
    }
    
    private func formatPercent(_ percent: Decimal) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.multiplier = 1
        
        guard let formattedString = formatter.string(for: percent) else {
            return nil
        }
        
        return formattedString.replacingOccurrences(of: " %", with: "%")
    }
}
