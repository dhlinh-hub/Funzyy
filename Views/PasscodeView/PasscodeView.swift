//
//  PasscodeView.swift
//  App
//
//  Created by Edric D. on 18/06/2021.
//
import UIKit

public class PasscodeView: CodeInputView {
    
    @IBInspectable
    public var font: UIFont = .systemFont(ofSize: 17) {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    public var emptyColor: UIColor = .lightGray {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    public var fillColor: UIColor = .darkGray {
        didSet {
            invalidateLayout()
        }
    }
    
    @IBInspectable
    public var textColor: UIColor = .darkGray {
        didSet {
            invalidateLayout()
        }
    }
    
    public override func emptyItemView(at index: Int) -> UIView {
        return CircleView(color: emptyColor)
    }
    
    public override func itemView(at index: Int) -> UIView {
        let item = UILabel()
        item.font = font
        item.text = text(at: index)
        item.textColor = textColor
        item.backgroundColor = .clear
        item.textAlignment = .center
        return item
    }
    
    public override func secureItemView(at index: Int) -> UIView {
        return CircleView(color: fillColor)
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

extension PasscodeView {
    
    class CircleView: UIView {
        
        let maskLayer = CAShapeLayer()
        
        init(color: UIColor) {
            super.init(frame: .zero)
            backgroundColor = color
            layer.mask = maskLayer
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            updateMaskLayer()
        }
        
        private func updateMaskLayer() {
            let diameter = min(bounds.width, bounds.height)
            maskLayer.frame = bounds
            maskLayer.fillColor = UIColor.black.cgColor
            
            let ovalRect = CGRect(x: 0,
                                  y: (bounds.height - diameter) / 2,
                                  width: diameter,
                                  height: diameter)
            maskLayer.path = UIBezierPath(ovalIn: ovalRect).cgPath
        }
    }

}

