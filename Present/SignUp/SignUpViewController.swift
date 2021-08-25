//
//  SignUpViewController.swift
//  Funzy
//
//  Created by Ishipo on 23/08/2021.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var phoneView: UIView!
    
    let vc = CountriesViewController()
    var isClick = false
    var data : Country? {
        didSet {
            if let data = data {
                dataImage.image = UIImage(named: "\(data.image)")
                dataLabel.text = data.dial_code
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGestureView()
        
        vc.backData = { data in
            self.data = data
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    
    func setupUI() {
        
        phoneView.borderView(radius: 5, borderColor: .lightGray, borderwith: 0.5)
        //
        verifyButton.borderView(radius: 5, borderColor: .lightGray, borderwith: 0.5)
        //
        countryView.borderView(radius: 5, borderColor: .lightGray, borderwith: 0.5)
        countryView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMinXMaxYCorner]
        
        
        
    }
    
    private func addGestureView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCountyView))
        countryView.addGestureRecognizer(tapGesture)
        countryView.isUserInteractionEnabled = true
        
    }
    
    @objc func tapCountyView() {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @available(iOS 13.0, *)
    @IBAction func pressVerifyButton(_ sender: Any) {
        
        if isClick {
            verifyButton.setImage(UIImage(systemName: ""), for: .normal)
        }else{
            verifyButton.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
        }
        isClick = !isClick
    }
    
}


