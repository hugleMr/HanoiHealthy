//
//  TodayViewController.swift
//  AQI Widget
//
//  Created by hung le on 12/25/17.
//  Copyright © 2017 hung le. All rights reserved.
//

import UIKit
import NotificationCenter
import SwiftSoup

class TodayViewController: UIViewController, NCWidgetProviding {
    
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
        
    @IBOutlet weak var lbl_real: UILabel!
    @IBOutlet weak var lbl_temp: UILabel!
    @IBOutlet weak var lbl_humidity: UILabel!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var lbl_aqi: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if fetchWeatherData(){
            print("load SUCCESS!")
        }
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        if fetchWeatherData(){
            print("refresh SUCCESS!")
        }
    }
    
    private func fetchWeatherData() -> Bool {
        let myURLString = "https://tso.unishanoi.org/aqi/"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return false
        }
        
        do {
            let html = try String(contentsOf: myURL, encoding: .utf8)
            
            do{
                let document: Document = try SwiftSoup.parseBodyFragment(html)
                
                //====== number
                let number = try document.select("[class=\(activedata_block)]")
                let number_text: String = (try number.toString().slice(from: "gauge.setValue(", to: ")"))!
                lbl_aqi.text = number_text
                
                //======= get status
                let status = try document.select("[class=\(activedata_block)]")
                let status_text = try status.select("h1").text()
                let int_number = Int(number_text)!
                var color = UIColor.black
                if(int_number >= 0 && int_number < 50){
                    color = UIColor(red: 0.33, green: 0.64, blue: 0.23, alpha: 1)
                }else if(int_number >= 50 && int_number < 100){
                    color = UIColor(red: 1, green: 0.99, blue: 0.22, alpha: 1)
                }else if(int_number >= 100 && int_number < 150){
                    color = UIColor(red: 0.96, green: 0.66, blue: 0.17, alpha: 1)
                }else if(int_number >= 150 && int_number < 200){
                    color = UIColor(red: 0.9, green: 0.37, blue: 0.33, alpha: 1)
                }else {
                    color = UIColor(red: 0.74, green: 0.33, blue: 0.59, alpha: 1)
                }
                
                lbl_status.textColor = color
                lbl_status.text = status_text
                
                //======= get os-percentages
                let element_os = try document.select("[class=\(os_percentages)]")
                var count_element_os = 0
                for element in element_os.array(){
                    count_element_os += 1
                    let text: String = try element.text()
                    if(count_element_os == 1){
                        lbl_humidity.text = text
                    }else if(count_element_os == 2){
                        lbl_temp.text = text
                    }else if(count_element_os == 3){
                        lbl_real.text = text
                    }
                }
                
                return true
                
            }catch Exception.Error( _, let message){
                print(message)
            }catch{
                print("error")
                return false
            }
        } catch let error {
            print("Error: \(error)")
            return false
        }
        
        return false
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        if fetchWeatherData() {
            print("Success: widgetPerformUpdate")
            completionHandler(NCUpdateResult.newData)
        }else{
            print("Error: widgetPerformUpdate")
            completionHandler(.failed)
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
