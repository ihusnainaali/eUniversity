//
//  LoginViewController.swift
//  eUniversity
//
//  Created by Damir Ramic on 11/01/2018.
//  Copyright © 2018 Damir Ramich. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let username = usernameTextField.text, let password = passwordTextField.text {
            UserController.sharedController.delegate = self
            UserController.sharedController.login(userName: username, password: password)
        }
    }
}

extension LoginViewController:UserControllerDelegate {
    
    func onSuccess() {
        print("Success")
        let storyBoard = UIStoryboard(name:"Main", bundle:nil)
        let filterVC = storyBoard.instantiateViewController(withIdentifier: "tabBar")
        self.present(filterVC, animated: true, completion: nil)
    }
    
    func onError() {
}

}

