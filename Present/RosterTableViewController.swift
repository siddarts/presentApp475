//
//  RosterTableViewController.swift
//  Present
//
//  Created by Siddarth Sivakumar on 10/17/15.
//  Copyright © 2015 Siddarth Sivakumar. All rights reserved.
//

import UIKit
import Parse
import CoreBluetooth
import CoreLocation

class RosterTableViewController: UITableViewController, CBPeripheralManagerDelegate, CLLocationManagerDelegate {

    var course = PFObject(className: "Event")
    var students:[AnyObject] = []
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    var locationManager: CLLocationManager!
    
    override func viewWillAppear(animated: Bool) {
//        self.title = pageTitle
        self.title = course["name"] as! String
        students = getStudents()
        print(students)
        self.tableView.reloadData()
        initLocalBeacon()
    }
    
    override func viewWillDisappear(animated: Bool) {
        stopLocalBeacon()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
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
        return students.count
    }
    
    func getStudents() -> [AnyObject] {
        var allStudents : [AnyObject] = []
        let allUserEvents = PFQuery(className: "User_Event")
        //        print(allUserEvents)
        allUserEvents.whereKey("eventId", equalTo: course)

        var userEvents : [AnyObject] = []
        
        do {
            userEvents = try allUserEvents.findObjects() as [PFObject]
        } catch _ {
            userEvents = []
        }

        for ue in userEvents {
            let userId = ue["userId"]!?.objectId
//            print(userId!!)
            let user = PFQuery(className: "_User")
            user.whereKey("objectId", equalTo: userId!!)
            print(user)
            
            do {
                let userObject = try user.getFirstObject()
//                print(userObject)
                if (userObject["role"] as! String) == "Student" {
                    allStudents.append(userObject)
                }
            } catch _ {
                let userObject = "error"
            }
            
        }
        
//        print(allStudents)
        return allStudents
    }


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "RosterTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RosterTableViewCell
        let student = students[indexPath.row]
        //        print (course)
        let studentFName = student["firstName"] as! String
        let studentLName = student["lastName"] as! String
        let studentPName = studentLName + ", " + studentFName
        //        let courseId = ue["eventId"]!!.objectId as String
        //        let course = PFQuery(className: "Event")
        //        course.whereKey("objectId", equalTo: courseId)
        //        let courseName = course.findObjects()
        
        //        let courseName = course.objectId as String!
        cell.studentName.text = studentPName
        //        if let label = cell.courseNameLabel {
        //            print("in here")
        //            label.text = course as? String
        //
        //        }
        //        cell.courseNameLabel.text = course as? String
        
        return cell
    }
    
    //Code below for beacon
    func initLocalBeacon() {
        
        if localBeacon != nil {
            stopLocalBeacon()
        }
        else{
            let localBeaconUUID = course["uuid"] as! String
            let major = CLBeaconMajorValue(course["major"] as! Int)
            let minor = CLBeaconMinorValue(course["minor"] as! Int)
            let localBeaconMajor: CLBeaconMajorValue = major
            let localBeaconMinor: CLBeaconMinorValue = minor
            
            let uuid = NSUUID(UUIDString: localBeaconUUID)!
            localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: "Your private identifer here")
            
            beaconPeripheralData = localBeacon.peripheralDataWithMeasuredPower(nil)
            peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        }
    }
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if peripheral.state == .PoweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as! [String: AnyObject]!)
        } else if peripheral.state == .PoweredOff {
            peripheralManager.stopAdvertising()
        }
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
