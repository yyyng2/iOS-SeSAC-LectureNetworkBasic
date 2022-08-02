//
//  TranslateViewController.swift
//  SeSAC2LectureNetworkBasic
//
//  Created by Y on 2022/07/28.
//

//UIResponderChain -> resignFirstResponder

import UIKit

import Alamofire
import SwiftyJSON

class TranslateViewController: UIViewController {

    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var userOutputTextView: UITextView!
    
    let textViewPlaceholderText = "번역하고 싶은 문장을 작성해보세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userInputTextView.delegate = self

        userInputTextView.text = textViewPlaceholderText
        userInputTextView.textColor = .lightGray
        userInputTextView.font = UIFont(name: "twayfly", size: 20)

    }
    
    func requestTranslateData(textFieldText: String){
        let url = EndPoint.translateURL
        

        let parameter = ["source": "ko", "target": "en", "text": textFieldText]
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .post, parameters: parameter, headers: header).validate(statusCode: 200..<300).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
//                let statusCode = response.response?.statusCode ?? 500
//                if statusCode == 200{
//
//                } else {
//                    self.userInputTextView.text = json["errorMessage"].stringValue
//                }
                
                let translate = json["message"]["result"]["translatedText"].stringValue
                self.userOutputTextView.text = translate
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        guard let text = userInputTextView.text else { return }
        requestTranslateData(textFieldText: text)
        
    }
    
    
    
}

extension TranslateViewController: UITextViewDelegate{
    //텍스트가 변할때마다 호출
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
    }
    
    //편집이 시작될 때, 커서가 나타날 때
    //텍스트뷰 글자: 플레이스 홀더와 글자가 같으면 clear, color
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    //편집이 끝났을 때, 커서가 없어질 때
    //텍스트뷰 글자: 아무글자 안썼으면 플레이스 홀더 글자 보임.
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textViewPlaceholderText
            textView.textColor = .lightGray
        }
    }
    
}
