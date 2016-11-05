//
//  CalculatorBrain.swift
//  StanfordCalculator
//
//  Created by Игорь on 15.10.16.
//  Copyright © 2016 Игорь. All rights reserved.
//

import Foundation

private func factorial(op1: Double) -> Double
{
    if op1 != Double(Int(op1)) || op1 < 1 {return 0}
    if op1 == 1 {
        return 1
    }
    return op1 * factorial(op1: op1 - 1)
}

class CalculatorBrain {
    
    
    private var accumulator = 0.0
    private var isPartialResult  = false
    private var description = ""
    
    private var symbolList: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "ln": Operation.Constant(M_LN2),
        "√" : Operation.UnariOperation(sqrt),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "=" : Operation.Equals,
        "±" : Operation.UnariOperation({-$0}),
        "%" : Operation.UnariOperation({$0/100}),
        "x²": Operation.UnariOperation({$0*$0}),
        "x!": Operation.UnariOperation(factorial)
    ]

    
    
    private enum Operation {
        case Constant(Double)
        case UnariOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        if let operation = symbolList[symbol] {
            switch operation {
            case .Constant (let value): accumulator = value
                setDescription(actionsDescription: getDescription + symbol)
            case .UnariOperation(let foo): accumulator = foo(accumulator)
            if isPartialResult {
                replacingOfDotsInHistoryWith(str: symbol)
            }
            else
            {
                setDescription(actionsDescription: symbol + getDescription)
                }
            case .BinaryOperation (let function):
                replacingOfDotsInHistoryWith(str: "")
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(function: function, firstOpetand: accumulator)
                isPartialResult = true
                setDescription(actionsDescription: getDescription + symbol + "...")
                
            case .Equals:
                replacingOfDotsInHistoryWith(str: "")
                executePendingBinaryOperation()
                if getDescription.contains("=") {
                    setDescription(actionsDescription: getDescription.replacingOccurrences(of: "=", with: ""))
                    setDescription(actionsDescription: getDescription + "=")
                }
                else
                {
                    setDescription(actionsDescription: getDescription + "=")
                }
            }
        }
    }
    
    func replacingOfDotsInHistoryWith(str: String)
    {
        if getDescription.contains("...") {
            setDescription(actionsDescription: getDescription.replacingOccurrences(of: "...", with: str))
        }
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil{
            accumulator = pending!.function(pending!.firstOpetand, accumulator)
            pending = nil
            isPartialResult = false
        }
    }
    
    var pending : PendingBinaryOperationInfo?
    
    struct PendingBinaryOperationInfo {
        var function: (Double, Double) -> Double
        var firstOpetand: Double
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    func setDescription(actionsDescription: String) {
        description = actionsDescription
    }
    
    var partialResult : Bool {
        get{
            return isPartialResult
        }
    }
    
    var result : Double {
        get{
            return accumulator
        }
    }
    
    var getDescription : String {
        get{
            return description
        }
    }
    
}


