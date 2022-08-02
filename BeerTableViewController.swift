//
//  BeerTableViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by Y on 2022/08/02.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class BeerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        tableView.reloadData()

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func requestBeer (nameLabel: UILabel, descriptionLabel: UILabel, imageView: UIImageView){
        let url = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let name = json[0]["name"].stringValue
                nameLabel.text = name
                print(name)

                let description = json[0]["description"].stringValue
                descriptionLabel.text = description
                
                let url = URL(string: json[0]["image_url"].stringValue)
                if url == nil{
                    imageView.image = UIImage(named: "beer.png")
                } else {
                    imageView.kf.setImage(with: url)
                }
                
                print(json[0]["image_url"].stringValue)
                
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerTableViewCell.identifier, for: indexPath) as? BeerTableViewCell else { return UITableViewCell() }
        
        requestBeer(nameLabel: cell.beerNameLabel, descriptionLabel: cell.beerDescriptionLabel, imageView: cell.beerImageView)

        return cell
    }

}
