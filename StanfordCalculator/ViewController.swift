//
//  ViewController.swift
//  StanfordCalculator
//
//  Created by Игорь on 11.10.16.
//  Copyright © 2016 Игорь. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var displayIsNotEmpty = false
    private let brain = CalculatorBrain()
    
    
    @IBOutlet private weak var CalculatorDisplay: UILabel!
    @IBOutlet private weak var HistoryDisplay: UILabel!
    
    
    @IBAction private func changeSignAction(_ sender: UIButton) {
        if displayIsNotEmpty {
            if CalculatorDisplay.text!.contains("-") {
                CalculatorDisplay.text = String(CalculatorDisplay.text!.characters.dropFirst())
            }
            else {
                CalculatorDisplay.text = "-" + CalculatorDisplay.text!
            }
        }
        else {
            performOperation(sender)
        }
    }
    
    @IBAction private func backspaceButtonAction(_ sender: UIButton) {
        
        if CalculatorDisplay.text! == "0" {
            return
        }
        else
        {
            CalculatorDisplay.text = String(CalculatorDisplay.text!.characters.dropLast())
            brain.setDescription(actionsDescription: String(brain.getDescription.characters.dropLast()))
            if CalculatorDisplay.text! == "" {
                CalculatorDisplay.text = String(0)
                displayIsNotEmpty = false
            }
        
        }
        
        
    }
    
    @IBAction private func NumbersButtonActions(_ sender: UIButton) {
        brain.setDescription(actionsDescription: brain.getDescription + sender.currentTitle!)
        if CalculatorDisplay.text!.contains(".") && sender.currentTitle == "." {
            return
        }
        let ButtonTaped = sender.currentTitle
        if displayIsNotEmpty {
            CalculatorDisplay.text = CalculatorDisplay.text! + ButtonTaped!
        }
        else
        {
            if CalculatorDisplay.text! == "0" && sender.currentTitle == "0" {
                CalculatorDisplay.text = "0"
            }
            else {
                CalculatorDisplay.text = ButtonTaped!
                displayIsNotEmpty = true
            }
        }
        
    }
    
    
    private var displayValue : Double {
        get{
            return Double(CalculatorDisplay.text!)!
        }
        set{
            if String(newValue).hasSuffix(".0") {
                CalculatorDisplay.text = String(Int64(newValue))
            }
            else
            {
                CalculatorDisplay.text = String(newValue)
            }
        }
    }
    
    @IBAction private func ClearButton(sender: UIButton) {
        CalculatorDisplay.text  = "0"
        brain.setOperand(operand: 0.0)
        brain.pending = nil
        displayIsNotEmpty = false
        HistoryDisplay.text = " "
        brain.setDescription(actionsDescription: "")
    }
    @IBAction private func performOperation(_ sender: UIButton) {
        if displayIsNotEmpty {
            brain.setOperand(operand: displayValue)
            displayIsNotEmpty = false
            
        }
        if let mathSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathSymbol)
        }
        
        displayValue = brain.result
        HistoryDisplay.text = brain.getDescription
    }
    
    
}

