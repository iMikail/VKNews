//
//  SceneDelegate.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import UIKit
import VKSdkFramework

class SceneDelegate: UIResponder, UIWindowSceneDelegate, AuthServiceDelegate {
    var window: UIWindow?
    var authService: AuthService?

    static func shared() -> SceneDelegate {
        let scene = UIApplication.shared.connectedScenes.first
        let sceneDelegate: SceneDelegate = (scene?.delegate as? SceneDelegate) ?? SceneDelegate()

        return sceneDelegate
    }

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        authService = AuthService()
        authService?.delegate = self
        let authVC = UIStoryboard(name: String(describing: AuthViewController.self),
                                  bundle: nil).instantiateInitialViewController()
                    as? AuthViewController
        window?.rootViewController = authVC
        window?.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }

    // MARK: - AuthServiceDelegate
    func authServiceShouldShow(viewController: UIViewController) {
        print(#function)
        window?.rootViewController?.present(viewController, animated: true)
    }

    func authServiceSignIn() {
        guard
            let feedVC = UIStoryboard(name: String(describing: NewsFeedViewController.self),
                                      bundle: nil).instantiateInitialViewController() as? NewsFeedViewController else
            { return }
        let navVC = UINavigationController(rootViewController: feedVC)
        window?.rootViewController = navVC
        print(#function)
    }

    func authServiceSignInDidFail() {
        print(#function)
    }
}
