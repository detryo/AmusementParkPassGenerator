//
//  Visitor.swift
//  AmusementParkPassGenerator
//
//  Created by Cristian Sedano Arenas on 23/10/2019.
//  Copyright © 2019 Cristian Sedano Arenas. All rights reserved.
//

import Foundation

// List the different types of visitors
enum EntrantType: String {
    case classicGuest = "Classic Guest Pass"
    case vipGuest = "VIP Guest Pass"
    case freeChildGuest = "Free Child Guest Pass"
    case season = "Season Pass"
    case senior = "Senior Pass"
    case foodServices = "Food Services Pass"
    case rideServices = "Ride Services Pass"
    case maintenance = "Maintenance Pass"
    case contract = "Contract Employee Pass"
    case manager = "Manager Pass"
    case vendor = "Vendor Pass"
}

// List the personal information that may be asked on the registration form.
enum PersonalInformation {
    case firstName
    case lastName
    case company
    case streetAddress
    case city
    case state
    case zipCode
    case SSN
    case dateOfBirth
    case projectNumber
    case managementTier
}

// List the different errors that are possible from missing data on the registration form.
enum RegistrationError: Error {
    case missingFirstName
    case missingLastName
    case missingStreetAddress
    case missingCity
    case missingState
    case incorrectStateName
    case missingZipCode
    case incorrectZipCode
    case missingSSN
    case incorrectSSN
    case missingCompany
    case missingDateOfBirth
    case missingProjectNumber
    case missingManagementTier
    case birthdayError
    case notYoungerThanFiveYearsOld
}

protocol SetUpVisitor {
    var entrantType: EntrantType { get }
    var personalInformation: [PersonalInformation: Any] { get }
}

struct Visitor: SetUpVisitor {
    var entrantType: EntrantType
    var personalInformation: [PersonalInformation: Any]
    
    // Perform error checking based on entrant type and the information that was entered into the form.
    func checkRegistrationForErrors(visitor: Visitor) throws -> Bool {
        do {
            switch visitor.entrantType {
            case .classicGuest, .vipGuest:
                // no required information
                return true
            case .freeChildGuest:
                if visitor.personalInformation[.dateOfBirth] == nil || (visitor.personalInformation[.dateOfBirth]) as? String == "" {
                    throw RegistrationError.missingDateOfBirth
                }
                else {
                    guard let date = visitor.personalInformation[.dateOfBirth] as? String else {
                        throw RegistrationError.birthdayError
                    }
                    let dateFormat = "MM/dd/yyyy"
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = dateFormat
                    
                    guard let birthDate = dateFormatter.date(from: date) else {
                        throw RegistrationError.birthdayError
                    }
                    guard let dateFiveYearsAgo = Calendar.current.date(byAdding: .year, value: -5, to: Date()) else {
                        throw RegistrationError.birthdayError
                    }
                    
                    if birthDate < dateFiveYearsAgo {
                        throw RegistrationError.notYoungerThanFiveYearsOld
                    }
                }
                return true
            case .foodServices, .rideServices, .maintenance:
                if visitor.personalInformation[.dateOfBirth] == nil || (visitor.personalInformation[.dateOfBirth]) as? String == "" { throw RegistrationError.missingDateOfBirth }
                if visitor.personalInformation[.SSN] == nil || (visitor.personalInformation[.SSN]) as? String == "" { throw RegistrationError.missingSSN }
                if let SSNCount = visitor.personalInformation[.SSN] as? String { if SSNCount.count != 11 { throw RegistrationError.incorrectSSN } }
                if visitor.personalInformation[.firstName] == nil || (visitor.personalInformation[.firstName]) as? String == "" { throw RegistrationError.missingFirstName }
                if visitor.personalInformation[.lastName] == nil || (visitor.personalInformation[.lastName]) as? String == "" { throw RegistrationError.missingLastName }
                if visitor.personalInformation[.streetAddress] == nil || (visitor.personalInformation[.streetAddress]) as? String == "" { throw RegistrationError.missingStreetAddress }
                if visitor.personalInformation[.city] == nil || (visitor.personalInformation[.city]) as? String == "" { throw RegistrationError.missingCity }
                if visitor.personalInformation[.state] == nil || (visitor.personalInformation[.state]) as? String == "" { throw RegistrationError.missingState }
                if (!states.contains(visitor.personalInformation[.state] as? String ?? "")) { throw RegistrationError.incorrectStateName }
                if visitor.personalInformation[.zipCode] == nil || (visitor.personalInformation[.zipCode]) as? String == "" { throw RegistrationError.missingZipCode }
                if let zipCodeCount = visitor.personalInformation[.zipCode] as? String { if zipCodeCount.count != 5 { throw RegistrationError.incorrectZipCode } }
                return true
            case .contract:
                if visitor.personalInformation[.dateOfBirth] == nil || (visitor.personalInformation[.dateOfBirth]) as? String == "" { throw RegistrationError.missingDateOfBirth }
                if visitor.personalInformation[.SSN] == nil || (visitor.personalInformation[.SSN]) as? String == "" { throw RegistrationError.missingSSN }
                if let SSNCount = visitor.personalInformation[.SSN] as? String { if SSNCount.count != 11 { throw RegistrationError.incorrectSSN } }
                if visitor.personalInformation[.projectNumber] == nil || (visitor.personalInformation[.projectNumber]) as? String == "" { throw RegistrationError.missingProjectNumber }
                if visitor.personalInformation[.firstName] == nil || (visitor.personalInformation[.firstName]) as? String == "" { throw RegistrationError.missingFirstName }
                if visitor.personalInformation[.lastName] == nil || (visitor.personalInformation[.lastName]) as? String == "" { throw RegistrationError.missingLastName }
                if visitor.personalInformation[.streetAddress] == nil || (visitor.personalInformation[.streetAddress]) as? String == "" { throw RegistrationError.missingStreetAddress }
                if visitor.personalInformation[.city] == nil || (visitor.personalInformation[.city]) as? String == "" { throw RegistrationError.missingCity }
                if visitor.personalInformation[.state] == nil || (visitor.personalInformation[.state]) as? String == "" { throw RegistrationError.missingState }
                if (!states.contains(visitor.personalInformation[.state] as? String ?? "")) { throw RegistrationError.incorrectStateName }
                if visitor.personalInformation[.zipCode] == nil || (visitor.personalInformation[.zipCode]) as? String == "" { throw RegistrationError.missingZipCode }
                if let zipCodeCount = visitor.personalInformation[.zipCode] as? String { if zipCodeCount.count != 5 { throw RegistrationError.incorrectZipCode } }
                return true
            case .manager:
                if visitor.personalInformation[.dateOfBirth] == nil || (visitor.personalInformation[.dateOfBirth]) as? String == "" { throw RegistrationError.missingDateOfBirth }
                if visitor.personalInformation[.SSN] == nil || (visitor.personalInformation[.SSN]) as? String == "" { throw RegistrationError.missingSSN }
                if let SSNCount = visitor.personalInformation[.SSN] as? String { if SSNCount.count != 11 { throw RegistrationError.incorrectSSN } }
                if visitor.personalInformation[.firstName] == nil || (visitor.personalInformation[.firstName]) as? String == "" { throw RegistrationError.missingFirstName }
                if visitor.personalInformation[.lastName] == nil || (visitor.personalInformation[.lastName]) as? String == "" { throw RegistrationError.missingLastName }
                if visitor.personalInformation[.streetAddress] == nil || (visitor.personalInformation[.streetAddress]) as? String == "" { throw RegistrationError.missingStreetAddress }
                if visitor.personalInformation[.city] == nil || (visitor.personalInformation[.city]) as? String == "" { throw RegistrationError.missingCity }
                if visitor.personalInformation[.state] == nil || (visitor.personalInformation[.state]) as? String == "" { throw RegistrationError.missingState }
                if (!states.contains(visitor.personalInformation[.state] as? String ?? "")) { throw RegistrationError.incorrectStateName }
                if visitor.personalInformation[.zipCode] == nil || (visitor.personalInformation[.zipCode]) as? String == "" { throw RegistrationError.missingZipCode }
                if let zipCodeCount = visitor.personalInformation[.zipCode] as? String { if zipCodeCount.count != 5 { throw RegistrationError.incorrectZipCode } }
                return true
            case .season:
                if visitor.personalInformation[.dateOfBirth] == nil || (visitor.personalInformation[.dateOfBirth]) as? String == "" { throw RegistrationError.missingDateOfBirth }
                if visitor.personalInformation[.firstName] == nil || (visitor.personalInformation[.firstName]) as? String == "" { throw RegistrationError.missingFirstName }
                if visitor.personalInformation[.lastName] == nil || (visitor.personalInformation[.lastName]) as? String == "" { throw RegistrationError.missingLastName }
                if visitor.personalInformation[.streetAddress] == nil || (visitor.personalInformation[.streetAddress]) as? String == "" { throw RegistrationError.missingStreetAddress }
                if visitor.personalInformation[.city] == nil || (visitor.personalInformation[.city]) as? String == "" { throw RegistrationError.missingCity }
                if visitor.personalInformation[.state] == nil || (visitor.personalInformation[.state]) as? String == "" { throw RegistrationError.missingState }
                if (!states.contains(visitor.personalInformation[.state] as? String ?? "")) { throw RegistrationError.incorrectStateName }
                if visitor.personalInformation[.zipCode] == nil || (visitor.personalInformation[.zipCode]) as? String == "" { throw RegistrationError.missingZipCode }
                if let zipCodeCount = visitor.personalInformation[.zipCode] as? String { if zipCodeCount.count != 5 { throw RegistrationError.incorrectZipCode } }
                return true
            case .senior:
                if visitor.personalInformation[.dateOfBirth] == nil || (visitor.personalInformation[.dateOfBirth]) as? String == "" { throw RegistrationError.missingDateOfBirth }
                if visitor.personalInformation[.firstName] == nil || (visitor.personalInformation[.firstName]) as? String == "" { throw RegistrationError.missingFirstName }
                if visitor.personalInformation[.lastName] == nil || (visitor.personalInformation[.lastName]) as? String == "" { throw RegistrationError.missingLastName }
                return true
            case .vendor:
                if visitor.personalInformation[.dateOfBirth] == nil || (visitor.personalInformation[.dateOfBirth]) as? String == "" { throw RegistrationError.missingDateOfBirth }
                if visitor.personalInformation[.firstName] == nil || (visitor.personalInformation[.firstName]) as? String == "" { throw RegistrationError.missingFirstName }
                if visitor.personalInformation[.lastName] == nil || (visitor.personalInformation[.lastName]) as? String == "" { throw RegistrationError.missingLastName }
                if visitor.personalInformation[.company] == nil || (visitor.personalInformation[.company]) as? String == "" { throw RegistrationError.missingCompany }
                return true
            }
        }
        catch RegistrationError.missingFirstName { print("Please enter in a first name.") }
        catch RegistrationError.missingLastName { print("Please enter in a last name.") }
        catch RegistrationError.missingStreetAddress { print("Please enter in a street address.") }
        catch RegistrationError.missingCity { print("Please enter in a city.") }
        catch RegistrationError.missingState { print("Please enter in a state.") }
        catch RegistrationError.incorrectStateName { print("Please enter in a correct state.") }
        catch RegistrationError.missingZipCode { print("Please enter in a zipcode.") }
        catch RegistrationError.incorrectZipCode { print("Please enter in a zipcode in the correct format.") }
        catch RegistrationError.missingSSN { print("Please enter in a social security number.") }
        catch RegistrationError.incorrectSSN { print("Please enter in a social security number in the correct format.") }
        catch RegistrationError.missingCompany { print("Please enter in a company name.")}
        catch RegistrationError.missingDateOfBirth { print("Please enter in a date of birth.") }
        catch RegistrationError.missingProjectNumber { print("Please enter in a Project Number.") }
        catch RegistrationError.birthdayError { print("There is an issue with the date of birth! Please verify it is entered in the format: MM/DD/YYYY") }
        catch RegistrationError.notYoungerThanFiveYearsOld { print("I'm sorry but you are too old for a Free Child Pass.")}
        return false
    }
}

