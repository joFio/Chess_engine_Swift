//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

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

enum PieceType {
    case Rook
    case Knight
    case Bishop
    case Queen
    case King
    case BlackPawn
    case WhitePawn
}

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

struct ChessGame{
    var board:[Piece] // Collection of pieces
    init() {
        let whiteRookQueen = Piece(bitBoard: BitboardSetup.WhiteRookQueen, pieceType: .Rook, team: false)
        let whiteKnightQueen = Piece(bitBoard: BitboardSetup.WhiteKnightQueen, pieceType: .Knight, team: false)
        let whiteBishopQueen = Piece(bitBoard: BitboardSetup.WhiteBishopQueen, pieceType: .Bishop, team: false)
        let whiteQueen = Piece(bitBoard: 35184372088832, pieceType: .Queen, team: false)
        let whiteKing = Piece(bitBoard: BitboardSetup.WhiteKing, pieceType: .King, team: false)
        let whiteBishopKing = Piece(bitBoard: BitboardSetup.WhiteBishopKing, pieceType: .Bishop, team: false)
        let whiteKnightKing = Piece(bitBoard: BitboardSetup.WhiteKnightKing, pieceType: .Knight, team: false)
        let whiteRookKing = Piece(bitBoard: BitboardSetup.WhiteRookKing, pieceType: .Rook, team: false)
        var whitePawns = [Piece]()
        BitboardSetup.WhitePawns.forEach({(bitboard) in whitePawns.append(Piece(bitBoard: bitboard, pieceType: .WhitePawn, team: false))})
        let blackRookQueen = Piece(bitBoard: BitboardSetup.BlackRookQueen, pieceType: .Rook, team: true)
        let blackKnightQueen = Piece(bitBoard: BitboardSetup.BlackKnightQueen, pieceType: .Knight, team: true)
        let blackBishopQueen = Piece(bitBoard: BitboardSetup.BlackBishopQueen, pieceType: .Bishop, team: true)
        let blackQueen = Piece(bitBoard: 524288, pieceType: .Queen, team: true)
        let blackKing = Piece(bitBoard: BitboardSetup.BlackKing, pieceType: .King, team: true)
        let blackBishopKing = Piece(bitBoard: BitboardSetup.BlackBishopKing, pieceType: .Bishop, team: true)
        let blackKnightKing = Piece(bitBoard: BitboardSetup.BlackKnightKing, pieceType: .Knight, team: true)
        let blackRookKing = Piece(bitBoard: BitboardSetup.BlackRookKing, pieceType: .Rook, team: true)
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

struct Piece {
        let pieceType:PieceType
        let team:Bool // white = false, black = true
        
        private (set) public var moved:Bool
        private (set) public var position:UInt64
        
        var bitboard:UInt64 {
            didSet {
                position = Bitboards.searchPosition(piece: bitboard)
            }
        }
        init (bitBoard:UInt64,pieceType:PieceType, team:Bool){
            self.bitboard = bitBoard
            self.pieceType = pieceType
            self.team = team
            self.moved = false
            self.position = Bitboards.searchPosition(piece: bitBoard)
        }
        
        static func getPieceAtPositionInBoard(board:[Piece], position:UInt64)->Piece?{
            for piece in board {
                if piece.position == position {
                    return piece
                }
            }
            return nil
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
        static func movesVertical(piece:UInt64,position:UInt64,bitboards:UInt64)->UInt64 {
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
       static func getMoveBitboard(piece:Piece,info:(UInt64,UInt64,Piece,Piece,[Piece],[Piece]),check:Bool)->UInt64{
            let team  = piece.team
            let bitboard = piece.bitboard
            var teamBitboards:UInt64!
            var teamKing:Piece!
            //var teamBoard:[Piece]!
            var adversaryBitboards:UInt64!
            //var adversaryKing:Piece!
            var adversaryBoard:[Piece]!
            if team == false {
                teamBitboards = info.0
                teamKing = info.2
                //teamBoard = info.4
                adversaryBitboards = info.1
                //adversaryKing = info.3
                adversaryBoard = info.5
            }else {
                adversaryBitboards = info.0
                //adversaryKing = info.2
                adversaryBoard = info.4
                teamBitboards = info.1
                teamKing = info.3
                //teamBoard = info.5
            }
            var moves = Bitboards.getMoveBitboardNoKingCheck(bitboard: piece.bitboard, position: piece.position, pieceType: piece.pieceType, moved: piece.moved, teamBitboards: teamBitboards, adversaryBitboards: adversaryBitboards).0
            if check{
                let bitboardsWithoutPiece = bitboard ^ teamBitboards
                for piece in adversaryBoard {
                    let threatBitboards =  Bitboards.getMoveBitboardNoKingCheck(bitboard: piece.bitboard, position: piece.position, pieceType: piece.pieceType, moved: piece.moved, teamBitboards:adversaryBitboards , adversaryBitboards:  bitboardsWithoutPiece)
                    let threatMasks = threatBitboards.0
                    if (threatMasks & teamKing.bitboard != 0){
                        let splitThreatMasks = threatBitboards.1
                        for threatMask in splitThreatMasks{
                            if (threatMask & teamKing.bitboard != 0) {
                                moves = moves & threatMask
                            }
                        }
                    }
                    
                }
            }
            return moves
        }

       static func getMoveBitboard(piece:Piece,board:[Piece],check:Bool)->UInt64{
            let info = Bitboards.getBoardInfo(board: board)
            let team  = piece.team
            let bitboard = piece.bitboard
            var teamBitboards:UInt64!
            var teamKing:Piece!
            //var teamBoard:[Piece]!
            var adversaryBitboards:UInt64!
            //var adversaryKing:Piece!
            var adversaryBoard:[Piece]!
            if team == false {
                teamBitboards = info.0
                teamKing = info.2
                //teamBoard = info.4
                adversaryBitboards = info.1
                //adversaryKing = info.3
                adversaryBoard = info.5
            }else {
                adversaryBitboards = info.0
                //adversaryKing = info.2
                adversaryBoard = info.4
                teamBitboards = info.1
                teamKing = info.3
                //teamBoard = info.5
            }
            var moves = Bitboards.getMoveBitboardNoKingCheck(bitboard: piece.bitboard, position: piece.position, pieceType: piece.pieceType, moved: piece.moved, teamBitboards: teamBitboards, adversaryBitboards: adversaryBitboards).0
            if check{
                let bitboardsWithoutPiece = bitboard ^ teamBitboards
                for piece in adversaryBoard {
                    let threatBitboards =  Bitboards.getMoveBitboardNoKingCheck(bitboard: piece.bitboard, position: piece.position, pieceType: piece.pieceType, moved: piece.moved, teamBitboards:adversaryBitboards , adversaryBitboards:  bitboardsWithoutPiece)
                    let threatMasks = threatBitboards.0
                    if (threatMasks & teamKing.bitboard != 0){
                        print("threat")
                        let splitThreatMasks = threatBitboards.1
                        for threatMask in splitThreatMasks{
                            if (threatMask & teamKing.bitboard != 0) {
                                print("that's the threat")

                                moves = moves & threatMask
                            }
                        }
                    }
                    
                }
            }
            return moves
        }


        // Returns move bitboards without king check
         static func getMoveBitboardNoKingCheck(bitboard:UInt64,position:UInt64,pieceType:PieceType,moved:Bool,teamBitboards:UInt64,adversaryBitboards:UInt64)->(UInt64,[UInt64]) {
            var mask = bitboard
            var splitMasks = [UInt64]()
            let bitboards = teamBitboards | adversaryBitboards
            switch pieceType {
            case .Rook:
                let h = (Bitboards.movesHorinzontal(piece: bitboard, position:position, bitboards:bitboards) & ~teamBitboards)|bitboard
                let v = (Bitboards.movesVertical(piece: bitboard, position:position, bitboards:bitboards) & ~teamBitboards)|bitboard
                mask = mask | v | h
                splitMasks.append(h)
                splitMasks.append(v)
                break
            case .Knight:
                let k = (Bitboards.movesKnight(piece: bitboard, position:position) & ~teamBitboards)|bitboard
                mask = mask | k
                splitMasks.append(k)
                break
            case .Bishop:
                let d = (Bitboards.movesDiagonal(piece: bitboard, position:position, bitboards:bitboards) & ~teamBitboards)|bitboard
                mask = mask | d
                splitMasks.append(d)
            case .Queen:
                let d = (Bitboards.movesDiagonal(piece: bitboard, position:position, bitboards:bitboards) & ~teamBitboards)|bitboard
                let h = (Bitboards.movesHorinzontal(piece: bitboard, position:position, bitboards:bitboards) & ~teamBitboards)|bitboard
                let v = (Bitboards.movesVertical(piece: bitboard, position:position, bitboards:bitboards) & ~teamBitboards)|bitboard
                mask = mask | v | h | d
                splitMasks.append(h)
                splitMasks.append(v)
                splitMasks.append(d)
                break
            case .King:
                let ks = (Bitboards.movesKing(piece: bitboard, position: position) & ~teamBitboards)|bitboard
                mask = mask | ks
                splitMasks.append(ks)
                break
            case .WhitePawn:
                var mtb = (Bitboards.movesToBlackOne(piece: bitboard, position: position) & ~bitboards)|bitboard
                // If mtw == 0 then cannot take 1 step so cannot take 2 steps
                if moved == false && mtb != 0 {
                    mtb = (mtb | Bitboards.movesToBlackTwo(piece: bitboard, position: position)) & ~bitboards
                }
                let attackMaskLeft = (Bitboards.movesToBlackLeftDiag(piece: bitboard, position:position) & adversaryBitboards)|bitboard
                let attackMaskRight = (Bitboards.movesToBlackRightDiag(piece: bitboard, position:position) & adversaryBitboards)|bitboard
                mask = mask|mtb|attackMaskLeft|attackMaskRight
                splitMasks.append(mtb)
                splitMasks.append(attackMaskLeft)
                splitMasks.append(attackMaskRight)
                break
            case .BlackPawn:
                var mtw = (Bitboards.movesToWhiteOne(piece: bitboard, position: position) & ~bitboards)|bitboard
                // If mtw == 0 then cannot take 1 step so cannot take 2 steps
                if moved == false && mtw != 0 {
                    mtw = (mtw | Bitboards.movesToWhiteTwo(piece: bitboard, position: position)) & ~bitboards
                }
                let attackMaskLeft = (Bitboards.movesToWhiteLeftDiag(piece: bitboard, position:position) & adversaryBitboards)|bitboard
                let attackMaskRight = (Bitboards.movesToWhiteRightDiag(piece: bitboard, position:position) & adversaryBitboards)|bitboard
                mask = mask|mtw|attackMaskLeft|attackMaskRight
                splitMasks.append(mtw)
                splitMasks.append(attackMaskLeft)
                splitMasks.append(attackMaskRight)
                break
            }
            return (mask,splitMasks)
        }
        
        static func getBoardInfo(board:[Piece])->(UInt64,UInt64,Piece,Piece,[Piece],[Piece]) {
            var whiteBitboard:UInt64 = 0
            var blackBitboard:UInt64 = 0
            var whiteKing:Piece!
            var blackKing:Piece!
            var whiteBoard = [Piece]()
            var blackBoard = [Piece]()
            for piece in board {
                if piece.team == false {
                    whiteBitboard = whiteBitboard | piece.bitboard
                    whiteBoard.append(piece)
                }else {
                    blackBitboard = blackBitboard | piece.bitboard
                    blackBoard.append(piece)
                }
                if piece.pieceType == .King {
                    if piece.team == false {
                        whiteKing = piece
                    }else {
                        blackKing = piece
                    }
                }
            }
            return (whiteBitboard,blackBitboard,whiteKing,blackKing,whiteBoard,blackBoard)
        }
        
        static func checkToKing(king:Piece,board:[Piece],teamMask:UInt64,adversaryMask:UInt64)->Bool{
            for piece in board {
                if piece.team != king.team {
                    let threatMask =  Bitboards.getMoveBitboardNoKingCheck(bitboard: piece.bitboard, position: piece.position, pieceType: piece.pieceType, moved: piece.moved, teamBitboards:adversaryMask , adversaryBitboards:  teamMask).0
                    if (threatMask & king.bitboard != 0){
                        return true
                    }
                }
            }
            return false
        }
        static func checkToKing(team:Bool,board:[Piece])->Bool{
            let info = getBoardInfo(board:board)
            var teamMask:UInt64 = 0
            var adversaryMask:UInt64 = 0
            var teamKing:Piece!
            if team == false {
                teamMask = info.0
                adversaryMask = info.1
                teamKing = info.2
            }else {
                teamMask = info.1
                adversaryMask = info.0
                teamKing = info.3
            }
            for piece in board {
                if piece.team != teamKing.team {
                    let threatMask =  Bitboards.getMoveBitboardNoKingCheck(bitboard: piece.bitboard, position: piece.position, pieceType: piece.pieceType, moved: piece.moved, teamBitboards:adversaryMask , adversaryBitboards:  teamMask).0
                    if (threatMask & teamKing.bitboard != 0){
                        return true
                    }
                }
            }
            return false
        }
        
    }


let game = ChessGame()


let piece = Piece(bitBoard: BitboardSetup.WhitePawns[4], pieceType: .Bishop, team: false)
let info  = Bitboards.getBoardInfo(board: game.board)
(info.0).toBitboard()
(info.1).toBitboard()
let moves = Bitboards.getMoveBitboard(piece: piece, info: info, check: true)
moves.toBitboard()



