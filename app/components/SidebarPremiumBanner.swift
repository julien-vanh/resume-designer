//
//  SidebarPremiumView.swift
//  ResumeDesigner
//
//  Created by Julien on 16/01/2022.
//

import SwiftUI

struct SidebarPremiumBanner: View {
    @ObservedObject var resume: Resume
    @ObservedObject var appState = AppState.shared
        
    var body: some View {
        VStack(spacing: 8) {
            
            Text("You are using PRO feature, looks amazing!")
                .font(.callout)
            
            HStack {
                Button(action: {
                    resume.backToFree()
                }){
                    Text("Back to free")
                }
                .buttonStyle(.borderless)
                .tint(Color("premium"))
                
                Spacer()
                
                Button(action: {
                    self.appState.displayPurchasePage = true
                }){
                    Text("Unlock PRO")
                }
                .buttonStyle(.borderedProminent)
                .tint(Color("premium"))
                .buttonBorderShape(.capsule)
            }
            .padding(.horizontal)
            
        }
        .padding()
        .padding(.bottom, 20)
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial)))
    }
}

struct SidebarPremiumBanner_Previews: PreviewProvider {
    static var previews: some View {
        SidebarPremiumBanner(resume: RandomGenerator.randomResume())
    }
}
