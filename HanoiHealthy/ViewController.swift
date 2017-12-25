//
//  ViewController.swift
//  Hanoi Healthy
//
//  Created by hung le on 12/24/17.
//  Copyright © 2017 hung le. All rights reserved.
//

import UIKit
import SwiftSoup

class ViewController: MainView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var aqi_number: UILabel!
    @IBOutlet weak var lbl_time_updated: UILabel!
    @IBOutlet weak var lbl_source: UILabel!
    
    @IBOutlet weak var lbl_humidity: UILabel!
    @IBOutlet weak var lbl_temp: UILabel!
    @IBOutlet weak var lbl_real: UILabel!
    
    var refreshView: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshView = UIRefreshControl()
        //refreshView.attributedTitle = NSAttributedString(string : "Refresh")
        refreshView.tintColor = UIColor.white
        refreshView.bounds =  CGRect(x: refreshView.bounds.origin.x,
                                     y: -10,
                                     width: refreshView.bounds.size.width,
                                     height: refreshView.bounds.size.height);
        refreshView.addTarget(self, action: #selector(refreshControl(sender:)), for: UIControlEvents.valueChanged)
        self.scrollView.refreshControl = refreshView
        
        fetchWeatherData()
    }
    
    @objc func refreshControl(sender: UIRefreshControl){
        //aqi_number.text = ""
        fetchWeatherData()
    }

    private func fetchWeatherData() {
        let myURLString = "https://tso.unishanoi.org/aqi/"
        guard let myURL = URL(string: myURLString) else {
            print("Error: \(myURLString) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let html = try String(contentsOf: myURL, encoding: .utf8)
            
            do{
                let document: Document = try SwiftSoup.parseBodyFragment(html)
                
                //====== number
                let number = try document.select("[class=\(activedata_block)]")
                
                let number_text: String = (try number.toString().slice(from: "gauge.setValue(", to: ")"))!
                
                print(number_text)
                aqi_number.text = number_text
                
                //======= get status
                let status = try document.select("[class=\(activedata_block)]")
                let status_text = try status.select("h1").text()
                let status_text_split = status_text.split(separator: " ")
                var status_text_info = ""
                for status_text_item in status_text_split {
                    if(status_text_item == status_text_split.last){
                        status_text_info += status_text_item
                    }else{
                        status_text_info += status_text_item + "\n"
                    }
                }
                
                print(status_text)
                print("\n")
                
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
                lbl_status.text = status_text_info
                
                //======= get os percentages
                let element_os_percentages = try document.select("[class=\(activedata_description_data)]")
                for element in element_os_percentages.array(){
                    print("\(try element.text())")
                }
                print("\n")
                
                //======= get os-percentages
                let element_os = try document.select("[class=\(os_percentages)]")
                
                var count_element_os = 0
                for element in element_os.array(){
                    print("\(try element.text())")
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
                print("\n")
                
                //====== link name + info
                let link_x = try document.select("[class=\(activedata_description)]")
                let link_x_text = try link_x.select("p")
                var count_link_x = 0
                for element in link_x_text.array(){
                    count_link_x += 1
                    print("\(try element.text())")
                    let text: String = try element.text()
                    if(count_link_x == 1){
                        lbl_time_updated.text = text
                    }else if(count_link_x == 2){
                        lbl_source.text = text
                    }else if(count_link_x == 3){
                        //lbl_time_updated.text = text
                    }
                }
                print("\n")
                
                
                //====== link
                let link = try document.select("[class=\(activedata_description)]")
                let link_text = try link.select("a")
                print(try link_text.attr("href"))
                print("\n")
                
                //====== titular description
                let titular_status = try document.select("[class=\(aqiaction_block)]")
                let titular_status_text = try titular_status.select("h2")
                print(try titular_status_text.text())
                print("\n")
                
                //======implication
                let implication = try titular_status.select("[class=\(implication_data)]")
                let implication_desciption = try implication.text().split(separator: ":")
                if implication_desciption.count > 1 {
                    let title_impli = implication_desciption[0]
                    let description_impli = implication_desciption[1]
                    print("\(title_impli) ->: \(description_impli)")
                }else{
                    print(try implication.text())
                }
                
                //====== implication
                let advisory = try titular_status.select("[class=\(advisory_data)]")
                let advisory_desciption = try advisory.text().split(separator: ":")
                if advisory_desciption.count > 1 {
                    let title_advisory = advisory_desciption[0]
                    let description_advisory = advisory_desciption[1]
                    print("\(title_advisory) : \(description_advisory)")
                }else{
                    print(try advisory.text())
                }
                
                //====== response_data
                let response = try titular_status.select("[class=\(response_data)]")
                let response_desciption = try response.text().split(separator: ":")
                if response_desciption.count > 1 {
                    let title_response = response_desciption[0]
                    let description_response = response_desciption[1]
                    print("\(title_response) : \(description_response)")
                }else{
                    print(try response.text())
                }
                
                //========
                
                refreshView.endRefreshing()
                
            }catch Exception.Error( _, let message){
                print(message)
            }catch{
                print("error")
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
}

