//
//  ViewController.swift
//  StanfordCalculator
//
//  Created by Игорь on 11.10.16.
//  Copyright © 2016 Игорь. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    private var displayIsNotEmpty = false
    private var needToCancelPendingOperation = false
    private let brain = CalculatorBrain()
    
    @IBOutlet var operationButton: [UIButton]!
    @IBOutlet private weak var calculatorDisplay: UILabel!
    @IBOutlet private weak var historyDisplay: UILabel!
    
    
    private var displayValue : Double {
        get {
            return Double(calculatorDisplay.text!)!
        }
        set {
            if String(newValue).hasSuffix(".0") {
                calculatorDisplay.text = String(Int64(newValue))
            }
            else {
                calculatorDisplay.text = String(newValue)
            }
        }
    }
    
    @IBAction private func changeSign(_ sender: UIButton) {
        if displayIsNotEmpty {
            if calculatorDisplay.text!.contains("-") {
                calculatorDisplay.text = String(calculatorDisplay.text!.characters.dropFirst())
            }
            else {
                calculatorDisplay.text = "-" + calculatorDisplay.text!
            }
        }
        else {
            performOperation(sender)
        }
    }
    
    @IBAction private func backspaceButton(_ sender: UIButton) {
        // need to handle history display
        if calculatorDisplay.text! == "0" {
            return
        } else if calculatorDisplay.text!.characters.count == 1 || calculatorDisplay.text == "0." || (calculatorDisplay.text!.characters.count == 2  && calculatorDisplay.text!.contains("-")) {
            calculatorDisplay.text = "0"
            brain.setOperand(operand: 0)
            displayIsNotEmpty = false
        } else {
            calculatorDisplay.text = String(calculatorDisplay.text!.characters.dropLast())
            brain.setOperand(operand: displayValue)
            displayIsNotEmpty = true
        }
        
        
    }
    
    @IBAction private func numberButton(_ sender: UIButton) {
        brain.setDescription(description: brain.getDescription + sender.currentTitle!)
        if calculatorDisplay.text!.contains(".") && sender.currentTitle == "." {
            return
        }
        let buttonTaped = sender.currentTitle
        if displayIsNotEmpty {
            calculatorDisplay.text = calculatorDisplay.text! + buttonTaped!
        }
        else
        {
            if brain.pendingOperation {
                needToCancelPendingOperation = false
            }
            if sender.currentTitle == "." {
                calculatorDisplay.text = "0."
                displayIsNotEmpty = true
                return
            }
            if calculatorDisplay.text! == "0" && sender.currentTitle == "0" {
                calculatorDisplay.text = "0"
            }
            else {
                calculatorDisplay.text = buttonTaped!
                displayIsNotEmpty = true
            }
        }
        
    }
    
    @IBAction private func clearButton(_ sender: UIButton) {
        calculatorDisplay.text  = "0"
        brain.setOperand(operand: 0.0)
        displayIsNotEmpty = false
        brain.previousOperation = false
        brain.pendingOperation = false
        historyDisplay.text = " "
        brain.setDescription(description: " ")
        deselectAllButtons()
    }
    
    
    
    /// Perfomrs operation on user tap. All calculation are performing in userInteractive queue, displaing in main queue.
    @IBAction private func performOperation(_ sender: UIButton) {
        markButtonAsSelected(sender)
        if needToCancelPendingOperation && sender.currentTitle != "=" {
            brain.pendingOperation = false
        }
        if displayIsNotEmpty {
            brain.setOperand(operand: displayValue)
            displayIsNotEmpty = false
        }
        DispatchQueue.global(qos: .userInteractive).async {
            if let mathSymbol = sender.currentTitle {
                self.brain.performOperation(symbol: mathSymbol)
                self.needToCancelPendingOperation = true
            }
            DispatchQueue.main.async {
                self.displayValue = self.brain.result
                self.historyDisplay.text = self.brain.getDescription
            }
        }
    }
    
    private func markButtonAsSelected(_ button: UIButton) {
        deselectAllButtons()
        if button.currentTitle != "=" {
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2
        }
        
    }
    private func deselectAllButtons() {
        for button in operationButton {
            if button.layer.borderWidth > 0 {
                button.layer.borderWidth = 0
            }
        }
    }
    
    
}

