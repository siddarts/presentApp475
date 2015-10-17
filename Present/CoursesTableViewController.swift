//
//  CoursesTableViewController.swift
//  Present
//
//  Created by Siddarth Sivakumar on 10/16/15.
//  Copyright © 2015 Siddarth Sivakumar. All rights reserved.
//

import UIKit
import Parse

class CoursesTableViewController: UITableViewController {
    
    var currentUser = PFUser.currentUser()!
    var courses:[AnyObject] = []
    
    override func viewWillAppear(animated: Bool) {
        courses = getCourses()
//        courses = ["test1", "2", "3"]
//        for course in courses {
//            print(course["name"] as! String)
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        courses = ["test1", "2", "3"]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }
    
    func getCourses() -> [AnyObject] {
        var allCourses : [AnyObject] = []
        let allUserEvents = PFQuery(className: "User_Event")
        print(allUserEvents)
        allUserEvents.whereKey("userId", equalTo: currentUser)
        
        var userEvents : [AnyObject] = []
        
        do {
            userEvents = try allUserEvents.findObjects() as [PFObject]
        } catch _ {
            userEvents = []
        }
    
        for ue in userEvents {
        
//            print(ue)
            
            
        //            query.includeKey("name")
//            query.whereKey("objectId", equalTo: ue["eventId"])
//            print (ue)
            let courseId = ue["eventId"]!?.objectId
            print(courseId)
//            allCourses.append(course!)
            
            let course = PFQuery(className: "Event")
//            course.includeKey("name")
//            course.whereKey("objectId", equalTo: courseId!)
            
//            allCourses.append(ue["eventId"]!! as! PFObject)

            course.whereKey("objectId", equalTo: courseId!!)

            do {
                let courseObject = try course.getFirstObject()
//                print(courseObject)
                allCourses.append(courseObject)
            } catch _ {
                let courseObject = "error"
            }
            
        }
        
        print(allCourses)
        return allCourses
        
        
//        
//        userEvents.findObjectsInBackgroundWithBlock {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            
//            if error == nil {
//                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) userEvents.")
//                // Do something with the found objects
//                if let userEvents = objects! as? [PFObject] {
//                    for userEvent in userEvents {
////                        print(userEvent)
////                        print(userEvent["eventId"])
//                        allCourses.insert(userEvent["eventId"], atIndex: 0)
//                        print(allCourses)
////                        print(userEvent["eventId"])
////                        let course = PFQuery(className: "Event")
////                        course.getObjectInBackgroundWithId(userEvent["eventId"].objectId!!) {
////                            (courses: PFObject?, error: NSError?) -> Void in
//////                            print(courses?["name"])
//////                            allCourses.append(courses!)
////                        }
//                        
//                    }
//                }
//                return allCourses
//            } else {
//                // Log details of the failure
//                print("Error: \(error!) \(error!.userInfo)")
//            }
//        }
//        return allCourses
        
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "CoursesTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CoursesTableViewCell
        let course = courses[indexPath.row]
//        print (course)
        let courseName = course["name"] as! String
//        let courseId = ue["eventId"]!!.objectId as String
//        let course = PFQuery(className: "Event")
//        course.whereKey("objectId", equalTo: courseId)
//        let courseName = course.findObjects()
        
//        let courseName = course.objectId as String!
        cell.courseNameLabel.text = courseName
//        if let label = cell.courseNameLabel {
//            print("in here")
//            label.text = course as? String
//
//        }
//        cell.courseNameLabel.text = course as? String

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
