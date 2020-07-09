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
    
    @State var hostnameField: String = UserDefaults.standard.string(forKey: "hostname") ?? ""
    @State var hostnameInvalid:Bool = false
    
    @State var usernameField: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State var usernameInvalid:Bool = false
    
    @State var passwordField: String = UserDefaults.standard.string(forKey: "password") ?? ""
    @State var passwordInvalid:Bool = false
    
    @State var portField: String = UserDefaults.standard.string(forKey: "port") ?? "443"
    
    @State var rememberMe:Bool = true
    
    @State var connectionOutput: String = ""
    
    @State var qqsSID: String = ""
    
    
    // Check vital fields and return true or activate warnings
    fileprivate func formValidate() -> Bool {
        var validity:Bool = true
        if self.hostnameField.isEmpty {
            self.hostnameInvalid = true
        } else {
            self.hostnameInvalid = false
        }
        if self.usernameField.isEmpty {
            self.usernameInvalid = true
        } else {
            self.usernameInvalid = false
        }
        if self.passwordField.isEmpty {
            self.passwordInvalid = true
        } else {
            self.passwordInvalid = false
        }
        if (self.hostnameField.isEmpty || self.usernameField.isEmpty || self.passwordField.isEmpty) {
            validity = false
        }
        return validity
    }
    fileprivate func save() {
        if formValidate(){
            print("Valid Form")
            if (rememberMe){
                print("Remember Checked")
                UserDefaults.standard.set(hostnameField, forKey: "hostname")
                UserDefaults.standard.set(usernameField, forKey: "username")
                UserDefaults.standard.set(passwordField, forKey: "password")
                if portField.isEmpty {
                    UserDefaults.standard.set("443", forKey: "port")
                } else {
                    UserDefaults.standard.set(portField, forKey: "port")
                }
                // Add Close Window
            } else {
                print("Forget Me")
                UserDefaults.standard.removeObject(forKey: "hostname")
                settings.hostname = hostnameField
                UserDefaults.standard.removeObject(forKey: "username")
                settings.username = usernameField
                UserDefaults.standard.removeObject(forKey: "password")
                settings.password = passwordField
                UserDefaults.standard.removeObject(forKey: "port")
                if portField.isEmpty {
                    settings.port = "443"
                } else {
                   settings.port = portField
                }
                // Add Close Window
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
                        TextField("Port", value: $portField, formatter: portFormatter).frame(width: 60)
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
                                    print("Test Connection Begin")
                                }
                                
                            }) {
                                Text("Test")
                            }
                            Button(action: {
                                if(self.formValidate()) {
                                    print("Saved")
                                }
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
                                Text(connectionOutput)
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
