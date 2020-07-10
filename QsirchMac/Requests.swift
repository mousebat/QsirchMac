//
//  PreferencesController.swift
//  QsirchMac
//
//  Created by Elliot Cater on 09/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation

func login(hostname:String, port:String, username:String, password:String, completion: @escaping (LoginReturn?,ReturnedError?,_ localisedError:String?) ->() ) {
    let settings = UserSettings()
    guard let loginURL = URL(string: "https://\(hostname):\(port)/qsirch/v4.3.2.1/api/login") else { return }
    
    var request = URLRequest(url: loginURL)
    request.httpMethod = "POST"
    let credentials = LoginRequest(account: username, password: password)
    let encoder = JSONEncoder()
    let jsonData = try! encoder.encode(credentials)
    request.httpBody = jsonData

    // Set HTTP Request Header
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        do {
            guard let data = data, error == nil else {
                completion(nil,nil,error!.localizedDescription)
                return
            }
            if (error == nil) {
                let httpResponse = response as? HTTPURLResponse
                switch httpResponse?.statusCode {
                case 200:
                    let loginResponse = try JSONDecoder().decode(LoginReturn.self, from: data)
                    settings.token = loginResponse.qqsSid
                    completion(loginResponse,nil,nil)
                //  GET TOKEN STORED!?
                case 400:
                    let loginResponse = try JSONDecoder().decode(ReturnedError.self, from: data)
                    completion(nil,loginResponse,nil)
                default:
                    completion(nil,nil,"Unknown Error")
                }
            }
        } catch let error {
            print("JSON Error \(error.localizedDescription)")
        }
    }
    task.resume()
}

func logout(hostname:String, port:String, completion: @escaping (String) -> () ) {
    guard let logoutURL = URL(string: "https://\(hostname):\(port)/qsirch/v4.3.2.1/api/logout") else { return }
    var request = URLRequest(url: logoutURL)
    request.httpMethod = "GET"
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        let httpResponse = response as? HTTPURLResponse
        if error != nil {
            completion(error!.localizedDescription)
        } else {
            let statuscode = String(httpResponse!.statusCode)
            completion(statuscode)
        }
    }
    task.resume()
}

func search(hostname:String, port:String, searchstring:String, token:String, completion: @escaping (SearchResults?, ReturnedError? , _ SearchError:String?) ->() ) {
    let searchStringURL = searchstring.stringByAddingPercentEncodingForFormData(plusForSpace: true)
    guard let searchURL = URL(string: "https://\(hostname):\(port)/qsirch/v4.3.2.1/api/search?q=\(searchStringURL ?? searchstring)&auth_token=\(token)") else { return }
    
    
    
    let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
        do {
            guard let data = data, error == nil else {
                completion(nil, nil, error!.localizedDescription)
                return
            }
            if (error == nil) {
                let httpResponse = response as? HTTPURLResponse
                switch httpResponse!.statusCode as Int {
                case 200:
                    let searchResults = try JSONDecoder().decode(SearchResults.self, from: data)
                    completion(searchResults, nil, nil)
                case 400...500:
                let searchResults = try JSONDecoder().decode(ReturnedError.self, from: data)
                    completion(nil,searchResults,nil)
                default:
                    completion(nil, nil, "Some Other Error")
                }
            }
        } catch let error {
            print("JSON Error \(error.localizedDescription)")
        }
    }
    task.resume()
}



