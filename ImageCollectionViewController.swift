//
//  ImageCollectionViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by Y on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

private let reuseIdentifier = "Cell"


class ImageCollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let layer = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let witdh = UIScreen.main.bounds.width - (spacing * 4)
        layer.itemSize = CGSize(width: witdh / 3, height: witdh / 3)
        layer.scrollDirection = .vertical
        layer.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layer.minimumLineSpacing = spacing
        layer.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layer
        fetchImage()
        print(searchLinkArray)
    }
    
    var searchLinkArray: [String] = []
    var imageURL = "https://"
    
    func fetchImage(){
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=31"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")

                for arrayNum in json["items"].arrayValue{
                    self.searchLinkArray.append(arrayNum["link"].stringValue)
                }
                
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchLinkArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }

        cell.searchImageView.kf.setImage(with: URL(string: searchLinkArray[indexPath.row]))
        return cell
    }

}
