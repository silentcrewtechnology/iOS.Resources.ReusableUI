//
//  StockFilterCell.swift
//
//
//  Created by user on 11.06.2024.
//

import UIKit
import SnapKit
import Colors

public final class StocksFilterCell: UITableViewCell {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        public let collectionItems: [StocksListFilterModel]
        public let selectedItem: StocksListFilterModel
        public let accessibilityIds: AccessibilityIds?
        public let onFilter: ((StocksListFilterModel) -> Void)?
        
        public struct AccessibilityIds {
            public let id: String?
            public let firstButtonSelected: String?
            public let firstButtonUnselected: String?
            public let secondButtonSelected: String?
            public let secondButtonUnselected: String?
            public let thirdButtonSelected: String?
            public let thirdButtonUnselected: String?

            public init(
                id: String?,
                firstButtonSelected: String?,
                firstButtonUnselected: String?,
                secondButtonSelected: String?,
                secondButtonUnselected: String?,
                thirdButtonSelected: String?,
                thirdButtonUnselected: String?
            ) {
                self.id = id
                self.firstButtonSelected = firstButtonSelected
                self.firstButtonUnselected = firstButtonUnselected
                self.secondButtonSelected = secondButtonSelected
                self.secondButtonUnselected = secondButtonUnselected
                self.thirdButtonSelected = thirdButtonSelected
                self.thirdButtonUnselected = thirdButtonUnselected
            }
        }
        
        public init(
            collectionItems: [StocksListFilterModel] = [],
            selectedItem: StocksListFilterModel = .ru,
            accessibilityIds: AccessibilityIds? = nil,
            onFilter: ((StocksListFilterModel) -> Void)? = nil
        ) {
            self.collectionItems = collectionItems
            self.selectedItem = selectedItem
            self.onFilter = onFilter
            self.accessibilityIds = accessibilityIds
        }
    }
    
    // MARK: - Private properties
    
    private var collectionItems: [StocksListFilterModel] = []
    private var selectedItem: StocksListFilterModel?
    private var viewProperties: ViewProperties = .init()
    
    private lazy var firstButton: StocksFilterSelectableButton = {
        let button = StocksFilterSelectableButton()
        button.addTarget(self, action: #selector(firstButtonTapAction), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var secondButton: StocksFilterSelectableButton = {
        let button = StocksFilterSelectableButton()
        button.addTarget(self, action: #selector(secondButtonTapAction), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var thirdButton: StocksFilterSelectableButton = {
        let button = StocksFilterSelectableButton()
        button.addTarget(self, action: #selector(thirdButtonTapAction), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Life cycle
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    // MARK: - Methods
    
    public func configure(with viewProperties: ViewProperties) {
        guard viewProperties.collectionItems.count == 3 else { return }
        
        self.viewProperties = viewProperties
        accessibilityIdentifier = viewProperties.accessibilityIds?.id
        
        collectionItems = viewProperties.collectionItems
        selectedItem = viewProperties.selectedItem
        
        firstButton.setTitle(collectionItems[0].title, for: .normal)
        secondButton.setTitle(collectionItems[1].title, for: .normal)
        thirdButton.setTitle(collectionItems[2].title, for: .normal)
        
        if selectedItem?.filterType == collectionItems[0].filterType {
            firstButton.isSelected = true
            secondButton.isSelected = false
            thirdButton.isSelected = false
        } else if selectedItem?.filterType == collectionItems[1].filterType {
            firstButton.isSelected = false
            secondButton.isSelected = true
            thirdButton.isSelected = false
        } else {
            firstButton.isSelected = false
            secondButton.isSelected = false
            thirdButton.isSelected = true
        }
        
        firstButton.accessibilityIdentifier = firstButton.isSelected
            ? viewProperties.accessibilityIds?.firstButtonSelected
            : viewProperties.accessibilityIds?.firstButtonUnselected
        
        secondButton.accessibilityIdentifier = secondButton.isSelected
            ? viewProperties.accessibilityIds?.secondButtonSelected
            : viewProperties.accessibilityIds?.secondButtonUnselected
        
        thirdButton.accessibilityIdentifier = thirdButton.isSelected
            ? viewProperties.accessibilityIds?.thirdButtonSelected
            : viewProperties.accessibilityIds?.thirdButtonUnselected
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        selectionStyle = .none
        addSubview()
        makeConstraints()
    }
    
    private func addSubview() {
        contentView.addSubview(firstButton)
        contentView.addSubview(secondButton)
        contentView.addSubview(thirdButton)
    }
    
    private func makeConstraints() {
        firstButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        secondButton.snp.makeConstraints { make in
            make.leading.equalTo(firstButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
        
        thirdButton.snp.makeConstraints { make in
            make.leading.equalTo(secondButton.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    @objc private func firstButtonTapAction() {
        secondButton.isSelected = false
        thirdButton.isSelected = false

        if !firstButton.isSelected {
            firstButton.isSelected.toggle()
            viewProperties.onFilter? (collectionItems[0])
        }
    }
    
    @objc private func secondButtonTapAction() {
        firstButton.isSelected = false
        thirdButton.isSelected = false

        if !secondButton.isSelected {
            secondButton.isSelected.toggle()
            viewProperties.onFilter? (collectionItems[1])
        }
    }
    
    @objc private func thirdButtonTapAction(_ button: UIButton) {
        secondButton.isSelected = false
        firstButton.isSelected = false

        if !thirdButton.isSelected {
            thirdButton.isSelected.toggle()
            viewProperties.onFilter? (collectionItems[2])
        }
    }
}
