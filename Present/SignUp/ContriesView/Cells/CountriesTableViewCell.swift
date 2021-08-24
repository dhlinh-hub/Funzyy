//
//  CountriesTableViewCell.swift
//  Funzy
//
//  Created by Ishipo on 23/08/2021.
//

import UIKit

class CountriesTableViewCell: UITableViewCell {
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var dialLabel: UILabel!
    
    var data : Country? {
        didSet{
            if let data = data {
                countryImageView.image = UIImage(named: "\(data.image)")
                countryNameLabel.text = data.name
                dialLabel.text = data.dial_code
            }
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        countryImageView.layer.cornerRadius = 16
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
