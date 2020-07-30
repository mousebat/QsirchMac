//
//  PreferencesView.swift
//  QsirchMac
//
//  Created by Elliot Cater on 07/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

import SwiftUI


extension NumberFormatter {
    static var port: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.none
        formatter.usesSignificantDigits = false
        formatter.minimumIntegerDigits = 0
        formatter.maximumIntegerDigits = 5
        formatter.maximum = 65535
        formatter.minimum = 1
        return formatter
    }
}

struct PreferencesView: View {
    
    @EnvironmentObject var networkManager: NetworkManager
    
    @State var hostnameField: String = UserDefaults.standard.string(forKey: "hostname") ?? ""
    @State var hostnameInvalid:Bool = false
    @State var usernameField: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var usernameInvalid:Bool = false
    @State var passwordField: String = UserDefaults.standard.string(forKey: "password") ?? ""
    @State var passwordInvalid:Bool = false
    @State var portField:String = UserDefaults.standard.string(forKey: "port") ?? ""
    @State var rememberMe:Bool = true
    
    
    
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
                let defaults = UserDefaults.standard
                defaults.set(hostnameField, forKey: "hostname")
                networkManager.hostname = hostnameField
                defaults.set(usernameField, forKey: "username")
                networkManager.username = usernameField
                defaults.set(passwordField, forKey: "password")
                networkManager.password = passwordField
                defaults.set(portField, forKey: "port")
                networkManager.port = portField
                NSApplication.shared.keyWindow?.close()
                NSApp.sendAction(#selector(AppDelegate.openSearchWindow), to: nil, from:nil)
            } else {
                let defaults = UserDefaults.standard
                let dictionary = defaults.dictionaryRepresentation()
                dictionary.keys.forEach { key in
                    defaults.removeObject(forKey: key)
                }
                networkManager.hostname = hostnameField
                networkManager.username = usernameField
                networkManager.password = passwordField
                networkManager.port = portField
                NSApplication.shared.keyWindow?.close()
                NSApp.sendAction(#selector(AppDelegate.openSearchWindow), to: nil, from:nil)
            }
        }
    }
    
    // portFieldProxy Binding
    var portFieldProxy:Binding<String> {
        Binding<String>(
            get: { self.portField },
            set: {
                if let value = NumberFormatter.port.number(from: $0) {
                self.portField = value.stringValue
            }
        })
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
                        TextField("443", text: portFieldProxy).frame(width: 60)
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
                                    self.networkManager.login(hostname: self.hostnameField, port: self.portField, username: self.usernameField, password: self.passwordField)
                                }
                            }) {
                                Text("Test")
                            }
                            Button(action: {
                                if(self.formValidate()) {
                                    self.networkManager.login(hostname: self.hostnameField, port: self.portField, username: self.usernameField, password: self.passwordField)
                                    self.save()
                                }
                            }) {
                                Text("Save")
                            }
                            Spacer()
                        }
                    }
                    
                }
                if (networkManager.progressIndicator == true) {
                    Section {
                    VStack {
                        HStack {
                            Spacer()
                                ProgressIndicatorView()
                            Spacer()
                            }
                        }
                    }.padding([.top, .leading, .trailing],10)
                }
                if (networkManager.displayError) {
                    Section {
                        VStack {
                            HStack {
                                Spacer()
                                Text("\(networkManager.ErrorReturned!)").fixedSize(horizontal: true, vertical: false)
                                Spacer()
                            }
                        }
                    }.padding([.top, .leading, .trailing],10)
                }
                if (networkManager.displayLogin) {
                    Section {
                        VStack {
                            HStack {
                                Spacer()
                                Text("\(networkManager.LoginReturned!.userName) logged in successfully.").fixedSize(horizontal: true, vertical: false)
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
    
    static var previews: some View {
        PreferencesView()
    }
}
