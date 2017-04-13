//
//  main.swift
//  ExtDomainModel
//
//  Created by iGuest on 4/13/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

protocol CustomStringConvertible {
    var description: String { get }
}

protocol Mathematics {
    func add(_: Money) -> Money
    func subtract(_: Money) -> Money
}

extension Double {
    var USD: Money {
        return Money(amount: Int(self), currency: "USD")
    }
    var EUR: Money {
        return Money(amount: Int(self), currency: "EUR")
    }
    var GBP: Money {
        return Money(amount: Int(self), currency: "GBP")
    }
    var CAN: Money {
        return Money(amount: Int(self), currency: "CAN")
    }
}

////////////////////////////////////
// Money
//
public struct Money : Mathematics, CustomStringConvertible{
    public var amount : Int
    public var currency : String
    
    let conversionRates = ["USD": 1, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
    
    var description: String {
        return "\(currency)\(Double(amount))"
    }
    
    public func convert(_ to: String) -> Money {
        var amount = self.amount
        let moneyType = Array(conversionRates.keys)
        if(!moneyType.contains(to)) {
            print("Invalid Money type. Non existent in this program")
        } else {
            amount = Int(Double(self.amount) / conversionRates[self.currency]!)
            let convertedAmount = Int(Double(amount) * conversionRates[to]!)
            amount = convertedAmount
        }
        return Money(amount: amount, currency: to)
    }
    
    public func add(_ to: Money) -> Money {
        var otherAmount = Money(amount: self.amount, currency: self.currency)
        if(self.currency != to.currency) {
            otherAmount = self.convert(to.currency)
        }
        return Money(amount: otherAmount.amount + to.amount, currency: otherAmount.currency)
    }
    
    public func subtract(_ from: Money) -> Money {
        var otherAmount = Money(amount: self.amount, currency: self.currency)
        if(self.currency != from.currency) {
            otherAmount = self.convert(from.currency)
        }
        return Money(amount: otherAmount.amount - from.amount, currency: otherAmount.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job : CustomStringConvertible {
    fileprivate var title : String
    fileprivate var type : JobType
    
    var description: String {
        return ("Works at \(title) and gets paid \(calculateIncome(10))")
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
        case .Hourly(let pay) :
            return Int(pay * Double(hours))
        case .Salary(let salary) :
            return salary
        }
    }
    
    open func raise(_ amt : Double) {
        switch self.type {
        case .Hourly(let pay) :
            self.type = JobType.Hourly(pay + amt)
        case .Salary(let salary) :
            self.type = JobType.Salary(salary + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person : CustomStringConvertible {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    var description: String {
        var result = ("\(self.firstName) \(self.lastName), \(self.age)")
        if let job = self._job {
            result = result + (", works at \(job)")
        }
        if let spouse = self._spouse {
            result = result + (", is married to \(spouse)")
        }
        return result
    }
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get { return _job}
        set(value) {
            if(self.age >= 16) {
                _job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { return _spouse}
        set(value) {
            if(self.age >= 18) {
                _spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
}

////////////////////////////////////
// Family
//
open class Family : CustomStringConvertible {
    fileprivate var members : [Person] = []
    
    var description: String {
        var result = "Family:"
        for member in self.members {
            result = result + " \(member.description)"
        }
        return result
    }
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            if spouse1.age >= 21 || spouse2.age >= 21 {
                spouse1.spouse = spouse2
                spouse2.spouse = spouse1
                members.append(spouse1)
                members.append(spouse2)
            }
        }
    }
    
    open func haveChild(_ child: Person) -> Bool {
        var ageChecker: Bool = false
        for person in members {
            if person.age >= 21 {
                ageChecker = true
            }
        }
        if ageChecker {
            members.append(child)
            return true
        } else {
            return false
        }
    }
    
    open func householdIncome() -> Int {
        var totalIncome = 0
        for person in self.members {
            if(person.job != nil) {
                totalIncome += (person.job?.calculateIncome(2000))!
            }
        }
        return totalIncome
    }
}
