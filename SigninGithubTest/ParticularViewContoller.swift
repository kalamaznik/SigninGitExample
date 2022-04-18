//
//  ParticularViewContoller.swift
//  SigninGithubTest
//
//  Created by Vladymyr Zghonyk on 18/4/22.
//

import UIKit

class ParticularViewContoller: UIViewController {

    @IBOutlet weak var githubIdLabel: UILabel!
    @IBOutlet weak var githubDisplayNameLabel: UILabel!
    @IBOutlet weak var githubEmailLabel: UILabel!
    @IBOutlet weak var githubAvatarUrlLabel: UILabel!
    @IBOutlet weak var githubAccessTokenLabel: UILabel!
    
    var githubId = 0
    var githubDisplayName = ""
    var githubEmail = ""
    var githubAvatarURL = ""
    var githubAccessToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        githubIdLabel.text = String(githubId)
        githubDisplayNameLabel.text = githubDisplayName
        githubEmailLabel.text = githubEmail
        githubAvatarUrlLabel.text = githubAvatarURL
        githubAccessTokenLabel.text = githubAccessToken
    }
}
