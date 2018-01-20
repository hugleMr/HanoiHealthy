//
//  MainView.swift
//  Hanoi Healthy
//
//  Created by hung le on 12/24/17.
//  Copyright © 2017 hung le. All rights reserved.
//

import UIKit
import SwiftSoup
import Alamofire

class MainView: UIViewController {
    
    let activedata_description_data = "scnd-font-color"
    let activedata_description = "activedata-description"
    let os_percentages = "os-percentage"
    let humidity = "humidity os scnd-font-color"
    let temp = "temp os scnd-font-color"
    let real = "eal os scnd-font-color"
    
    let titular = "titular"
    let aqiaction_block = "aqiaction block"
    let activedata_block = "activedata block"
    let implication_data = "implication"
    let advisory_data = "advisory"
    let response_data = "response"
    
    let activedata_aqi_gauge = "activedata-aqi  gauge"
    
    let headers: [String: String] = ["api_key" : "uis5npWMPC6qkzXFb"]
    let api_key: String = "uis5npWMPC6qkzXFb"
    let domain: String = "http://api.airvisual.com/v2/"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension MainView {
    func getDataFromJson(url: String,parameters:Parameters?, completion: @escaping (_ success: DataResponse<Any>) -> Void) {
        
        let myUrl: String = domain + url + "key=" + api_key;
        
        Alamofire.request(myUrl, method: HTTPMethod.get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            //self.hideLoading(uiView: self.view);
            completion(response)
        }
        
    }
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}
