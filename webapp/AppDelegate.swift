//
//  AppDelegate.swift
//  webapp
//
//  Created by gzonelee on 6/13/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 이것이 처음 설치된 것인지 확인
        let didRunBefore = UserDefaults.standard.bool(forKey: "didRunBefore")
        
        if !didRunBefore {
            // 이것은 처음 설치이거나 앱이 삭제되고 다시 설치된 경우입니다.
            KeychainService.shared.deleteAllTokens()
            UserDefaults.standard.set(true, forKey: "didRunBefore")
        }
        else {
            if let value = KeychainService.shared.getToken(forKey: "test") {
                GZLogFunc(value)
            }
        }

        return true
    }
}

