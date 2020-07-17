//
//  UserSettingsManager.swift
//  QsirchMac
//
//  Created by Elliot Cater on 09/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import Foundation
import Combine

// MARK: - Store User Settings in EnvironmentObject
class UserSettings: ObservableObject {
    @Published var hostname:String = UserDefaults.standard.string(forKey: "hostname") ?? ""
    @Published var username:String = UserDefaults.standard.string(forKey: "username") ?? ""
    @Published var password:String = UserDefaults.standard.string(forKey: "password") ?? ""
    @Published var port:String = UserDefaults.standard.string(forKey: "port") ?? ""
    @Published var token:String = ""
}
