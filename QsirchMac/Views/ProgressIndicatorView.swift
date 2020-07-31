//
//  ProgressIndicatorView.swift
//  QsirchMac
//
//  Created by Elliot Cater on 28/07/2020.
//  Copyright © 2020 Caters. All rights reserved.
//

// When upgrade to OS11 we can ditch this and use ProgressView!

import SwiftUI

struct ProgressIndicator: NSViewRepresentable {
    
    typealias TheNSView = NSProgressIndicator
    var configuration = { (view: TheNSView) in }
    
    func makeNSView(context: NSViewRepresentableContext<ProgressIndicator>) -> NSProgressIndicator {
        TheNSView()
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: NSViewRepresentableContext<ProgressIndicator>) {
        configuration(nsView)
    }
}

struct ProgressIndicatorView: View {
    var body: some View {
        VStack {
            ProgressIndicator {
                $0.style = .spinning
                $0.startAnimation(nil)
                
            }.padding()
        }
    }
}

struct ProgressIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressIndicatorView()
    }
}
