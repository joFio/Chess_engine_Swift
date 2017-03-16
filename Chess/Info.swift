//
//  Info.swift
//  Chess
//
//  Created by Jonathan on 9/1/17.
//  Copyright © 2017 Jonathan Fiorentini. All rights reserved.
//

import Foundation

struct Info {
  
    var whiteKing:Piece
    var blackKing:Piece
    var whiteQueen:Piece?
    var blackQueen:Piece?
    var whiteBishops:(Piece?,Piece?)
    var blackBishops:(Piece?,Piece?)
    var whiteKnights:(Piece?,Piece?)
    var blackKnights:(Piece?,Piece?)
    var whiteRooks:(Piece?,Piece?)
    var blackRooks:(Piece?,Piece?)
    var whitePawns:[Piece]
    var blackPawns:[Piece]
    
    var whiteBitboard:UInt64
    var blackBitboard:UInt64
    
    var whitePawnEnpassantBitboard:UInt64
    var blackPawnEnpassantBitboard:UInt64
    //var whitePawns:[Piece]
    //var blackPawns:[Piece]
    var whiteBoard:[Piece]
    var blackBoard:[Piece]
    
  
    func getAllPieces()->[Piece] {
        return whiteBoard + blackBoard
    }
    func getTeamBitboard(team:Bool)-> UInt64{
        if team == false {
            return whiteBitboard
        }else {
            return blackBitboard
        }
    }
    func getAdversaryBitboard(team:Bool)-> UInt64{
        if team == true {
            return whiteBitboard
        }else {
            return blackBitboard
        }
    }
    func getTeamPieces(team:Bool)-> [Piece] {
        if team == false {
            return whiteBoard
        }else {
            return blackBoard
        }
    }
    func getAdversaryPieces(team:Bool)-> [Piece] {
        if team == true {
            return whiteBoard
        }else {
            return blackBoard
        }
    }
    func getTeamRooks(team:Bool)-> (Piece?,Piece?){
        if team == false {
            return whiteRooks
        }else {
            return blackRooks
        }
    }
    func getAdversaryRooks(team:Bool)-> (Piece?,Piece?){
        if team == true {
            return whiteRooks
        }else {
            return blackRooks
        }
    }
    func getTeamEnPassantBitboard(team:Bool)-> UInt64{
        if team == false {
            return whitePawnEnpassantBitboard
        }else {
            return blackPawnEnpassantBitboard
        }
    }
    func getAdversaryEnPassantBitboard(team:Bool)-> UInt64{
        if team == true {
            return whitePawnEnpassantBitboard
        }else {
            return blackPawnEnpassantBitboard
        }
    }
    func getTeamKing(team:Bool)-> Piece{
        if team == false {
            return whiteKing
        }else {
            return blackKing
        }
    }
    func getAdversaryKing(team:Bool)-> Piece{
        if team == true {
            return whiteKing
        }else {
            return blackKing
        }
    }
}
