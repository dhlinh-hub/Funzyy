//
//  CustomXibViewSupport.swift
//  FtechSDK
//
//  Created by Edric D. on 08/08/2021.
//

import UIKit

protocol CustomXibViewSupport {
    var nibName: String { get }
    var containerView: UIView { get }
    func loadViews()
}

extension CustomXibViewSupport where Self: UIView {
    func loadViews() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(containerView)
        constraintsContainerView()
    }
    
    private func constraintsContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        [NSLayoutConstraint(item: containerView,
                            attribute: .leading,
                            relatedBy: .equal,
                            toItem: self,
                            attribute: .leading,
                            multiplier: 1, constant: 0),
         NSLayoutConstraint(item: containerView,
                            attribute: .top,
                            relatedBy: .equal,
                            toItem: self,
                            attribute: .top,
                            multiplier: 1, constant: 0),
         NSLayoutConstraint(item: containerView,
                            attribute: .trailing,
                            relatedBy: .equal,
                            toItem: self,
                            attribute: .trailing,
                            multiplier: 1, constant: 0),
         NSLayoutConstraint(item: containerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: self,
                            attribute: .bottom,
                            multiplier: 1, constant: 0)].forEach { $0.isActive = true }
    }
}

class CustomXibView: UIView, CustomXibViewSupport {
    @IBOutlet internal var _containerView: UIView!
    
    var nibName: String {
        return String(describing: type(of: self))
    }
    
    var containerView: UIView {
        if _containerView == nil {
            fatalError("_containerView is not connected to XIB with name \"\(nibName)\"")
        }
        
        return _containerView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViews()
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViews()
        configViews()
    }
    
    internal func configViews() {
        
    }
}
