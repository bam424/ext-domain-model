//
//  ExtDomainModelUnitTests.swift
//  ExtDomainModel
//
//  Created by iGuest on 4/13/17.
//  Copyright © 2017 iGuest. All rights reserved.
//

import XCTest

import ExtDomainModel

class ExtDomainModelUnitTests: XCTestCase {
    
     func testDescriptions() {
        let money = Money(amount: 12, currency: "EUR")
        print(money.description)
        XCTAssert(money.description == "EUR12.0")
        
        let jobTest = Job(title: "McDonalds", type: Job.JobType.Hourly(4))
        XCTAssert(jobTest.description == "Works at McDonalds and gets paid 40")
        
        let matt = Person(firstName: "Matthew", lastName: "Neward", age: 15)
        
        matt.job = Job(title: "Burger-Flipper", type: Job.JobType.Hourly(5.5))
        XCTAssert(matt.job == nil)
        
    }
    
    func testMathematics() {
        let money1 = Money(amount: 25, currency: "USD")
        let money2 = Money(amount: 10, currency: "USD")
        let sum = money1.add(_: money2)
        XCTAssert(sum.amount == 35)
        let money3 = Money(amount: 50, currency: "USD")
        let money4 = Money(amount: 10, currency: "USD")
        let difference = money3.subtract(_: money4)
        XCTAssert(difference.amount == 40)
    }
    
    func testExtension() {
        let test = Money.init(amount: 24, currency: "GBP")
        XCTAssert(test.description == "GBP24.0")
        let test2 = Money.init(amount: 10, currency: "EUR")
        XCTAssert(test2.description == "EUR10.0")
    }
}
