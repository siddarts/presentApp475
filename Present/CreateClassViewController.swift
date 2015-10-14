//
//  CreateClassViewController.swift
//  Present
//
//  Created by Siddarth Sivakumar on 10/13/15.
//  Copyright © 2015 Siddarth Sivakumar. All rights reserved.
//

import UIKit
import Parse

class CreateClassViewController: UIViewController {
    
    @IBOutlet var className: UITextField!
    @IBOutlet var classDpt: UITextField!
    @IBOutlet var classDesc: UITextField!
    @IBOutlet var classLateAfter: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveCourse(sender: AnyObject) {
        createCourse()
    }
    
    
    func createCourse() {
        let course = PFObject(className: "Event")
        
        
        if (className.text!.isEmpty || classDpt.text!.isEmpty || classDesc.text!.isEmpty) {
            let alert = UIAlertView()
            alert.title = "Missing Fields"
            alert.message = "One or more of the fields are blank...please complete"
            alert.addButtonWithTitle("Ok")
            alert.show()
        } else {
            course.setObject(className.text!, forKey: "name")
            course.setObject(classDpt.text!, forKey: "department")
            course.setObject(classDesc.text!, forKey: "description")
            if (!(classLateAfter.text!.isEmpty)){
                course.setObject(Int(classLateAfter.text!), forKey: "lateAfter")
            }
            course.saveInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    _ = error.userInfo["error"] as? NSString
                    // Show the errorString somewhere and let the user try again.
                } else {
                    let userEvent = PFObject(className: "User_Event")
                    userEvent.setObject(course, forKey: "eventId")
                    userEvent.setObject(PFUser.currentUser()!, forKey: "userId")
                    userEvent.saveInBackgroundWithBlock {
                        (succeeded: Bool, error: NSError?) -> Void in
                        if let error = error {
                            _ = error.userInfo["error"] as? NSString
                            // Show the errorString somewhere and let the user try again.
                        } else {
                            
                        }
                    }
                    
                }
            }
        }
    }


    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
