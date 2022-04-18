//
//  LoginViewController+WebKit.swift
//  SigninGithubTest
//
//  Created by Vladymyr Zghonyk on 18/4/22.
//

import UIKit
import WebKit

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        self.RequestForCallbackURL(request: navigationAction.request)
        navigationController?.isNavigationBarHidden = true
        decisionHandler(.allow)
    }

    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        print(requestURLString)
        if requestURLString.hasPrefix(GitConstants.REDIRECT_URI) {
            if requestURLString.contains("code=") {
                if let range = requestURLString.range(of: "=") {
                    let githubCode = requestURLString[range.upperBound...]
                    if let range = githubCode.range(of: "&state=") {
                        let gitCodeFinal = githubCode[..<range.lowerBound]
                        gitRequestForAccessToken(authCode: String(gitCodeFinal))

                        // Close GitHub Auth ViewController after getting Authorization
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    func gitRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&client_id=" + GitConstants.CLIENT_ID + "&client_secret=" + GitConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: GitConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, _) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                let accessToken = results?["access_token"] as! String
                // Get user's id, display name, email, profile pic url
                self.fetchGitUserProfile(accessToken: accessToken)
            }
        }
        task.resume()
    }

    func fetchGitUserProfile(accessToken: String) {
        let tokenURLFull = "https://api.github.com/user"
        let verify: NSURL = NSURL(string: tokenURLFull)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        request.addValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, _, error in
            if error == nil {
                let result = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                
                print("GitHub Access Token: \(accessToken)")
                self.githubAccessToken = accessToken
                
                let githubId = (result?["id"] as? Int)
                print("GitHub Id: \(githubId ?? 0)")
                self.githubId = githubId ?? 0
                
                let gitDisplayName = (result?["login"] as? String)
                print("GitHub Display Name: \(gitDisplayName ?? "")")
                self.githubDisplayName = gitDisplayName ?? ""
                
                let gitEmail = (result?["email"] as? String)
                print("GitHub Email: \(gitEmail ?? "")")
                self.githubEmail = gitEmail ?? ""
                
                let gitAvatarURL = (result?["avatar_url"] as? String)
                print("Github Profile Avatar URL: \(gitAvatarURL ?? "")")
                self.githubAvatarURL = gitAvatarURL ?? ""
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showParticular", sender: self)
                }
            }
        }
        task.resume()
    }
}

