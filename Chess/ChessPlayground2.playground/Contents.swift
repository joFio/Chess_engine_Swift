//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
//
//  File.swift
//  Chess
//
//  Created by Jonathan on 31/12/16.
//  Copyright © 2016 Jonathan Fiorentini. All rights reserved.
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

let test = UInt64(2)
test^^test
struct BitboardSetup {
    // White Pieces
    
    static let WhiteRookQueen:UInt64 = 128
    static let WhiteKnightQueen:UInt64 = 64
    static let WhiteBishopQueen:UInt64 = 32
    static let WhiteQueen:UInt64 = 16
    static let WhiteKing:UInt64 = 8
    static let WhiteBishopKing:UInt64 = 4
    static let WhiteKnightKing:UInt64 = 2
    static let WhiteRookKing:UInt64 = 1
    static let WhitePawns:[UInt64] = [256,512,1024,2048,4096,8192,16384,32768]
    
    // Black Pieces
    static let BlackRookQueen:UInt64 = 9223372036854775808
    static let BlackKnightQueen:UInt64 = 4611686018427387904
    static let BlackBishopQueen:UInt64 = 2305843009213693952
    static let BlackQueen:UInt64 = 1152921504606846976
    static let BlackKing:UInt64 = 576460752303423488
    static let BlackBishopKing:UInt64 = 288230376151711744
    static let BlackKnightKing:UInt64 = 144115188075855872
    static let BlackRookKing:UInt64 = 72057594037927936
    static let BlackPawns:[UInt64] = [281474976710656,562949953421312,1125899906842624,2251799813685248,4503599627370496,9007199254740992,18014398509481984,36028797018963968]
}


enum PieceType {
    case Rook
    case Knight
    case Bishop
    case Queen
    case King
    case BlackPawn
    case WhitePawn
}



struct Piece {
    let pieceType:PieceType
    let team:Bool // white = false, black = true
    private (set) public var position:UInt64
    private (set) public var moved:Bool

    var bitBoard:UInt64 {
        didSet {
             position = Bitboards.searchPosition(piece: bitBoard)
        }
    }
    
    init (bitBoard:UInt64,pieceType:PieceType, team:Bool){
        self.bitBoard = bitBoard
        self.pieceType = pieceType
        self.team = team
        self.moved = false
        self.position = Bitboards.searchPosition(piece: bitBoard)
    }
    static func getMoveBitboard(bitboard:UInt64,position:UInt64,pieceType:PieceType,moved:Bool,teamBitboards:UInt64,adversaryBitboards:UInt64)->UInt64 {
        var mask = bitboard
        let bitboards = teamBitboards | adversaryBitboards
        switch pieceType {
        case .Rook:
            mask = mask | Bitboards.movesHorinzontal(piece: bitboard, position:position, bitboards:bitboards)
            mask = mask | Bitboards.movesVertical(piece: bitboard, position:position, bitboards:bitboards)
            mask = mask & ~teamBitboards
            break
        case .Knight:
            mask = mask | Bitboards.movesKnight(piece: bitboard, position:position)
            mask = mask & ~teamBitboards
            break
        case .Bishop:
            mask = mask | Bitboards.movesDiagonal(piece: bitboard, position:position, bitboards:bitboards)
            mask = mask & ~teamBitboards
        case .Queen:
            mask = mask | Bitboards.movesDiagonal(piece: bitboard, position:position, bitboards:bitboards)
            mask = mask | Bitboards.movesHorinzontal(piece: bitboard, position:position, bitboards:bitboards)
            mask = mask | Bitboards.movesVertical(piece: bitboard, position:position, bitboards:bitboards)
            mask = mask & ~teamBitboards
            break
        case .King:
            mask = mask | Bitboards.movesKing(piece: bitboard, position: position)
            mask = mask & ~teamBitboards
            break
        case .WhitePawn:
            mask = mask | Bitboards.movesToBlackOne(piece: bitboard, position: position)
            if moved == false {
                mask = mask | Bitboards.movesToBlackTwo(piece: bitboard, position: position)
            }
            mask = mask & ~bitboards
            var attackMask = Bitboards.movesToBlackLeftDiag(piece: bitboard, position:position)
            attackMask = attackMask | Bitboards.movesToBlackRightDiag(piece: bitboard, position:position)
            attackMask = attackMask & adversaryBitboards
            mask = mask|attackMask
            break
        case .BlackPawn:
            mask = mask | Bitboards.movesToWhiteOne(piece: bitboard, position: position)
            if moved == false {
                mask = mask | Bitboards.movesToWhiteTwo(piece: bitboard, position: position)
            }
            mask = mask & ~bitboards
            
            mask = mask & ~bitboards
            var attackMask = Bitboards.movesToWhiteLeftDiag(piece: bitboard, position:position)
            attackMask = attackMask | Bitboards.movesToWhiteRightDiag(piece: bitboard, position:position)
            attackMask = attackMask & adversaryBitboards
            mask = mask|attackMask
            break
        }
        return mask
    }
    

    func getMoveBitboard(teamBitboards:UInt64,adversaryBitboards:UInt64)->UInt64 {
        var mask = bitBoard
        let bitboards = teamBitboards | adversaryBitboards
        switch pieceType {
        case .Rook:
            mask = mask | Bitboards.movesHorinzontal(piece: bitBoard, position:position, bitboards:bitboards)
            mask = mask | Bitboards.movesVertical(piece: bitBoard, position:position, bitboards:bitboards)
            mask = mask & ~teamBitboards
            break
        case .Knight:
            mask = mask | Bitboards.movesKnight(piece: bitBoard, position:position)
            mask = mask & ~teamBitboards
            break
        case .Bishop:
            mask = mask | Bitboards.movesDiagonal(piece: bitBoard, position:position, bitboards:bitboards)
            mask = mask & ~teamBitboards
        case .Queen:
            mask = mask | Bitboards.movesDiagonal(piece: bitBoard, position:position, bitboards:bitboards)
            mask = mask | Bitboards.movesHorinzontal(piece: bitBoard, position:position, bitboards:bitboards)
            mask = mask | Bitboards.movesVertical(piece: bitBoard, position:position, bitboards:bitboards)
            mask = mask & ~teamBitboards
            break
        case .King:
            mask = mask | Bitboards.movesKing(piece: bitBoard, position: position)
            mask = mask & ~teamBitboards
            break
        case .WhitePawn:
            mask = mask | Bitboards.movesToBlackOne(piece: bitBoard, position: position)
            if moved == false {
                mask = mask | Bitboards.movesToBlackTwo(piece: bitBoard, position: position)
            }
            mask = mask & ~bitboards
            var attackMask = Bitboards.movesToBlackLeftDiag(piece: bitBoard, position:position)
            attackMask = attackMask | Bitboards.movesToBlackRightDiag(piece: bitBoard, position:position)
            attackMask = attackMask & adversaryBitboards
            mask = mask|attackMask
            break
        case .BlackPawn:
            mask = mask | Bitboards.movesToWhiteOne(piece: bitBoard, position: position)
            if moved == false {
                mask = mask | Bitboards.movesToWhiteTwo(piece: bitBoard, position: position)
            }
            mask = mask & ~bitboards

            mask = mask & ~bitboards
            var attackMask = Bitboards.movesToWhiteLeftDiag(piece: bitBoard, position:position)
            attackMask = attackMask | Bitboards.movesToWhiteRightDiag(piece: bitBoard, position:position)
            attackMask = attackMask & adversaryBitboards
            mask = mask|attackMask
            break
        }
        return mask
    }
}


struct Bitboards {
    
    static func searchPosition(piece:UInt64)->(UInt64) {
        if piece == 0 {
            return 0
        }
        var bound:UInt64 = 32
        var scope = bound
        var stop:Bool = false
        while stop == false {
            scope = scope/2
            if piece == UInt64(pow(Double(2), Double(bound))) {
                stop = true
            }else if piece > UInt64(pow(Double(2), Double(bound))) {
                bound = bound + scope
                if scope == 0 {
                    bound = bound + 1
                }
            }else {
                bound = bound - scope
                if scope == 0 {
                    bound = bound - 1
                }
            }
            if scope == 0 {
                stop = true
            }
        }
        bound  = bound + 1
        return UInt64(bound)
    }
    static func movesVertical(piece:UInt64,position:UInt64)->UInt64 {
        let position = searchPosition(piece: piece)
        var row = position / 8
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        var rowdec = row
        var rowinc = row
        while rowdec > 1 {
            rowdec -= 1
            mask = mask | (piece >> (8*(row-rowdec)))
        }
        while rowinc < 8 {
            rowinc += 1
            mask = mask | (piece << (8*(rowinc-row)))
        }
        return mask
    }
    static func movesVertical(piece:UInt64,position:UInt64,bitboards:UInt64)->UInt64 {
        let position = searchPosition(piece: piece)
        var row = position / 8
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        var rowdec = row
        var rowinc = row
        while rowdec > 1 {
            rowdec -= 1
            let offset = (8*(row-rowdec))
            let bit = piece >> offset
            mask = mask | (piece >> offset)

            if bit & bitboards != 0 {
                break
            }
        }
        while rowinc < 8 {
            rowinc += 1
            let offset = (8*(rowinc-row))
            let bit = piece << offset
            mask = mask | (piece << offset)
            if bit & bitboards != 0 {
                break
            }
        }
        return mask
    }
 
    static func movesHorinzontal(piece:UInt64,position:UInt64)->UInt64 {
        var col = (position % 8)
        col = col == 0 ? 8 : col
        var mask = piece
        var coldec = col
        var colinc = col
        while coldec > 1 {
            coldec -= 1
            mask = mask | (piece >> (col-coldec))
        }
        while colinc < 8 {
            colinc += 1
            mask = mask | (piece << (colinc-col))
        }
        return mask
    }
    static func movesHorinzontal(piece:UInt64,position:UInt64,bitboards:UInt64)->UInt64 {
        var col = (position % 8)
        col = col == 0 ? 8 : col
        var mask = piece
        var coldec = col
        var colinc = col
        while coldec > 1 {
            coldec -= 1
            let offset = (col-coldec)
            let bit = piece >> offset
            mask = mask | (piece >> offset)
            if bit & bitboards != 0 {
                break
            }
        }
        while colinc < 8 {
            colinc += 1
            let offset = (colinc-col)
            let bit = piece << offset
            mask = mask | (piece << offset)
            if bit & bitboards != 0 {
                break
            }
        }
        return mask
    }
    static func movesDiagonal(piece:UInt64)->UInt64 {
        let position = searchPosition(piece: piece)
        return movesDiagonal(piece:piece,position:position)
    }
    static func movesDiagonal(piece:UInt64,position:UInt64,bitboards:UInt64)->UInt64 {
        var col = (position % 8)
        col = col == 0 ? 8 : col
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        var coldec = col
        var colinc = col
        var rowdec = row
        var rowinc = row
        let resetInstruction = {()->() in
            coldec = col
            colinc = col
            rowdec = row
            rowinc = row
        }
        while colinc < 8 && rowinc < 8 {
            rowinc += 1
            colinc += 1
            let offset = (colinc-col) + (8*(rowinc-row))
            let bit = piece << offset
            mask = mask | (piece << offset)
            if bit & bitboards != 0 {
                break
            }
        }
        resetInstruction()
        while colinc < 8 && rowdec > 1{
            rowdec -= 1
            colinc += 1
            let offset =  (8*(row-rowdec))-(colinc-col)
            let bit = (piece >> (offset))
            mask = mask | (piece >> (offset))
            if bit & bitboards != 0 {
                break
            }
        }
        resetInstruction()
        while coldec > 1 && rowdec > 1 {
            rowdec -= 1
            coldec -= 1
            let offset =  (8*(row-rowdec)) + (col-coldec)
            let bit = (piece >> (offset))
            mask = mask | (piece >> (offset))
            if bit & bitboards != 0 {
                break
                
            }
        }
        resetInstruction()
        while coldec > 1 && rowinc < 8 {
            rowinc += 1
            coldec -= 1
            let offset =  (8*(rowinc-row)) - (col-coldec)
            let bit = (piece << (offset))
            mask = mask | (piece << (offset))
            if bit & bitboards != 0 {
                break
            }
        }
        return mask
    }

    static func movesDiagonal(piece:UInt64,position:UInt64)->UInt64 {
        var col = (position % 8)
        col = col == 0 ? 8 : col
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        var coldec = col
        var colinc = col
        var rowdec = row
        var rowinc = row
        let resetInstruction = {()->() in
            coldec = col
            colinc = col
            rowdec = row
            rowinc = row
        }
        while colinc < 8 && rowinc < 8{
            rowinc += 1
            colinc += 1
            let offset = (colinc-col) + (8*(rowinc-row))
            mask = mask | (piece << offset)
        }
        resetInstruction()
        while colinc < 8 && rowdec > 1{
            rowdec -= 1
            colinc += 1
            let offset =  (8*(row-rowdec))-(colinc-col)
            mask = mask | (piece >> (offset))
        }
        resetInstruction()
        while coldec > 1 && rowdec > 1{
            rowdec -= 1
            coldec -= 1
            let offset =  (8*(row-rowdec)) + (col-coldec)
            mask = mask | (piece >> (offset))
        }
        resetInstruction()
        while coldec > 1 && rowinc < 8{
            rowinc += 1
            coldec -= 1
            let offset =  (8*(rowinc-row)) - (col-coldec)
            mask = mask | (piece << (offset))
        }
        return mask
    }
    
    static func movesKnight(piece:UInt64)->UInt64{
        let position = searchPosition(piece: piece)
        return movesKnight(piece:piece,position:position)
    }
    static func movesKnight(piece:UInt64,position:UInt64)->UInt64{
        var col = (position % 8)
        col = col == 0 ? 8 : col
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        if row < 7 && col > 1  {
            mask = mask | (piece << (15))
        }
        if row < 7 && col < 8 {
            mask = mask | (piece << (17))
        }
        if row < 8 && col > 2 {
            mask = mask | (piece << (6))
        }
        if row < 8 && col < 7 {
            mask = mask | (piece << (10))
        }
        if row > 1 && col < 7 {
            mask = mask | (piece >> (6))
        }
        if row > 1 && col > 2 {
            mask = mask | (piece >> (10))
        }
        if row > 2 && col > 1 {
            mask = mask | (piece >> (17))
        }
        if row > 2 && col < 8 {
            mask = mask | (piece >> (15))
        }
        return mask
    }
    
    static func movesKing(piece:UInt64)->UInt64 {
        let position = searchPosition(piece: piece)
        return movesKing(piece:piece,position:position)
    }
    static func movesKing(piece:UInt64,position:UInt64)->UInt64 {
        var col = (position % 8)
        col = col == 0 ? 8 : col
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        if row < 8 && col > 1  {
            mask = mask | (piece << (7))
        }
        if row > 1 && col < 8 {
            mask = mask | (piece >> (7))
        }
        if row < 8 && col < 8{
            mask = mask | (piece << (9))
        }
        if row > 1 && col > 1 {
            mask = mask | (piece >> (9))
        }
        if row < 8 {
            mask = mask | (piece << (8))
        }
        if row > 1 {
            mask = mask | (piece >> (8))
        }
        if col > 1 {
            mask = mask | (piece >> (1))
        }
        if col < 8 {
            mask = mask | (piece << (1))
        }
        return mask
    }
    
    static  func movesToBlackOne(piece:UInt64,position:UInt64)->UInt64 {
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        if row < 8 {
            mask = mask | (piece << (8))
        }
        return mask
    }
    static  func movesToBlackTwo(piece:UInt64,position:UInt64)->UInt64 {
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        if row < 7 {
            mask = mask | (piece << (16))
        }
        return mask
    }
    static func movesToWhiteOne(piece:UInt64,position:UInt64)->UInt64 {
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        if row > 1 {
            mask = mask | (piece >> (8))
        }
        return mask
    }
    static func movesToWhiteTwo(piece:UInt64,position:UInt64)->UInt64 {
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        if row > 2 {
            mask = mask | (piece >> (16))
        }
        return mask
    }
    static func movesToWhiteRightDiag(piece:UInt64,position:UInt64)->UInt64 {
        var col = (position % 8)
        col = col == 0 ? 8 : col
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        
        if row > 1 && col > 1 {
            mask = mask | (piece >> (9))
        }
        return mask
    }
    static  func movesToWhiteLeftDiag(piece:UInt64,position:UInt64)->UInt64 {
        var col = (position % 8)
        col = col == 0 ? 8 : col
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        
        if row > 1 && col < 8 {
            mask = mask | (piece >> (7))
        }
        return mask
    }
    static  func movesToBlackRightDiag(piece:UInt64,position:UInt64)->UInt64 {
        var col = (position % 8)
        col = col == 0 ? 8 : col
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        if row < 8 && col > 1  {
            mask = mask | (piece << (7))
        }
        return mask
    }
    static  func movesToBlackLeftDiag(piece:UInt64,position:UInt64)->UInt64 {
        var col = (position % 8)
        col = col == 0 ? 8 : col
        var row = (position / 8)
        row =  position % 8 == 0 ? row : row + 1
        var mask = piece
        
        if col < 8 &&  row < 8  {
            mask = mask | (piece << (9))
        }
        return mask
    }
    
}
struct ChessGame{
    var board:[Piece] // Collection of pieces
    init() {
        let whiteRookQueen = Piece(bitBoard: BitboardSetup.WhiteRookQueen, pieceType: .Rook, team: false)
        let whiteKnightQueen = Piece(bitBoard: BitboardSetup.WhiteKnightQueen, pieceType: .Knight, team: false)
        let whiteBishopQueen = Piece(bitBoard: BitboardSetup.WhiteBishopQueen, pieceType: .Bishop, team: false)
        let whiteQueen = Piece(bitBoard: BitboardSetup.WhiteQueen, pieceType: .Queen, team: false)
        let whiteKing = Piece(bitBoard: BitboardSetup.WhiteKing, pieceType: .King, team: false)
        let whiteBishopKing = Piece(bitBoard: BitboardSetup.WhiteBishopKing, pieceType: .Bishop, team: false)
        let whiteKnightKing = Piece(bitBoard: BitboardSetup.WhiteKnightKing, pieceType: .Knight, team: false)
        let whiteRookKing = Piece(bitBoard: BitboardSetup.WhiteRookKing, pieceType: .Rook, team: false)
        var whitePawns = [Piece]()
        BitboardSetup.WhitePawns.forEach({(bitboard) in whitePawns.append(Piece(bitBoard: bitboard, pieceType: .WhitePawn, team: false))})
        
        let blackRookQueen = Piece(bitBoard: BitboardSetup.BlackRookQueen, pieceType: .Rook, team: true)
        let blackKnightQueen = Piece(bitBoard: BitboardSetup.BlackKnightQueen, pieceType: .Knight, team: true)
        let blackBishopQueen = Piece(bitBoard: BitboardSetup.BlackBishopQueen, pieceType: .Bishop, team: true)
        let blackQueen = Piece(bitBoard: BitboardSetup.BlackQueen, pieceType: .Queen, team: true)
        let blackKing = Piece(bitBoard: BitboardSetup.BlackKing, pieceType: .King, team: true)
        let blackBishopKing = Piece(bitBoard: BitboardSetup.BlackBishopKing, pieceType: .Bishop, team: true)
        let blackKnightKing = Piece(bitBoard: BitboardSetup.BlackKnightKing, pieceType: .Knight, team: true)
        let blackRookKing = Piece(bitBoard: 262144, pieceType: .Rook, team: true)
        var blackPawns = [Piece]()
        BitboardSetup.BlackPawns.forEach({(bitboard) in blackPawns.append(Piece(bitBoard: bitboard, pieceType: .BlackPawn, team: true))})
        self.board = [Piece]()
        self.board.append(whiteRookQueen)
        self.board.append(whiteKnightQueen)
        self.board.append(whiteBishopQueen)
        self.board.append(whiteQueen)
        self.board.append(whiteKing)
        self.board.append(whiteBishopKing)
        self.board.append(whiteKnightKing)
        self.board.append(whiteRookKing)
        self.board.append(contentsOf: whitePawns)
        self.board.append(blackRookQueen)
        self.board.append(blackKnightQueen)
        self.board.append(blackBishopQueen)
        self.board.append(blackQueen)
        self.board.append(blackKing)
        self.board.append(blackBishopKing)
        self.board.append(blackKnightKing)
        self.board.append(blackRookKing)
        self.board.append(contentsOf: blackPawns)
    }

}

func getNextPositionsforPiece(selectedPiece:Piece,board:[Piece])->UInt64 {
    var teamMask:UInt64 = 0
    var adversaryMask:UInt64 = 0
    for piece in board {
        if piece.team == selectedPiece.team {
            teamMask = teamMask | piece.bitBoard
        }else {
            adversaryMask = adversaryMask | piece.bitBoard
        }
    }
    let moveMasks = Piece.getMoveBitboard(bitboard:selectedPiece.bitBoard,position:selectedPiece.position,pieceType:selectedPiece.pieceType,moved:selectedPiece.moved,teamBitboards:teamMask,adversaryBitboards:adversaryMask)
    return moveMasks
}


func getPieceForPosition(board:[Piece], position:UInt64)->Piece?{
    for piece in board {
        if piece.position == position {
            return piece
        }
    }
    return nil
}

let newGame = ChessGame()
let blackQueen = Piece(bitBoard: BitboardSetup.WhiteQueen, pieceType: .Queen, team: true)
let tesdasd = getNextPositionsforPiece(selectedPiece:blackQueen,board:newGame.board)

let asdd3 = getNextPositionsforPiece(selectedPiece:blackQueen,board:newGame.board)

