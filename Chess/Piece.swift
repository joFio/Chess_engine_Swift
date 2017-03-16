//
//  File.swift
//  Chess
//
//  Created by Jonathan on 31/12/16.
//  Copyright © 2016 Jonathan Fiorentini. All rights reserved.
//

import Foundation

struct Piece {
    var pieceType:PieceType
    let team:Bool // white = false, black = true
    
    var moved:Bool
    private (set) public var position:UInt64
    
    var bitboard:UInt64 {
        didSet {
            position = Bitboards.searchPosition(bitboard: bitboard)
        }
    }
    init (bitBoard:UInt64,pieceType:PieceType, team:Bool){
        self.bitboard = bitBoard
        self.pieceType = pieceType
        self.team = team
        self.moved = false
        self.position = Bitboards.searchPosition(bitboard: bitBoard)
    }
        
}

