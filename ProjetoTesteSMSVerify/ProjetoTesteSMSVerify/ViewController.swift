//
//  ViewController.swift
//  ProjetoTesteSMSVerify
//
//  Created by Luciano Pezzin on 13/11/2018.
//  Copyright © 2018 Luciano Pezzin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    private static let baseURLString = "https://api.authy.com/protected/json"
    
    static let path = Bundle.main.path(forResource: "apiKey", ofType: "plist")
    static let keys = NSDictionary(contentsOfFile: path!)
    static let apiKey = keys!["apiKey"] as! String
    
    @IBOutlet var countryCodeField: UITextField! = UITextField()
    @IBOutlet var phoneNUmberField: UITextField! = UITextField()
    
    @IBAction func sendVerification() {
        if let phoneNumber = phoneNUmberField.text,
            let countryCode = countryCodeField.text {
            ViewController.sendVerificationCode(countryCode, phoneNumber)
        }
    }
    
    static func sendVerificationCode(_ countryCode: String, _ phoneNumber: String) {
        
        let parameters = [
            "api_key": apiKey,
            "via": "sms",
            "country_code": countryCode,
            "phone_number": phoneNumber
        ]
        
        let path = "phones/verification/start"
        let method = "POST"
        
        let urlPath = "\(baseURLString)/\(path)"
        var components = URLComponents(string: urlPath)!
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        components.queryItems = queryItems
        
        let url = components.url!
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-Authy-API-Key")
        request.httpMethod = method
        
        let session: URLSession = {
            let config = URLSessionConfiguration.default
            return URLSession(configuration: config)
        }()
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            if let data = data {
                do {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    print(jsonSerialized!)
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }

}

