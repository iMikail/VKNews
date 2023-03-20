//
//  AuthService.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import Foundation
import VKSdkFramework

class AuthService: NSObject, VKSdkDelegate, VKSdkUIDelegate {
    private let appId = "51586417"
    private let vkSdk: VKSdk

    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self
    }

    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
    }

    func vkSdkUserAuthorizationFailed() {
        print(#function)
    }

    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)
    }

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
}
