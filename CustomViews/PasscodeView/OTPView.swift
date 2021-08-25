//
//  OTPView.swift
//  App
//
//  Created by Edric D. on 18/06/2021.
//

import UIKit

public class OTPView: CodeInputView {
    @IBInspectable
    public var font: UIFont = UIFont.systemFont(ofSize: 17) {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    public var emptyDashColor: UIColor = UIColor.black
    
    @IBInspectable
    public var dashColor: UIColor = UIColor.black
    
    @IBInspectable
    public var cellBackgroundColor: UIColor = UIColor.white
    
    @IBInspectable
    public var textColor: UIColor = .darkGray {
        didSet {
            invalidateLayout()
        }
    }
    
    public override var allowsDoubleTaps: Bool {
        get {
            return false
        } set { }
    }
    
    @available(iOS 10.0, *)
    public var textContentType: UITextContentType! {
        get {
            if #available(iOS 12.0, *) {
                return .oneTimeCode
            } else {
                return nil
            }
        }
        set { }
    }
    
    public override func emptyItemView(at index: Int) -> UIView {
        let item = ItemView()
        item.layer.masksToBounds = true
        item.layer.borderWidth = 1
        item.layer.cornerRadius = 5
        item.layer.borderColor = UIColor.darkGray.cgColor
        item.text = nil
        item.textColor = textColor
        item.font = font
        item.dashColor = emptyDashColor
        item.backgroundColor = cellBackgroundColor
        return item
    }
    
    public override func itemView(at index: Int) -> UIView {
        let item = ItemView()
        item.layer.masksToBounds = true
        item.layer.borderWidth = 1
        item.layer.cornerRadius = 5
        item.layer.borderColor = UIColor.blue.cgColor
        item.text = text(at: index)
        item.textColor = textColor
        item.font = font
        item.dashColor = dashColor
        item.backgroundColor = cellBackgroundColor
        return item
    }
    
    public override func secureItemView(at index: Int) -> UIView {
        return UIView()
    }
    
    private func text(at index: Int) -> String? {
        guard !code.isEmpty else { return nil }
        return code.map({ String($0) })[index]
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        code = "123"
    }
}

extension OTPView {
    class ItemView: UIView {
        var text: String? {
            didSet {
                label.text = text
            }
        }
        
        var font: UIFont? {
            didSet {
                label.font = font
            }
        }
        
        var textColor: UIColor = UIColor.darkText {
            didSet {
                label.textColor = textColor
            }
        }
        
        var borderColor: UIColor = UIColor.gray {
            didSet {
                label.layer.borderColor = borderColor.cgColor
            }
        }
        
        
        var dashColor: UIColor = UIColor.darkGray {
            didSet {
                dashView.backgroundColor = dashColor
            }
        }
        
        private let label = UILabel()
        private let dashView = UIView()
        
        init() {
            super.init(frame: .zero)
            
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.adjustsFontSizeToFitWidth = true
            label.backgroundColor = .clear
            
            dashView.backgroundColor = dashColor
            dashView.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(label)
            
            addSubview(dashView)
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: leadingAnchor),
                label.trailingAnchor.constraint(equalTo: trailingAnchor),
                label.topAnchor.constraint(equalTo: topAnchor),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),

                dashView.heightAnchor.constraint(equalToConstant: 1),
                dashView.leadingAnchor.constraint(equalTo: leadingAnchor),
                dashView.trailingAnchor.constraint(equalTo: trailingAnchor),
                dashView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
