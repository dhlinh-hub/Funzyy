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
        dataImage.layer.cornerRadius = 16
        verifyButton.layer.cornerRadius = 5
        countryView.layer.borderWidth = 0.1
        countryView.layer.borderColor = UIColor.lightGray.cgColor
        
        //
        verifyButton.layer.borderWidth = 1
        verifyButton.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func addGestureView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCountyView))
        countryView.addGestureRecognizer(tapGesture)
        countryView.isUserInteractionEnabled = true
        
    }
    
    @objc func tapCountyView() {
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func pressVerifyButton(_ sender: Any) {
        
        if isClick {
            if #available(iOS 13.0, *) {
                verifyButton.setImage(UIImage(systemName: ""), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        }else{
            if #available(iOS 13.0, *) {
                verifyButton.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        }
        isClick = !isClick
    }
    
}


