//
//  Pass.swift
//  AmusementParkPassGenerator
//
//  Created by Cristian Sedano Arenas on 23/10/2019.
//  Copyright © 2019 Cristian Sedano Arenas. All rights reserved.
//

import Foundation

enum AreaAccess: String {
    case amusementArea = "Amusement Area"
    case kitchenArea = "Kitchen Area"
    case rideControlArea = "Ride Control Area"
    case maintenanceArea = "Maintenance Area"
    case officeArea = "Office Area"
}

// List whether a user can skip lines or cannot skip lines.
enum RideAccess: String {
    case canNotSkipLines = "Unlimited rides, no skipping lines"
    case canSkipLines = "Unlimited rides, can skip lines"
    case canNotRide = "Cannot ride rides"
}

// List the different types of discounts offered.
enum Discount {
    case food
    case merchandise
}

// Class declaration for Pass
class Pass {
    var entrantsName: String = ""
    var areaAccess: [AreaAccess] = []
    var rideAccess: [RideAccess] = []
    var discount: [Discount: Int] = [:]
    let date = Date()
    let formatter = DateFormatter()
    let datePassCreated: String

    init (visitor: Visitor) {
        formatter.dateFormat = "MM/dd/yyyy"
        datePassCreated = formatter.string(from: date)
        
        if let firstName = visitor.personalInformation[.firstName], let lastName = visitor.personalInformation[.lastName] {
            entrantsName = "\(firstName) \(lastName)"
        }
        
        // Set values of based on entrant type according to the buisness rules.
        switch visitor.entrantType {
        case .classicGuest:
            areaAccess.append(.amusementArea)
            rideAccess.append(.canNotSkipLines)
            discount = [.food: 0, .merchandise: 0]
        case .vipGuest:
            areaAccess.append(.amusementArea)
            rideAccess.append(.canSkipLines)
            discount = [.food: 10, .merchandise: 20]
        case .freeChildGuest:
            areaAccess.append(.amusementArea)
            rideAccess.append(.canNotSkipLines)
            discount = [.food: 0, .merchandise: 0]
        case .foodServices:
            areaAccess.append(.amusementArea)
            areaAccess.append(.kitchenArea)
            rideAccess.append(.canNotSkipLines)
            discount = [.food: 15, .merchandise: 25]
        case .rideServices:
            areaAccess.append(.amusementArea)
            areaAccess.append(.rideControlArea)
            rideAccess.append(.canNotSkipLines)
            discount = [.food: 15, .merchandise: 25]
        case .maintenance:
            areaAccess.append(.amusementArea)
            areaAccess.append(.kitchenArea)
            areaAccess.append(.rideControlArea)
            areaAccess.append(.maintenanceArea)
            rideAccess.append(.canNotSkipLines)
            discount = [.food: 15, .merchandise: 25]
        case .contract:
            switch (visitor.personalInformation[.projectNumber]) as? String {
            case "1001":
                areaAccess.append(.amusementArea)
                areaAccess.append(.rideControlArea)
                rideAccess.append(.canNotRide)
            case "1002":
                areaAccess.append(.amusementArea)
                areaAccess.append(.rideControlArea)
                areaAccess.append(.maintenanceArea)
                rideAccess.append(.canNotRide)
            case "1003":
                areaAccess.append(.amusementArea)
                areaAccess.append(.rideControlArea)
                areaAccess.append(.kitchenArea)
                areaAccess.append(.maintenanceArea)
                areaAccess.append(.officeArea)
                rideAccess.append(.canNotRide)
            case "2001":
                areaAccess.append(.officeArea)
                rideAccess.append(.canNotRide)
            case "2002":
                areaAccess.append(.kitchenArea)
                areaAccess.append(.maintenanceArea)
                rideAccess.append(.canNotRide)
            default:
                break
            }
            discount = [.food: 0, .merchandise: 0]
        case .vendor:
            switch (visitor.personalInformation[.company]) as? String {
            case "Acme":
                areaAccess.append(.kitchenArea)
                rideAccess.append(.canNotRide)
            case "Orkin":
                areaAccess.append(.amusementArea)
                areaAccess.append(.rideControlArea)
                areaAccess.append(.kitchenArea)
                rideAccess.append(.canNotRide)
            case "Fedex":
                areaAccess.append(.maintenanceArea)
                areaAccess.append(.officeArea)
                rideAccess.append(.canNotRide)
            case "NW Electrical":
                areaAccess.append(.amusementArea)
                areaAccess.append(.rideControlArea)
                areaAccess.append(.kitchenArea)
                areaAccess.append(.maintenanceArea)
                areaAccess.append(.officeArea)
                rideAccess.append(.canNotRide)
            default:
                rideAccess.append(.canNotRide)
            }
            discount = [.food: 0, .merchandise: 0]
        case .manager:
            areaAccess.append(.amusementArea)
            areaAccess.append(.kitchenArea)
            areaAccess.append(.rideControlArea)
            areaAccess.append(.maintenanceArea)
            areaAccess.append(.officeArea)
            rideAccess.append(.canNotSkipLines)
            discount = [.food: 25, .merchandise: 25]
        case .season:
            areaAccess.append(.amusementArea)
            rideAccess.append(.canSkipLines)
            discount = [.food: 10, .merchandise: 20]
        case .senior:
            areaAccess.append(.amusementArea)
            rideAccess.append(.canSkipLines)
            discount = [.food: 10, .merchandise: 10]
        }
    }
}

extension Pass {
    func swipeTheEntrants (pass: Pass, forAccessTo: AreaAccess? = nil, toSkipLines: Bool? = nil, getsDiscountOnFood: Discount? = nil, getsDiscountOnMerchandise: Discount? = nil) {
        
        var resultOfSwipingThePass: [String] = [] // Array to store the results of the "swipe".
        var temporaryCountingVariable: Int = 0  // Temporary local variable used for checking array to see if the visitory has been granted access to a specific area.
        
        for index in 0..<pass.areaAccess.count {
            if forAccessTo == pass.areaAccess[index] {
                if let accessTo = forAccessTo?.rawValue {
                    resultOfSwipingThePass.append("\(entrantsName) has access to the \(accessTo).") }
            }
            else { temporaryCountingVariable += 1 }
            if temporaryCountingVariable == pass.areaAccess.count {
                if let accessTo = forAccessTo?.rawValue {
                    resultOfSwipingThePass.append("\(entrantsName) DOES NOT have access to the \(accessTo).") }
            }
        }
        
        if toSkipLines != nil {
            switch pass.rideAccess[0] {
            case .canSkipLines:
                resultOfSwipingThePass.append("\(entrantsName) can ride all rides and skip ride lines.")
            default:
                resultOfSwipingThePass.append("\(entrantsName) can ride all rides but cannot skip any lines.")
            }
        }
        
        if getsDiscountOnFood != nil {
            if let foodDiscount = pass.discount[.food] { resultOfSwipingThePass.append("\(entrantsName) has a food disount of: \(foodDiscount)%")}
        }
        if getsDiscountOnMerchandise != nil {
            if let merchandiseDiscount = pass.discount[.merchandise] { resultOfSwipingThePass.append("\(entrantsName) has a merchandise disount of: \(merchandiseDiscount)%") }
        }
        
        // Print out the results of the array to the screen.
        for index in 0..<resultOfSwipingThePass.count {
            print(resultOfSwipingThePass[index])
        }
    }
}
