//
//  ResetPasswordViewController.swift
//  AppLoginWithFirebase
//
//  Created by Ibrahima KH GUEYE on 09/12/2017.
//  Copyright © 2017 Ibrahima KH GUEYE. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    @IBOutlet weak var emailTextfield: UITextField!
    
    let networkingService = NetworkingService()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func resetPasswordAction(_ sender: Any) {
        networkingService.resetPassword(email: emailTextfield.text!)
    }
}
