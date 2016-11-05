//
//  StanfordCalculatorTests.swift
//  StanfordCalculatorTests
//
//  Created by Игорь on 31.10.16.
//  Copyright © 2016 Игорь. All rights reserved.
//

import XCTest

@testable import StanfordCalculator


class StanfordCalculatorTests: XCTestCase {
    
    let brain = CalculatorBrain()
    
    override func setUp() {
        super.setUp()
        
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testOfAdd() {
        
        brain.setOperand(operand: 10)
        brain.performOperation(symbol: "+")
        brain.setOperand(operand: 10)
        brain.performOperation(symbol: "=")
        XCTAssert(brain.result == 20, "10+10 equals 20")
        
    }
    func testDividingByZero() {
        brain.setOperand(operand: 0)
        brain.performOperation(symbol: "÷")
        brain.setOperand(operand: 2)
        brain.performOperation(symbol: "=")
        XCTAssertNotNil(brain.result, "Dividing by zero is infinity \(brain.result)")
    }
    
    func testPI() {
        brain.performOperation(symbol: "π")
        XCTAssertEqual(brain.result, M_PI)
    }
    
    func testHistoryDescription() {
        brain.performOperation(symbol: "×")
        XCTAssertNotNil(brain.getDescription, "must be not nil and equals x...")
    }
    
    func testPendingOperation(){
        XCTAssertNil(brain.pending)
        brain.performOperation(symbol: "−")
        XCTAssertNotNil(brain.pending, "there is pending operation \" - \" ")
    }
    
    func testFactorialOperation() {
        brain.setOperand(operand: 5)
        brain.performOperation(symbol: "x!")
        XCTAssertEqual(brain.result, 120)
    }
    
    func testSquareRoot() {
        brain.setOperand(operand: 16)
        brain.performOperation(symbol: "√")
        XCTAssertEqual(brain.result, 4)
    }
    
    func testALotOfOperations() {
        brain.setOperand(operand: 12.55)
        brain.performOperation(symbol: "+")
        brain.setOperand(operand: 5.093)
        brain.performOperation(symbol: "√")
        brain.performOperation(symbol: "−")
        brain.setOperand(operand: 7)
        brain.performOperation(symbol: "=")
        XCTAssertLessThan(brain.result, 0, "Failed")
    }
    
    func testIsPartialResult() {
        XCTAssertFalse(brain.partialResult)
        brain.performOperation(symbol: "+")
        XCTAssertTrue(brain.partialResult)
    }
    
    func testPercent() {
        brain.setOperand(operand: 45)
        brain.performOperation(symbol: "%")
        XCTAssertLessThan(brain.result, 1)
    }
    
    func testChangeSign() {
        brain.setOperand(operand: -4)
        brain.performOperation(symbol: "±")
        XCTAssertGreaterThan(brain.result, 0)
    }
    
    func testSquarRootFromNegativeNumber() {
        brain.setOperand(operand: -23)
        brain.performOperation(symbol: "√")
        XCTAssertNotNil(brain.result, "square root from negative is NaN")
    }
    
    func testReplaceDotsMethod() {
        let testString = "...3...2...1"
        brain.setDescription(actionsDescription: testString)
        brain.replacingOfDotsInHistoryWith(str: " ")
        XCTAssertNotEqual(brain.getDescription, testString)
    }
    
    func testSquare() {
        brain.setOperand(operand: 10)
        brain.performOperation(symbol: "x²")
        XCTAssertEqual(brain.result, 100)
    }
    
}
