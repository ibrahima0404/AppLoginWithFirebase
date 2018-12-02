//
//  LoginViewController.swift
//  AppLoginWithFirebase
//
//  Created by Ibrahima KH GUEYE on 09/12/2017.
//  Copyright © 2017 Ibrahima KH GUEYE. All rights reserved.
//

import UIKit
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTexfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var networkingService = NetworkingService()
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    @IBAction func signInAction(_ sender: Any) {
        
        networkingService.loginCallback = { (state) in
            switch state {
                
            case .failed(let error):
                self.presentAlert(With: error)
                break
            case .success:
                print("Success")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcomeVC")
                self.present(vc, animated: true, completion: nil)
                break
            }
        }

        networkingService.signIn(email: emailTexfield.text!, password: passwordTextField.text!)

    }
    
    
    @IBAction func unwindToLogin(storyboard: UIStoryboardSegue) {
        
        
    }
}

extension LoginViewController {
    private func presentAlert(With error: String) {
        let alert = UIAlertController(title: "Sign In Failed", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
