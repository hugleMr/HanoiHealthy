//
//  AirVisualController.swift
//  HanoiHealthy
//
//  Created by hung le on 1/17/18.
//  Copyright © 2018 hung le. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AirVisualController: MainView {
    
    let countries = "countries?"
    let states = "states?country=VietNam&"
    let earest_city = "earest_city?"
    let special_city = "city?city=Hanoi&state=Hanoi&country=VietNam&"
    let list_cities = "cities?state=Ho%20Chi%20Minh&country=VietNam&"
    let hcm = "city?city=Ho Chi Minh&state=Ho Chi Minh&country=VietNam&"
    let dn = "city?city=Da Nang&country=VietNam&"
    let hnam = "city?city=HaNam&state=HaNam&country=VietNam&"

    @IBOutlet weak var scroll_view: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWeather();
    }
    
    func fetchWeather(){
        
        getDataFromJson(url: list_cities, parameters: nil, completion: { response in
            if let data = response.result.value{
                let swiftyJsonVar = JSON(data)
                print(swiftyJsonVar)
             }
        })
    }

}
