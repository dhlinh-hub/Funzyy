//
//  NextButton.swift
//  FtechSDK
//
//  Created by Edric D. on 10/08/2021.
//

import UIKit

public class NextButton: UIButton {
    
    @IBInspectable
    open var title: String? {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    @IBInspectable
    open var titleNormalColor: UIColor = .white {
        didSet {
            self.setTitleColor(titleNormalColor, for: .normal)
        }
    }
    
    @IBInspectable
    open var titleDisableColor: UIColor = .white.withAlphaComponent(0.5) {
        didSet {
            self.setTitleColor(titleDisableColor, for: .disabled)
        }
    }
    
    @IBInspectable
    open var enable: Bool = false {
        didSet {
            self.isEnabled = enable
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 18)
        self.setTitleColor(UIColor.white, for: .disabled)
        self.backgroundColor = UIColor.init(hex: "1080EC")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
    }
    
    public override var isEnabled: Bool {
        didSet {
            self.backgroundColor = self.isEnabled
                ? UIColor.init(hex: "516BFF") : UIColor.init(hex: "516BFF").withAlphaComponent(0.5)
        }
    }
}
