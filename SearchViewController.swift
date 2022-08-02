//
//  SearchViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by Y on 2022/07/27.
//

import UIKit

import Alamofire
import SwiftyJSON

extension UIViewController{
    func setBackgroundColor(){
        view.backgroundColor = .systemMint
    }
}

//protocol(Delegate/DataSource)

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    var list: [BoxOfficeModel] = []
    
    var date = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundColor()
        searchTableView.backgroundColor = .clear
        //연결고리 작업: 테이블뷰가 해야할 역할을 뷰컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        //테이블뷰가 사용할 테이블뷰 셀(XIB) 등록
        //XIB: xml interface builder // 이전 NIB //파일이름이나 identifier
        searchTableView.register(UINib(nibName: ListSearchTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListSearchTableViewCell.reuseIdentifier)
        dateCal()
        requestBoxOffice(text: date)
        searchBar.delegate = self
        //서치바 채택한 delegate 연결 해야함
    }
    
    func dateCal(){
        let today = Date()
        let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        date =  dateFormatter.string(from: yesterDay)
        print(yesterDay)
    }
    
    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 60
    }
    
    func requestBoxOffice(text: String){
        
        list.removeAll()
        
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
             
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue{
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    
                    let data = BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc)
                    
                    self.list.append(data)
                    
                }
                
//                let movieNm0 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                let movieNm1 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                let movieNm2 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
//
//                self.list.append(movieNm0)
//                self.list.append(movieNm1)
//                self.list.append(movieNm2)
                
                self.searchTableView.reloadData()
                print(self.list)
                
            case .failure(let error):
                print(error)
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListSearchTableViewCell.reuseIdentifier, for: indexPath) as? ListSearchTableViewCell
     else { return UITableViewCell() }
    
        cell.backgroundColor = .clear
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle) : \(list[indexPath.row].releaseDate)"
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(text: searchBar.text!)
    }
}
