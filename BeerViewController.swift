//
//  BeerViewController.swift
//  BeerOclock
//
//  Created by Sean Wiser on 5/29/15.
//  Copyright (c) 2015 Sean Wiser. All rights reserved.
//

import UIKit
import MessageUI
import MapKit
import AddressBook
import AddressBookUI


class BeerViewController: UIViewController, UINavigationControllerDelegate,  UITableViewDelegate, MFMessageComposeViewControllerDelegate, UITableViewDataSource, UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate {
  //CLLocationManagerDelegate,
  
  // Controllers
  var messageComposer: MFMessageComposeViewController?
  var personPicker: ABPeoplePickerNavigationController?
  var locationManager: CLLocationManager?
  
  // UIView Outlets
  @IBOutlet
  var groupMessage: UITextField?
  @IBOutlet
  weak var activityIndicator: UIActivityIndicatorView?
  @IBOutlet
  weak var groupTable: UITableView?
  
  // Data Models
  var selectedGroup: [String]?
  var groups: NSArray?
  
  
  // MARK: - BeerViewController
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // -- Initialize models
    groups = ["Kevin Hwa", "Chris Coleman", "Dmitry Kislyuk"]
    
    // -- Initialize Controllers
    // Group Table
    self.groupTable?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    // Message text composer
    messageComposer = nil//MFMessageComposeViewController()
    //    messageComposer?.delegate = self
    //    messageComposer?.messageComposeDelegate = self
    
    // People picker
    personPicker = ABPeoplePickerNavigationController()
    personPicker?.peoplePickerDelegate = self
//    personPicker?.predicateForSelectionOfPerson = [NSPredicate predicateWithFormat:@"%K.@count > 1", ABPersonPhoneNumbersProperty]
    var phoneProperty = NSNumber(int:kABPersonPhoneProperty)
    personPicker?.displayedProperties = [phoneProperty]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - TableViewDelegate
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return groups!.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = self.groupTable!.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
    cell.textLabel?.text = self.groups?[indexPath.row] as? String
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("You selected cell #\(indexPath.row)!")
    println("#\(groups![indexPath.row])")
  }
  
  // MARK: - MFMessageComposeViewControllerDelegate
  func messageComposeViewController(controller: MFMessageComposeViewController!,
    didFinishWithResult result: MessageComposeResult) {
      controller.dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: - UITextFieldDelegate
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    groupMessage?.text = textField.text
    return true;
  }
  
  // MARK: - Broadcasting
  @IBAction
  func sendMessage() {
    println("Sent Message \(groupMessage!.text)")
    if MFMessageComposeViewController.canSendText() {
      messageComposer?.recipients = ["1-650-773-8461"]
      messageComposer?.body = self.groupMessage?.text
      presentViewController(self.messageComposer!, animated: true, completion: nil)
    } else {
      // Let the user know if his/her device isn't able to send text messages
      let errorAlert = UIAlertView(title: "Cannot Send Text Message", message: "Your device is not able to send text messages.", delegate: self, cancelButtonTitle: "OK")
      errorAlert.show()
    }
  }
  
  // MARK: - Contacts
  @IBAction
  func performPickPerson(sender: AnyObject) {
    self.presentViewController(personPicker!, animated: true, completion: nil)
  }
  
  func peoplePickerNavigationControllerDidCancel(peoplePicker: ABPeoplePickerNavigationController!) {
    println("hi")
  }
  
  
  func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!, property: ABPropertyID, identifier: ABMultiValueIdentifier) {
    if (personPicker != peoplePicker) {
      println("Error, wrong contacts controller")
      return
    }
    let multiValue: ABMultiValueRef = ABRecordCopyValue(person, property).takeRetainedValue()
    let index = ABMultiValueGetIndexForIdentifier(multiValue, identifier)
    let email = ABMultiValueCopyValueAtIndex(multiValue, index).takeRetainedValue() as! String
    
    println("email = \(email)")
    println(identifier)
    println(person.phoneNumber)
  }
  
  
}
