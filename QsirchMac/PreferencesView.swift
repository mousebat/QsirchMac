//
//  PreferencesView.swift
//  QsirchMac
//
//  Created by Elliot Cater on 07/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import SwiftUI

private var portFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.none
    formatter.usesSignificantDigits = false
    formatter.minimumIntegerDigits = 0
    formatter.maximumIntegerDigits = 5
    formatter.maximum = 65535
    formatter.minimum = 1
    return formatter
 }()

struct PreferencesView: View {
    
    
    @EnvironmentObject var settings: UserSettings
    @EnvironmentObject var networkManager: NetworkManager
    
    @State var hostnameField: String = UserDefaults.standard.string(forKey: "hostname") ?? ""
    @State var hostnameInvalid:Bool = false
    
    @State var usernameField: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var usernameInvalid:Bool = false
    
    @State var passwordField: String = UserDefaults.standard.string(forKey: "password") ?? ""
    @State var passwordInvalid:Bool = false
    
    @State var portField: String = UserDefaults.standard.string(forKey: "port") ?? ""
    
    @State var rememberMe:Bool = true
    
    @State var connectionOutput: String = ""
    
    // Check vital fields and return true or activate warnings
    fileprivate func formValidate() -> Bool {
        var validity:Bool = true
        if hostnameField.isEmpty { hostnameInvalid = true } else { hostnameInvalid = false }
        if usernameField.isEmpty { usernameInvalid = true } else { usernameInvalid = false }
        if passwordField.isEmpty { passwordInvalid = true } else { passwordInvalid = false }
        if portField.isEmpty { portField = "443" }
        if (hostnameField.isEmpty || usernameField.isEmpty || passwordField.isEmpty) { validity = false }
        return validity
    }
    fileprivate func save() {
        if formValidate(){
            if (rememberMe){
                // TODO: - if login successfull {
                UserDefaults.standard.set(hostnameField, forKey: "hostname")
                settings.hostname = hostnameField
                UserDefaults.standard.set(usernameField, forKey: "username")
                settings.username = usernameField
                UserDefaults.standard.set(passwordField, forKey: "password")
                settings.password = passwordField
                UserDefaults.standard.set(portField, forKey: "port")
                settings.port = portField
                NSApplication.shared.keyWindow?.close()
                NSApp.sendAction(#selector(AppDelegate.openSearchWindow), to: nil, from:nil)
                //} TODO...
            } else {
                // TODO: - if login successfull {
                UserDefaults.standard.removeObject(forKey: "hostname")
                settings.hostname = hostnameField
                UserDefaults.standard.removeObject(forKey: "username")
                settings.username = usernameField
                UserDefaults.standard.removeObject(forKey: "password")
                settings.password = passwordField
                UserDefaults.standard.removeObject(forKey: "port")
                settings.port = portField
                NSApplication.shared.keyWindow?.close()
                NSApp.sendAction(#selector(AppDelegate.openSearchWindow), to: nil, from:nil)
                //} TODO...
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Please insert the details for your QNAP system")
                    .padding(.bottom, 10.0)
            }
            Form {
                Section {
                    HStack {
                        Text("Hostname").frame(minWidth: 65, alignment: .trailing)
                        TextField("Insert Hostname", text: $hostnameField)
                    }
                    if hostnameInvalid {
                        HStack {
                            Spacer()
                            Text("Hostname is a required field").font(Font.system(size: 10, weight: .light, design: .default)).foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
                Section {
                    HStack {
                        Text("Username").frame(minWidth: 65, alignment: .trailing)
                        
                        TextField("Insert Username", text: $usernameField)
                    }
                    if usernameInvalid {
                        HStack {
                            Spacer()
                            Text("Username is a required field").font(Font.system(size: 10, weight: .light, design: .default)).foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
                Section {
                    HStack {
                        Text("Password").frame(minWidth: 65, alignment: .trailing)
                        
                        SecureField("Insert Password", text: $passwordField)
                    }
                    if passwordInvalid {
                        HStack {
                            Spacer()
                            Text("Password is a required field").font(Font.system(size: 10, weight: .light, design: .default)).foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
                Section {
                    HStack {
                        Text("Port").frame(minWidth: 65 , alignment: .trailing)
                        TextField("443", value: $portField, formatter: portFormatter).frame(width: 60)
                        Spacer()
                        Toggle(isOn: $rememberMe) {
                            Text("Remember Details")
                        }
                    }
                }
                Section {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                if(self.formValidate()) {
                                    self.networkManager.login(hostname: self.hostnameField, port: self.portField, username: self.usernameField, password: self.passwordField) { (LoginReturn, ReturnedError, HardError) in
                                        if let LoginReturn = LoginReturn {
                                            DispatchQueue.main.async {
                                                self.settings.token = LoginReturn.qqsSid
                                            }
                                            self.connectionOutput = "User \(LoginReturn.userName) logged in successfully"
                                        }
                                        if let ReturnedError = ReturnedError {
                                            self.connectionOutput = ReturnedError.error.message
                                        }
                                        if let HardError = HardError {
                                            self.connectionOutput = HardError
                                        }
                                    }
                                }
                            }) {
                                Text("Test")
                            }
                            Button(action: {
                                self.save()
                            }) {
                                Text("Save")
                            }
                            Spacer()
                        }
                    }
                    
                }
                if (connectionOutput.isEmpty == false) {
                    Section {
                        VStack {
                            HStack {
                                Spacer()
                                Text(connectionOutput).fixedSize(horizontal: true, vertical: false)
                                Spacer()
                            }
                        }
                    }.padding([.top, .leading, .trailing],10)
                }
            }
        }.padding(.all, 50)
        
    }
}

struct PreferencesView_Previews: PreviewProvider {
    @State var hostnameField: String = UserDefaults.standard.string(forKey: "hostname") ?? ""
    @State var hostnameInvalid:Bool = false
    @State var usernameField: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var usernameInvalid:Bool = false
    @State var passwordField: String = UserDefaults.standard.string(forKey: "password") ?? ""
    @State var passwordInvalid:Bool = false
    @State var portField: String = UserDefaults.standard.string(forKey: "port") ?? "443"
    @State var rememberMe:Bool = true
    @State var qqsSID: String = ""
    
    static var previews: some View {
        PreferencesView()
    }
}
