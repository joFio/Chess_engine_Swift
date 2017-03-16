//
//  Extension.swift
//  Chess
//
//  Created by Jonathan on 2/1/17.
//  Copyright © 2017 Jonathan Fiorentini. All rights reserved.
//

import Foundation

infix operator ^^
extension UInt64 {
    var bits:String {
        var bb = String(self, radix: 2)
        let repCount = 64 - bb.characters.count
        let temp = [Character](repeating:"0",count: repCount)
        temp.forEach({(string) in bb.insert(string, at: bb.startIndex)})
        return bb }
    var bitboard:String {
        var bb:String = ""
        for i in (0..<8) {
            let temp = "\(self.bits.substring(with: Range(self.bits.index(self.bits.startIndex, offsetBy: i*8)..<self.bits.index(self.bits.startIndex, offsetBy: i*8+8))))\n"
            bb.append(temp)
        }
        return bb
    }
    func toBitboard(){
        print(self.bitboard)
    }
    
     static func ^^ (left:UInt64, right:UInt64)->UInt64 {
        return UInt64(pow(Float(left), Float(right)))
    }
}

