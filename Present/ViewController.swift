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
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController, CBPeripheralManagerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    var roles = ["Professor", "Student"]
    
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet weak var RolePicker: UIPickerView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        RolePicker.delegate = self
        RolePicker.dataSource = self
//        self.authenticateUser()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        login()
    }
    
    func login() {
        let user = PFUser()
        user.username = UsernameTextField.text
        user.password = PasswordTextField.text

        PFUser.logInWithUsernameInBackground(UsernameTextField.text!, password: PasswordTextField.text!, block: {(User : PFUser?, Error : NSError?) -> Void in
            
            if Error == nil {
                dispatch_async(dispatch_get_main_queue()){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let home : UIViewController = storyboard.instantiateViewControllerWithIdentifier("Home")
//                        as! UIViewController
                    
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
        let user = PFUser()
        user.username = UsernameTextField.text
        user.password = PasswordTextField.text
        user.email = EmailTextField.text
        user.setValue(roles[RolePicker.selectedRowInComponent(0)], forKey: "role")
//        user.setValue("5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", forKey: "uuid")
//        user.setValue(randomMajMin(), forKey: "major")
//        user.setValue(randomMajMin(), forKey: "minor")
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                print("in error")
//                let errorString = error.userInfo["error"] as? NSString
                _ = error.userInfo["error"] as? NSString
//                let alert = UIAlertController(title:"Missing Field", message:"Cannot create user..please fill required fields!", preferredStyle: UIAlertControllerStyle.Alert)
//                alert.addAction(UIAlertAction(title:"Okay", style: UIAlertActionStyle.Default, handler:nil))
//                self.presentViewController(alert, animated:true, completion:nil)
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
            }
        }
    }
    
//    func randomMajMin() -> Int {
//        let lower : UInt32 = 1
//        let upper : UInt32 = 65534
//        let randomNumber = arc4random_uniform(upper - lower) + lower
//        return Int(randomNumber)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(EmailTextField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = EmailTextField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        signUpButton.enabled = (newText.length > 0)
        return true
    }
    
    //Code for Picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roles[row]
    }
    
    
//    //TouchID Authentication Below
//    func authenticateUser() {
//        
//        let context = LAContext()
//        var error: NSError?
//        let reasonString = "Authentication required to access this application"
//        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
//            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: {(success, policyError) -> Void in
//                if success {
//                    print ("Authentication Successful", terminator: "")
//                }
//                else {
//                    switch policyError!.code{
//                    case LAError.SystemCancel.rawValue:
//                        print("Authentication was cancelled by system", terminator: "")
//                    case LAError.UserCancel.rawValue:
//                        print("Authentication was cancelled by user", terminator: "")
//                    case LAError.UserFallback.rawValue:
//                        print("User selected to enter password", terminator: "")
//                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                            self.showPasswordAlert()
//                        })
//                    default:
//                        print("Authentication failed!", terminator: "")
//                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                            self.showPasswordAlert()
//                        })
//                    }
//                }
//            })
//            
//        } else {
////            let error = NSError.self
//            print(error?.localizeDescription, terminator: "")
//            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                self.showPasswordAlert()
//            })
//        }
//    }
//    func showPasswordAlert() {
//        
//        let alertController = UIAlertController(title: "Touch ID Password", message: "Please enter your password", preferredStyle: .Alert)
//    
//        let defaultAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
//            if let textField = alertController.textFields?.first {
//                if textField.text == "password"{
//                    print("Authentication Successful", terminator: "")
//                }
//                else{
//                    self.showPasswordAlert()
//                }
//            }
//        }
//    
//        alertController.addAction(defaultAction)
//    
//        alertController.addTextFieldWithConfigurationHandler{ (textField) -> Void in
//            textField.placeholder = "Password"
//            textField.secureTextEntry = true
//        }
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
    
    
    //Beacon Code Below
    
    
    @IBAction func startBeacon(sender: AnyObject) {
        startLocalBeacon()
    }
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    func startLocalBeacon() {
        if localBeacon != nil {
            stopLocalBeacon()
        }
        
        let localBeaconUUID = "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5"
        let localBeaconMajor: CLBeaconMajorValue = 123
        let localBeaconMinor: CLBeaconMinorValue = 456
        
        let uuid = NSUUID(UUIDString: localBeaconUUID)!
        localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: "Your private identifer here")
        
        beaconPeripheralData = localBeacon.peripheralDataWithMeasuredPower(nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if peripheral.state == .PoweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as! [String: AnyObject]!)
        } else if peripheral.state == .PoweredOff {
            peripheralManager.stopAdvertising()
        }
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



