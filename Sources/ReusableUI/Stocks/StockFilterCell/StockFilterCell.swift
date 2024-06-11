//
//  StockFilterCell.swift
//
//
//  Created by user on 11.06.2024.
//

import UIKit
import SnapKit
import Colors

public protocol StocksFilterCellDelegate: AnyObject {
    func didSelectFilter(model: StocksListFilterModel)
}

public final class StocksFilterCell: UITableViewCell {
    
    // MARK: - Properties
    
    public struct ViewProperties {
        let collectionItems: [StocksListFilterModel]
        let selectedItem: StocksListFilterModel
        let firstButtonTitle: String?
        let secondButtonTitle: String?
        let thirdButtonTitle: String?
    }
    
    // MARK: - Private properties
    
    private var collectionItems: [StocksListFilterModel] = []
    private var selectedItem: StocksListFilterModel?
    public weak var delegate: StocksFilterCellDelegate?
    
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
            delegate?.didSelectFilter(model: collectionItems[0])
        }
    }
    
    @objc private func secondButtonTapAction() {
        firstButton.isSelected = false
        thirdButton.isSelected = false

        if !secondButton.isSelected {
            secondButton.isSelected.toggle()
            delegate?.didSelectFilter(model: collectionItems[1])
        }
    }
    
    @objc private func thirdButtonTapAction(_ button: UIButton) {
        secondButton.isSelected = false
        firstButton.isSelected = false

        if !thirdButton.isSelected {
            thirdButton.isSelected.toggle()
            delegate?.didSelectFilter(model: collectionItems[2])
        }
    }
}
