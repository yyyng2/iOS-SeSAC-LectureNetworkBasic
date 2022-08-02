//
//  LottoViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by Y on 2022/07/28.
//

import UIKit
// 1. import library
import Alamofire
import SwiftyJSON

class LottoViewController: UIViewController {
   
    @IBOutlet var numberLabelCollection: [UILabel]!
    @IBOutlet weak var bonusLabel: UILabel!
    

//    @IBOutlet weak var lottoPickerView: UIPickerView!
    @IBOutlet weak var numberTextField: UITextField!
    var lottoPickerView = UIPickerView()
    
    var count = 0
    
    var numberList: [Int] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        numberTextField.inputView = lottoPickerView
        numberTextField.tintColor = .clear

        lottoPickerView.dataSource = self
        lottoPickerView.delegate = self
        
        dateCal()
        requestLotto(number: count)
        numberList = Array(1...count).reversed()
    }
    
    func dateCal(){
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter2.date(from: "2002-07-14") ?? Date()
        let endDate = Date()

        let interval = endDate.timeIntervalSince(startDate)
        let days = Int(interval / 86400)
        count = Int((days/7) - 20)
        print(count)
    }

    func requestLotto(number: Int){
        
        //AF = 200~299 status code
        //만약 status code 200~399까지 성공으로 취급하고싶다면 validate(statusCode: 200..<400)
        
        let url = "\(EndPoint.lottoURL)&drwNo=\(number)"
        
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let bonus = json["bnusNo"].intValue
                self.bonusLabel.text = "\(bonus)"
                
                let date = json["drwNoDate"].stringValue
                print(date)
                
                self.numberTextField.text = date
                for tag in 0..<self.numberLabelCollection.count{
                    self.numberLabelCollection[tag].text = "\(json["drwtNo\(tag+1)"].intValue)"
                    print("drwtNo\(tag+1)")
                }
                
                //회차 오류 대응 with 관규님
                if json["returnValue"].stringValue == "fail" {
                    let newCount = self.count - 1
                    self.count = newCount
                    self.requestLotto(number: self.count)
                }
                
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestLotto(number: numberList[row])
        //numberTextField.text = "\(numberList[row])회차"
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
}
