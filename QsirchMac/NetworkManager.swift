//
//  NetworkManager.swift
//  QsirchMac
//
//  Created by Elliot Cater on 09/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation
import Combine

class NetworkManager: ObservableObject {
    @Published var FileList:SearchResults?
    @Published var ReturnedErrors:ReturnedError?
    @Published var filesToDisplay = false
    
    // MARK: - Login Method
    func login(hostname:String, port:String, username:String, password:String, completion: @escaping (LoginReturn?,ReturnedError?,String?) ->() ) {
        guard let loginURL = URL(string: "https://\(hostname):\(port)/qsirch/static/api/login") else { return }
        
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
                guard let data = data, let response = response else { return }
                let httpResponse = response as? HTTPURLResponse
                switch httpResponse?.statusCode {
                    case 200:
                        let loginResponse = try JSONDecoder().decode(LoginReturn.self, from: data)
                        completion(loginResponse,nil,nil)
                    case 400:
                        let loginResponse = try JSONDecoder().decode(ReturnedError.self, from: data)
                        completion(nil,loginResponse,nil)
                    default:
                        completion(nil,nil,"Unknown Error")
                }
            } catch {
                completion(nil,nil,error.localizedDescription)
            }
        }
        task.resume()
    }
    // MARK: - Logout Method
    func logout(hostname:String, port:String, completion: @escaping (String) -> () ) {
        guard let logoutURL = URL(string: "https://\(hostname):\(port)/qsirch/static/api/logout") else { return }
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
    // MARK: - Search Method
    func search(hostname:String, port:String, searchstring:String, token:String) {
        //Safely Construct URL
        var components = URLComponents()
        components.scheme = "https"
        components.host = hostname
        components.port = Int(port)
        components.path = "/qsirch/static/api/search"
        components.queryItems = [
            URLQueryItem(name: "q", value: searchstring.stringByAddingPercentEncodingForFormData(plusForSpace: true)),
            URLQueryItem(name: "auth_token", value: token)
        ]
        // Make sure URL actually got constructed
        guard let searchURL = components.url else { return }
        let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
            do {
                guard let data = data else { return }
                let httpResponse = response as? HTTPURLResponse
                switch httpResponse!.statusCode as Int {
                case 200:
                    let fileList = try! JSONDecoder().decode(SearchResults.self, from: data)
                    DispatchQueue.main.async {
                        self.FileList = fileList
                        self.filesToDisplay = true
                    }
                case 400...500:
                    let returnedErrors = try JSONDecoder().decode(ReturnedError.self, from: data)
                    DispatchQueue.main.async {
                        self.ReturnedErrors = returnedErrors
                    }
                default: break
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}








