//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

var args = ProcessInfo.processInfo.arguments
args.removeFirst()

// If only one argument is provided, simply print it
if args.count == 1, let number = Int(args[0]) {
    print(number)
    exit(0)
}

// Check for valid input length
if args.count < 3 {
    print("Error: Invalid number of arguments.")
    exit(1)
}

// Helper function to perform arithmetic operations
func calculate(_ left: Int, _ right: Int, operation: String) -> Int? {
    switch operation {
    case "+":
        if (right > 0 && left > Int.max - right) || (right < 0 && left < Int.min - right) {
            print("Error: Integer overflow.")
            exit(1)
        }
        return left + right

    case "-":
        if (right < 0 && left > Int.max + right) || (right > 0 && left < Int.min + right) {
            print("Error: Integer underflow.")
            exit(1)
        }
        return left - right

    case "x":
        // Check for integer overflow and underflow before performing multiplication
        if left != 0 && right != 0 {
            if (left > 0 && right > 0 && left > Int.max / right) ||  // Positive * positive overflow
               (left < 0 && right < 0 && left < Int.max / right) ||  // Negative * negative overflow
               (left > 0 && right < 0 && right < Int.min / left) ||  // Positive * negative underflow
               (left < 0 && right > 0 && left < Int.min / right) {   // Negative * positive underflow
                print("Error: Integer overflow.")
                exit(1)
            }
        }
        return left * right
    case "/":
        if right == 0 {
            print("Error: Division by zero.")
            exit(1)
        }
        return left / right

    case "%":
        if right == 0 {
            print("Error: Modulus by zero.")
            exit(1)
        }
        return left % right

    default:
        print("Error: Invalid operator.")
        exit(1)
    }
}

// Function to handle operator precedence and evaluate expression
func evaluateExpression(_ args: [String]) -> Int {
    // First, handle x, /, and %
    var intermediateArgs = args
    var result = 0
    var i = 0
    
    // Step 1: Handle x, /, and % first
    while i < intermediateArgs.count {
        if intermediateArgs[i] == "x" || intermediateArgs[i] == "/" || intermediateArgs[i] == "%" {
            let left = Int(intermediateArgs[i-1])!
            let right = Int(intermediateArgs[i+1])!
            if let opResult = calculate(left, right, operation: intermediateArgs[i]) {
                intermediateArgs[i-1] = String(opResult)
                intermediateArgs.removeSubrange(i...i+1)
                i -= 1 // To recheck the updated expression
            }
        }
        i += 1
    }
    
    // Step 2: Handle + and -
    result = Int(intermediateArgs[0])!
    i = 1
    while i < intermediateArgs.count {
        let operation = intermediateArgs[i]
        let nextValue = Int(intermediateArgs[i+1])!
        if let opResult = calculate(result, nextValue, operation: operation) {
                   result = opResult
               }
        i += 2
    }

    return result
}

// Validate arguments: expect number, then operator, then number, repeated
for i in 0..<args.count {
    if i % 2 == 0 {  // Even index should be a number
        if Int(args[i]) == nil {
            print("Error: Invalid number at position \(i + 1).")
            exit(1)
        }
    } else {  // Odd index should be an operator
        if !["+", "-", "x", "/", "%"].contains(args[i]) {
            print("Error: Invalid operator at position \(i + 1).")
            exit(1)
        }
    }
}

// Evaluate and print the result
let result = evaluateExpression(args)
print(result)
