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
    
    @Published var FileList:SearchReturn?
    @Published var filesToDisplay:Bool = false
    
    @Published var progressIndicator:Bool = false
    
    @Published var DrivesList:DriveListReturn?
    @Published var drivesToDisplay:Bool = false
    
    @Published var ErrorReturned:String?
    @Published var displayError:Bool = false
    
    @Published var LoginReturned:LoginReturn?
    @Published var displayLogin:Bool = false
    
    
    @Published var hostname:String { didSet { UserDefaults.standard.string(forKey: "hostname") } }
    @Published var username:String { didSet { UserDefaults.standard.string(forKey: "username") } }
    @Published var password:String { didSet { UserDefaults.standard.string(forKey: "password") } }
    @Published var port:String { didSet { UserDefaults.standard.string(forKey: "port") } }
    @Published var token:String = ""
    
    @Published var drive:String = "All"
    @Published var results:String = "25"
    @Published var sortby:String = "relevance"
    @Published var sortdir:String = "default"
    
    @Published var searchField:String = ""
    
    private var cancellable: AnyCancellable? = nil
    init() {
        self.hostname = UserDefaults.standard.object(forKey: "hostname") as? String ?? ""
        self.username = UserDefaults.standard.object(forKey: "username") as? String ?? ""
        self.password = UserDefaults.standard.object(forKey: "password") as? String ?? ""
        self.port = UserDefaults.standard.object(forKey: "port") as? String ?? ""
        // Try search!  Works!
        cancellable = AnyCancellable(
        $searchField
            .removeDuplicates()
            .debounce(for: 0.8, scheduler: DispatchQueue.main)
            .sink { searchText in
                self.search(searchstring: self.searchField,
                            path: self.drive,
                            results: self.results,
                            sortby: self.sortby,
                            sortdir: self.sortdir)
            }
        )
        
    }
    deinit {
        cancellable?.cancel()
    }
    
    
    
    // MARK: - Login Method
    func login(hostname:String, port:String, username:String, password:String) {
        DispatchQueue.main.async {
            self.displayError = false
            self.displayLogin = false
            self.progressIndicator = true
        }
        let semaphore = DispatchSemaphore(value: 1)
        guard let loginURL = URL(string: "https://\(hostname):\(port)/qsirch/static/api/login") else { return }
        guard let logoutURL = URL(string: "https://\(hostname):\(port)/qsirch/static/api/logout") else { return }
        
        DispatchQueue.global().async {
            //Begin Logout
            semaphore.wait()
            var logoutrequest = URLRequest(url: logoutURL)
            logoutrequest.httpMethod = "GET"
            let logoutTask = URLSession.shared.dataTask(with: logoutURL) { _, _, error in
                if let error = error {
                    DispatchQueue.main.async {
                        self.progressIndicator = false
                        self.ErrorReturned = error.localizedDescription
                        self.displayError = true
                    }
                    return
                }
                semaphore.signal()
            }
            logoutTask.resume()
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
            let loginTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    if let error = error {
                        DispatchQueue.main.async {
                            self.ErrorReturned = error.localizedDescription
                            self.progressIndicator = false
                            self.displayError = true
                        }
                        return
                    }
                    if let response = response as? HTTPURLResponse, let data = data {
                        if response.statusCode == 200 {
                            let decodedData = try JSONDecoder().decode(LoginReturn.self, from: data)
                            DispatchQueue.main.async {
                                //self.token = decodedData.qqsSid <- might be able to just call this from the below!
                                self.LoginReturned = decodedData
                                self.progressIndicator = false
                                self.displayLogin = true
                            }
                        }
                        if response.statusCode >= 400 {
                            let decodedData = try JSONDecoder().decode(ErrorReturn.self, from: data)
                            DispatchQueue.main.async {
                                self.ErrorReturned = decodedData.error.message
                                self.progressIndicator = false
                                self.displayError = true
                            }
                            return
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.ErrorReturned = error.localizedDescription
                        self.progressIndicator = false
                        self.displayError = true
                    }
                    return
                }
                semaphore.signal()
            }
            loginTask.resume()
            semaphore.wait()
            //End Login
            //Begin Drive Aquisition
            guard let listDirURL = URL(string: "https://\(hostname):\(port)/qsirch/static/api/list-dirs") else { return }
            var driveRequest = URLRequest(url: listDirURL)
            driveRequest.httpMethod = "GET"
            let driveTask = URLSession.shared.dataTask(with: driveRequest) { (data, response, error) in
                do {
                    if let error = error {
                        DispatchQueue.main.async {
                            self.ErrorReturned = error.localizedDescription
                            self.progressIndicator = false
                            self.displayError = true
                        }
                        return
                    }
                    if let response = response as? HTTPURLResponse, let data = data {
                        if response.statusCode == 200 {
                            let driveList = try! JSONDecoder().decode(DriveListReturn.self, from: data)
                            DispatchQueue.main.async {
                                self.DrivesList = driveList
                                if driveList.total > 0 {
                                    self.progressIndicator = false
                                    self.drivesToDisplay = true
                                } else {
                                    self.progressIndicator = false
                                    self.drivesToDisplay = false
                                }
                            }
                        }
                        if response.statusCode >= 401 {
                            let decodedData = try JSONDecoder().decode(ErrorReturn.self, from: data)
                            DispatchQueue.main.async {
                                self.ErrorReturned = "Could not fetch available drives: \(decodedData.error.message)"
                                self.progressIndicator = false
                                self.displayError = true
                            }
                            return
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.ErrorReturned = "JSON Error whilst fetching available drives."
                        self.progressIndicator = false
                        self.displayError = true
                    }
                    return
                }
                semaphore.signal()
            }
            driveTask.resume()
         }
    }
    // MARK: - Search Method
    func search(searchstring:String, path:String, results:String, sortby:String, sortdir:String) {
        // have to check token exists before search because @published fires automatically gains willSet so it fires on init.
        // Is there a way to check the token exists before publishing? needs research cos the if loop is bad juju as it can't have an else statement.
        self.filesToDisplay = false
        self.displayError = false
        if (self.LoginReturned?.qqsSid != "" && self.searchField != "") {
            self.filesToDisplay = false
            self.progressIndicator = true
            //Safely Construct URL
            var components = URLComponents()
            components.scheme = "https"
            components.host = self.hostname
            components.port = Int(self.port)
            components.path = "/qsirch/static/api/search"
            components.queryItems = [
                URLQueryItem(name: "q", value: searchstring.stringByAddingPercentEncodingForFormData(plusForSpace: true)),
                URLQueryItem(name: "auth_token", value: self.LoginReturned?.qqsSid)
            ]
            if (path != "All") {
                components.queryItems!.append(URLQueryItem(name: "path", value: path))
            }
            components.queryItems!.append(URLQueryItem(name: "limit", value: results))
            components.queryItems!.append(URLQueryItem(name: "sort_by", value: sortby))
            var sorteddir = sortdir
            if (sortdir == "default") {
                sorteddir = "desc"
            }
            components.queryItems!.append(URLQueryItem(name: "sort_dir", value: sorteddir))
            
            // Make sure URL actually got constructed
            guard let searchURL = components.url else { return }
            let task = URLSession.shared.dataTask(with: searchURL) { (data, response, error) in
                
                do {
                    if let error = error {
                        DispatchQueue.main.async {
                            self.ErrorReturned = error.localizedDescription
                            self.displayError = true
                            self.progressIndicator = false
                        }
                        return
                    }
                    if let response = response as? HTTPURLResponse, let data = data {
                        if response.statusCode == 200 {
                            let fileList = try JSONDecoder().decode(SearchReturn.self, from: data)
                            DispatchQueue.main.async {
                                self.FileList = fileList
                                if self.FileList!.total > 0 {
                                    self.filesToDisplay = true
                                    self.progressIndicator = false
                                } else {
                                    self.filesToDisplay = false
                                    self.progressIndicator = false
                                }
                            }
                        }
                        if response.statusCode >= 400 {
                            let decodedData = try JSONDecoder().decode(ErrorReturn.self, from: data)
                            DispatchQueue.main.async {
                                self.ErrorReturned = decodedData.error.message
                                self.progressIndicator = false
                                self.displayError = true
                            }
                            return
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.ErrorReturned = "JSON Error whilst decoding search results."
                        self.progressIndicator = false
                        self.displayError = true
                    }
                    return
                }
            }
            task.resume()
        }
    }

}
