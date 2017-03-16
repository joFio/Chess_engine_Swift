//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var test = readLine()

func input() -> String {
    let keyboard = FileHandle.standardInput
    let inputData = keyboard.availableData
    return (NSString(data: inputData, encoding: String.Encoding.utf8.rawValue) as! String)
}
print("Enter")
let string1 = input()
print("You typed: " + string1)
