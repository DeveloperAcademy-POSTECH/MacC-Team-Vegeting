//
//  RadioCheckButton.swift
//  Vegeting
//
//  Created by 최동권 on 2022/11/17.
//

import UIKit

final class RadioCheckButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setImage(UIImage(systemName: "circle"), for: .normal)
        self.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
