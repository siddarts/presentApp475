//
//  ViewController.swift
//  Present
//
//  Created by Siddarth Sivakumar on 10/3/15.
//  Copyright (c) 2015 Siddarth Sivakumar. All rights reserved.
//

import UIKit
import Parse
import LocalAuthentication

class ViewController: UIViewController {
    
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authenticateUser()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        login()
    }
    
    func login() {
        var user = PFUser()
        user.username = UsernameTextField.text
        user.password = PasswordTextField.text

        PFUser.logInWithUsernameInBackground(UsernameTextField.text, password: PasswordTextField.text, block: {(User : PFUser?, Error : NSError?) -> Void in
            
            if Error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    var storyboard = UIStoryboard(name: "Main", bundle: nil)
                    var home : UIViewController = storyboard.instantiateViewControllerWithIdentifier("Home") as! UIViewController
                    
                    self.presentViewController(home, animated: true, completion: nil)
                }
            }else {
                NSLog("Wrong password")
            }
            
        })
    }
    
    @IBAction func signupAction(sender: AnyObject) {
        signUp()
    }
    
    func signUp() {
        var user = PFUser()
        user.username = UsernameTextField.text
        user.password = PasswordTextField.text
        user.email = EmailTextField.text
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //TouchID Authentication Below
    
    
    
    func authenticateUser() {
        
        let context = LAContext()
        
        var error: NSError?
        
        let reasonString = "Authentication required to access this application"
        
        
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: {(success, policyError) -> Void in
                
                if success {
                    
                    print ("Authentication Successful")
                    
                }
                    
                else {
                    
                    switch policyError!.code{
                        
                    case LAError.SystemCancel.rawValue:
                        
                        print("Authentication was cancelled by system")
                        
                    case LAError.UserCancel.rawValue:
                        
                        print("Authentication was cancelled by user")
                        
                    case LAError.UserFallback.rawValue:
                        
                        print("User selected to enter password")
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            
                            self.showPasswordAlert()
                            
                        })
                        
                    default:
                        
                        print("Authentication failed!")
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            
                            self.showPasswordAlert()
                            
                        })
                        
                    }
                    
                }
                
            })
            
        }
            
        else{
            
            print(error?.localizedDescription)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                self.showPasswordAlert()
                
            })
            
        }
        
    }
    func showPasswordAlert() {
        
        let alertController = UIAlertController(title: "Touch ID Password", message: "Please enter your password", preferredStyle: .Alert)
        
        
        
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            
            if let textField = alertController.textFields?.first as! UITextField?{
                
                if textField.text == "password"{
                    
                    print("Authentication Successful")
                    
                }
                    
                else{
                    
                    self.showPasswordAlert()
                    
                }
                
            }
            
        }
        
        
        
        alertController.addAction(defaultAction)
        
        
        
        alertController.addTextFieldWithConfigurationHandler{ (textField) -> Void in
            
            textField.placeholder = "Password"
            
            textField.secureTextEntry = true
            
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }

}





















////
////  ViewController.swift
////  Present
////
////  Created by Siddarth Sivakumar on 10/3/15.
////  Copyright (c) 2015 Siddarth Sivakumar. All rights reserved.
////
//
//import UIKit
//import Parse
//import ParseUI
//
//class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
//    
//    var logInViewController: PFLogInViewController! = PFLogInViewController()
//    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        if (PFUser.currentUser() == nil){
//            self.logInViewController.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.LogInButton | PFLogInFields.SignUpButton | PFLogInFields.PasswordForgotten | PFLogInFields.DismissButton
//            
//            var logInLogoTitle = UILabel()
//            logInLogoTitle.text = "Present"
//            self.logInViewController.logInView!.logo = logInLogoTitle //added ! after logInView
//            self.logInViewController.delegate = self
//            
//            var signUpLogoTitle = UILabel()
//            signUpLogoTitle.text = "Present"
//            self.signUpViewController.signUpView!.logo = signUpLogoTitle //added ! after signUpView
//            
//            self.signUpViewController.delegate = self
//            self.logInViewController.signUpController = self.signUpViewController
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    //Parse Login
//    
//    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
//        
//        if (!username.isEmpty || !password.isEmpty) {
//            return true
//        }else {
//            return false
//        }
//    }
//    
//    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
//        println("Failed to login")
//    }
//    
//    //Parse Sign Up
//    
//    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
//        println("Failed to sign up.")
//    }
//    
//    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
//        println("User dismissed sign up.")
//    }
//    
//    //Actions
//    
//    @IBAction func loginAction(sender: AnyObject) {
//        self.presentViewController(self.logInViewController, animated: true, completion: nil)
//    }
//    
//    @IBAction func logoutAction(sender: AnyObject) {
//        PFUser.logOut()
//    }
//    
//    
//}



