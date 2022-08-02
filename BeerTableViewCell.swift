//
//  BeerTableViewCell.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by Y on 2022/08/02.
//

import UIKit

class BeerTableViewCell: UITableViewCell {

    static var identifier = "BeerTableViewCell"
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        beerNameLabel.font = .boldSystemFont(ofSize: 14)
        beerDescriptionLabel.font = .systemFont(ofSize: 12)
        beerDescriptionLabel.numberOfLines = 0
    }

}
