//
//  SplashScreenView.swift
//  ArCamp
//
//  Created by Mantas Ercius on 08.07.24.
//

import SwiftUI

let LocalizeUserDefaultKey = "LocalizeUserDefaultKey"
var LocalizeDefaultLanguage = "en"

// View displaying a splash screen with language selection
struct SplashScreenView: View {
    @State private var isActive = false  // Controls the transition to the main content view
    @State private var size = 0.8  // Initial scale of the splash screen image
    @State private var opacity = 0.5  // Initial opacity of the splash screen image
    
    var body: some View {
        if isActive {
            ContentView()  // Show main content view if isActive is true
        } else {
            VStack {
                // Splash screen image with animation
                Image("splashscreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 700, height: 700)
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 1.0
                            self.opacity = 1.0
                        }
                    }
                Spacer()
                // Language selection buttons
                HStack {
                    Button(action: {
                        setLanguage("en")
                        self.isActive = true
                    }) {
                        Text("🇬🇧")
                            .font(.system(size: 75))
                    }
                    .padding(.bottom, 100)
                    
                    Button(action: {
                        setLanguage("de")
                        self.isActive = true
                    }) {
                        Text("🇩🇪")
                            .font(.system(size: 75))
                    }
                    .padding(.bottom, 100)
                }
            }
        }
    }
    
    // Sets the app language and synchronizes user defaults
    func setLanguage(_ code: String) {
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
}

#Preview {
    SplashScreenView()
}
