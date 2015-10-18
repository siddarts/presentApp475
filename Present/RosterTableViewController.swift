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
    
    @IBAction func beaconDetails(sender: AnyObject) {
        let major = String(course["major"])
        let minor = String(course["minor"])
        let alert = UIAlertController(title: "Beacon Details", message: "Major: " + major + "\n" + "Minor: " + minor, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                print("default")
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
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
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
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
        let studentFName = student["firstName"] as! String
        let studentLName = student["lastName"] as! String
        let studentPName = studentLName + ", " + studentFName
        cell.studentName.text = studentPName
        
        //code below to change background color
        let allUserEvents = PFQuery(className: "User_Event")
        allUserEvents.whereKey("eventId", equalTo: course)
        allUserEvents.whereKey("userId", equalTo: student)
        var userEvents : [AnyObject] = []
        do {
            userEvents = try allUserEvents.findObjects() as [PFObject]
        } catch _ {
            userEvents = []
        }
        let userEvent = userEvents[0]
        let allLogs = PFQuery(className: "Log")
        allLogs.whereKey("userEventObjectId", equalTo: userEvent)
        var logs : [AnyObject] = []
        do {
            logs = try allLogs.findObjects() as [PFObject]
        } catch _ {
            logs = []
        }
        if logs.count == 0{
            cell.backgroundColor = UIColor.redColor()
        }else{
            cell.backgroundColor = UIColor.greenColor()
        }

        
        return cell
    }
    
    
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.backgroundColor = UIColor.greenColor()
//    }
    
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
