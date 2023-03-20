//
//  SceneDelegate.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import UIKit
import VKSdkFramework

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var authService: AuthService?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        authService = AuthService()
        let authVC = UIStoryboard(name: "AuthViewController", bundle: nil).instantiateInitialViewController()
                    as? AuthViewController
        window?.rootViewController = authVC
        window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }
}
