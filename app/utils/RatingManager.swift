//
//  RatingManager.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 27/09/2022.
//

import StoreKit

class RatingManager: NSObject {
    
    static func countLaunchAndRate(){
        let ud = UserDefaults.standard
        
        let counter = ud.integer(forKey: UserDefaultsKeys.launchCounter.rawValue)
        
        if counter == 5 || counter == 11 || counter == 30 {
            guard let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                  return
            }
            SKStoreReviewController.requestReview(in: currentScene)
        }
        
        if counter == 7 || counter == 15 {
            if !AppState.shared.isPremium {
                AppState.shared.displayPurchasePage = true
            }
        }
        
        ud.set(counter+1, forKey: UserDefaultsKeys.launchCounter.rawValue)
    }
}
