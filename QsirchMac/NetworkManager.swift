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
    @Published var filesToDisplay = false
    
    @Published var ReturnedErrors:ReturnedError?
    
    @Published var LoginReturned:LoginReturn?
    @Published var HardError:String?

    // MARK: - Login Method
    func login(hostname:String, port:String, username:String, password:String, completion: @escaping (LoginReturn?,ReturnedError?,String?) ->() ) {
        let semaphore = DispatchSemaphore(value: 1)
        guard let loginURL = URL(string: "https://\(hostname):\(port)/qsirch/static/api/login") else { return }
        DispatchQueue.global().async {
            //Begin Logout
            semaphore.wait()
            self.logout(hostname: hostname, port: port) { (LogoutReturn) in
                if (LogoutReturn != "200") {
                    completion(nil,nil,"Hostname Incorrect")
                    
                }
                semaphore.signal()
            }
            //End Logout
            //Begin Login
            semaphore.wait()
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
            semaphore.signal()
            //End Login
            //Begin Drive Aquisition
            
                
            //End Drive Aquisition
            
        }
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
        // Open dispatch queue
        // if login token exists
            // try search
                // if search returns not logged in error
                    // Display not logged in error
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
                        print(fileList)
                        if self.FileList!.total > 0 {
                            self.filesToDisplay = true
                        } else {
                            self.filesToDisplay = false
                        }
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
    // MARK: - Need to get available drives
    func drivesAvailable(hostname:String, port:String, completion: @escaping (DrivesAvailable?,ReturnedError?) -> () ) {
        guard let listDirURL = URL(string: "https://\(hostname):\(port)/qsirch/static/list-dirs") else { return }
        var request = URLRequest(url: listDirURL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard let data = data else { return }
                let httpResponse = response as? HTTPURLResponse
                switch httpResponse!.statusCode as Int {
                case 200:
                    let driveList = try! JSONDecoder().decode(DrivesAvailable.self, from: data)
                    completion(driveList,nil)
                case 400...500:
                    let returnedErrors = try JSONDecoder().decode(ReturnedError.self, from: data)
                    completion(nil,returnedErrors)
                    default: break
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
}








