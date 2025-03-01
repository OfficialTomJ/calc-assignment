//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

var args = ProcessInfo.processInfo.arguments

// Remove the first element (program name)
args.removeFirst()

// Check if there are enough arguments
if args.count < 3 {
    print("Error: Invalid number of arguments.")
    exit(1)
}

// Print the first number to match the example provided
if let firstNumber = Int(args[0]) {
    print(firstNumber)
} else {
    print("Error: Invalid first number.")
    exit(1)
}
