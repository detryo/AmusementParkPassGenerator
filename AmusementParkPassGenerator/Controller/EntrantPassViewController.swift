//
//  EntrantPassViewController.swift
//  AmusementParkPassGenerator
//
//  Created by Cristian Sedano Arenas on 23/10/2019.
//  Copyright © 2019 Cristian Sedano Arenas. All rights reserved.
//

import UIKit

class EntrantPassViewController: UIViewController {

    @IBOutlet weak var entrantName: UILabel!
    @IBOutlet weak var passType: UILabel!
    @IBOutlet weak var rideAccess: UILabel!
    @IBOutlet weak var foodDiscount: UILabel!
    @IBOutlet weak var merchDiscount: UILabel!
    @IBOutlet weak var testResults: UILabel!
    
    var entrantPass = Pass(visitor: Visitor(entrantType: .classicGuest, personalInformation: [:]))
    var newVisitor = Visitor(entrantType: .classicGuest, personalInformation: [:])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        entrantName.text = entrantPass.entrantsName
        if newVisitor.entrantType == .manager {
            switch newVisitor.personalInformation[PersonalInformation.managementTier] {
            case ("Shift Manager" as String):
                passType.text = "Shift Manager"
            case ("General Manager" as String):
                passType.text = "General Manager"
            case ("Senior Manager" as String):
                passType.text = "Senior Manager"
            default:
                break
            }
        } else if newVisitor.entrantType == .vendor {
            switch newVisitor.personalInformation[PersonalInformation.company] {
            case ("Acme" as String):
                passType.text = "Vendor - Acme\rDate of visit: \(entrantPass.datePassCreated)"
            case ("Orkin" as String):
                passType.text = "Vendor - Orkin\rDate of visit: \(entrantPass.datePassCreated)"
            case ("Fedex" as String):
                passType.text = "Vendor - Fedex\rDate of visit: \(entrantPass.datePassCreated)"
            case ("NW Electrical" as String):
                passType.text = "Vendor - NW Electrical\rDate of visit: \(entrantPass.datePassCreated)"
            default:
                passType.text = "Vendor - General\rDate of visit: \(entrantPass.datePassCreated)"
            }
        } else {
            passType.text = newVisitor.entrantType.rawValue
        }
        rideAccess.text = entrantPass.rideAccess[0].rawValue
        foodDiscount.text = "\(entrantPass.discount[.food] ?? 0)% Food Discount"
        merchDiscount.text = "\(entrantPass.discount[.merchandise] ?? 0)% Merchandise Discount"

       
    }
  
    // Testing area simulating an "Entrant" swipping their pass for access and/or information (ie, discount).
    @IBAction func amusementAreaTestButton(_ sender: UIButton) {
        if checkForAreaAccess(area: .amusementArea) == true {
            testResults.backgroundColor = UIColor.green
            testResults.text = "ACCESS GRANTED!\r You have access to the Amusement Area!"
        } else {
            testResults.backgroundColor = UIColor.red
            testResults.text = "ACCESS DENIED!\r You DO NOT have access to the Amusement Area!"
        }
    }
    
    
    @IBAction func kitchenAreaTestButton(_ sender: UIButton) {
        if checkForAreaAccess(area: .kitchenArea) == true {
            testResults.backgroundColor = UIColor.green
            testResults.text = "ACCESS GRANTED!\r You have access to the Kitchen Area!"
        } else {
            testResults.backgroundColor = UIColor.red
            testResults.text = "ACCESS DENIED!\r You DO NOT have access to the Kitchen Area!"
        }
    }
    
    @IBAction func rideControlAreaTestButton(_ sender: UIButton) {
        if checkForAreaAccess(area: .rideControlArea) == true {
            testResults.backgroundColor = UIColor.green
            testResults.text = "ACCESS GRANTED!\r You have access to the Ride Control Area!"
        } else {
            testResults.backgroundColor = UIColor.red
            testResults.text = "ACCESS DENIED!\r You DO NOT have access to the Ride Control Area!"
        }
    }
    
    @IBAction func maintenanceAreaTestButton(_ sender: UIButton) {
        if checkForAreaAccess(area: .maintenanceArea) == true {
            testResults.backgroundColor = UIColor.green
            testResults.text = "ACCESS GRANTED!\r You have access to the Maintenance Area!"
        } else {
            testResults.backgroundColor = UIColor.red
            testResults.text = "ACCESS DENIED!\r You DO NOT have access to the Maintenance Area!"
        }
    }
    
    @IBAction func officeAreaTestButton(_ sender: UIButton) {
        if checkForAreaAccess(area: .officeArea) == true {
            testResults.backgroundColor = UIColor.green
            testResults.text = "ACCESS GRANTED!\r You have access to the Office Area!"
        } else {
            testResults.backgroundColor = UIColor.red
            testResults.text = "ACCESS DENIED!\r You DO NOT have access to the Office Area!"
        }
    }
    
    @IBAction func rideAndDiscountTestButton(_ sender: UIButton) {
        testResults.backgroundColor = UIColor.blue
        if entrantPass.rideAccess[0] == .canNotSkipLines {
            testResults.text = "You can ride all rides but you are not able to skip any lines.\rYou get a food discount of \(entrantPass.discount[.food] ?? 0)%.\rYou get a merchandise discount of \(entrantPass.discount[.merchandise] ?? 0)%."
        } else if entrantPass.rideAccess[0] == .canSkipLines{
            testResults.text = "You can ride all rides and you can skip all of the lines.\rYou get a food discount of \(entrantPass.discount[.food] ?? 0)%.\rYou get a merchandise discount of \(entrantPass.discount[.merchandise] ?? 0)%."
        } else {
            testResults.text = "You cannot ride any of the rides.\rYou get a food discount of \(entrantPass.discount[.food] ?? 0)%.\rYou get a merchandise discount of \(entrantPass.discount[.merchandise] ?? 0)%."
        }
    }
    
    // Dismiss seque and start over creating a new pass.
    @IBAction func createNewPassButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Function that determines if user has access to a specific area. Called in each of the "test" IBActions above.
    func checkForAreaAccess(area: AreaAccess) -> Bool {
        for index in 0..<entrantPass.areaAccess.count {
            if area == entrantPass.areaAccess[index] { return true }
        }
        return false
    }
}
