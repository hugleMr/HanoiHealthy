//
//  MainView.swift
//  Hanoi Healthy
//
//  Created by hung le on 12/24/17.
//  Copyright © 2017 hung le. All rights reserved.
//

import UIKit
import SwiftSoup

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

    override func viewDidLoad() {
        super.viewDidLoad()
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
