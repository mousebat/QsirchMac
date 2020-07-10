//
//  PreferencesController.swift
//  QsirchMac
//
//  Created by Elliot Cater on 09/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation

func login(hostname:String, port:String, username:String, password:String, completion: @escaping (LoginReturn,LoginError) ->() ) {
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

        if let error = error {
            print("Error took place \(error)")
            return
        }
        guard let data = data else {return}

        do{
            let loginReturn = try JSONDecoder().decode(LoginReturn.self, from: data)
            print("todoItemModel Title: \(loginReturn)")

        } catch let jsonErr{
            print(jsonErr)
        }


    }
    task.resume()
}
