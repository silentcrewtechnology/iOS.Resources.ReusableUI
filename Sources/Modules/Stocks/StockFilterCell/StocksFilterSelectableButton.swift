//
//  StocksFilterSelectableButton.swift
//
//
//  Created by user on 11.06.2024.
//

import UIKit

public class StocksFilterSelectableButton: UIButton {
    public override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .backgroundAction : .backgroundPrimary
            setTitleColor(isSelected ? .white : .contentSecondary, for: .normal)
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        let width = super.intrinsicContentSize.width + titleEdgeInsets.left + titleEdgeInsets.right
        
        return CGSize(width: width, height: 34)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 17
        setTitleColor(.contentSecondary, for: .normal)
        setTitleColor(.white, for: .selected)
        titleLabel?.font = .systemFont(ofSize: 15)
        backgroundColor = .backgroundPrimary
        titleEdgeInsets.left = 16
        titleEdgeInsets.right = 16
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
