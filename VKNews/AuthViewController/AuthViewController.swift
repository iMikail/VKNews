//
//  AuthViewController.swift
//  VKNews
//
//  Created by Misha Volkov on 20.03.23.
//

import UIKit

class AuthViewController: UIViewController {
    var authService: AuthService?

    override func viewDidLoad() {
        super.viewDidLoad()
        authService = SceneDelegate.shared().authService
        view.backgroundColor = .systemIndigo
    }

    @IBAction func signInTouch(_ sender: UIButton) {
        guard let authService = authService else { return }

        authService.wakeUpSession()
    }
}
