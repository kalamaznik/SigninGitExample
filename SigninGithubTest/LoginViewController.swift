//
//  ViewController.swift
//  SigninGithubTest
//
//  Created by Vladymyr Zghonyk on 18/4/22.
//

import UIKit
import WebKit

class LoginViewController: UIViewController {
    @IBOutlet var githubLoginBtn: UIButton!

    var githubId = 0
    var githubDisplayName = ""
    var githubEmail = ""
    var githubAvatarURL = ""
    var githubAccessToken = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SigninGithubTest"
        self.githubLoginBtn.layer.cornerRadius = 10.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func githubLoginBtnAction(_ sender: UIButton) {
        githubAuthVC()
    }

    var webView = WKWebView()
    func githubAuthVC() {
        let githubVC = UIViewController()
        // Generate random identifier for the authorization
        let uuid = UUID().uuidString
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        githubVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: githubVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: githubVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: githubVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: githubVC.view.trailingAnchor)
        ])

        let authURLFull = "https://github.com/login/oauth/authorize?client_id=" + GitConstants.CLIENT_ID + "&scope=" + GitConstants.SCOPE + "&redirect_uri=" + GitConstants.REDIRECT_URI + "&state=" + uuid

        let urlRequest = URLRequest(url: URL(string: authURLFull)!)
        webView.load(urlRequest)

        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: githubVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        githubVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        githubVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        githubVC.navigationItem.title = "github.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.colorFromHex("#333333")
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical

        self.present(navController, animated: true, completion: nil)
    }

    @objc func cancelAction() {
        self.dismiss(animated: true) {
            UIView.animate(withDuration: 0.4) {
                self.navigationController?.isNavigationBarHidden = false
            }
        }
    }

    @objc func refreshAction() {
        self.webView.reload()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showParticular" {
            let DestView = segue.destination as! ParticularViewContoller
            DestView.githubId = self.githubId
            DestView.githubDisplayName = self.githubDisplayName
            DestView.githubEmail = self.githubEmail
            DestView.githubAvatarURL = self.githubAvatarURL
            DestView.githubAccessToken = self.githubAccessToken
        }
    }
}
