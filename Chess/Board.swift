//
//  Chessboard.swift
//  Chess
//
//  Created by Jonathan on 31/12/16.
//  Copyright © 2016 Jonathan Fiorentini. All rights reserved.
//

import Foundation

struct Board{
    var pieces:[Piece] // Collection of pieces
    var team:Bool
    
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
        BitboardSetup.WhitePawns.forEach({(bitboard) in whitePawns.append(Piece(bitBoard: bitboard, pieceType: .Pawn(false), team: false))})
        let blackRookQueen = Piece(bitBoard: BitboardSetup.BlackRookQueen, pieceType: .Rook, team: true)
        let blackKnightQueen = Piece(bitBoard: BitboardSetup.BlackKnightQueen, pieceType: .Knight, team: true)
        let blackBishopQueen = Piece(bitBoard: BitboardSetup.BlackBishopQueen, pieceType: .Bishop, team: true)
        let blackQueen = Piece(bitBoard: BitboardSetup.BlackQueen, pieceType: .Queen, team: true)
        let blackKing = Piece(bitBoard: BitboardSetup.BlackKing, pieceType: .King, team: true)
        let blackBishopKing = Piece(bitBoard: BitboardSetup.BlackBishopKing, pieceType: .Bishop, team: true)
        let blackKnightKing = Piece(bitBoard: BitboardSetup.BlackKnightKing, pieceType: .Knight, team: true)
        let blackRookKing = Piece(bitBoard: BitboardSetup.BlackRookKing, pieceType: .Rook, team: true)
        var blackPawns = [Piece]()
        BitboardSetup.BlackPawns.forEach({(bitboard) in blackPawns.append(Piece(bitBoard: bitboard, pieceType: .Pawn(false), team: true))})
        self.pieces = [Piece]()
        self.team = false
        self.pieces.append(whiteRookQueen)
        self.pieces.append(whiteKnightQueen)
        self.pieces.append(whiteBishopQueen)
        self.pieces.append(whiteQueen)
        self.pieces.append(whiteKing)
        self.pieces.append(whiteBishopKing)
        self.pieces.append(whiteKnightKing)
        self.pieces.append(whiteRookKing)
        self.pieces.append(contentsOf: whitePawns)
        self.pieces.append(blackRookQueen)
        self.pieces.append(blackKnightQueen)
        self.pieces.append(blackBishopQueen)
        self.pieces.append(blackQueen)
        self.pieces.append(blackKing)
        self.pieces.append(blackBishopKing)
        self.pieces.append(blackKnightKing)
        self.pieces.append(blackRookKing)
        self.pieces.append(contentsOf: blackPawns)
    }
    mutating func nextTurn(){
        if team == false {
            team = true
        }else {
            team = false
        }
    }
    //Updates chess board if possible or else return false
    mutating func didSucessfullyUpdateMove(fromCase:UInt64, toCase:UInt64)->Bool{
        do {
            let newBoard = try Board.newBoardForMove(fromCase: fromCase, toCase: toCase, team: self.team, board: self, info: self.getBoardInfo())
            self = newBoard.0
        } catch {
            return false
        }
        return true
    }
    
    func getPieceAtPosition(position:UInt64)->(Int,Piece)? {
        return self.getPieceWithBitboard(bitboard: (2^^position))
    }
    
    func getPieceWithBitboard(bitboard:UInt64)->(Int,Piece)? {
        for (idx,piece) in pieces.enumerated() {
            if piece.bitboard == bitboard {
                return (idx,piece)
            }
        }
        return nil
    }
    func getBoardInfo()->Info {
        var whiteBitboard:UInt64 = 0
        var blackBitboard:UInt64 = 0
        
        var whitePawnEnpassantBitboard:UInt64 = 0
        var blackPawnEnpassantBitboard:UInt64 = 0
        
        //Pieces
        var whiteKing:Piece!
        var blackKing:Piece!
        
        var whiteQueen:Piece?
        var blackQueen:Piece?
        
        var whiteRooks:(Piece?,Piece?)
        var blackRooks:(Piece?,Piece?)

        var whiteBishops:(Piece?,Piece?)
        var blackBishops:(Piece?,Piece?)
        
        var whiteKnights:(Piece?,Piece?)
        var blackKnights:(Piece?,Piece?)
        
        var whitePawns = [Piece]()
        var blackPawns = [Piece]()
        
        var whiteBoard = [Piece]()
        var blackBoard = [Piece]()
        
        for piece in self.pieces {
            if piece.team == false {
                whiteBitboard = whiteBitboard | piece.bitboard
                whiteBoard.append(piece)
                switch piece.pieceType {
                case .King:
                    whiteKing = piece
                    break
                case .Queen:
                    whiteQueen = piece
                    break
                case .Bishop:
                    if whiteBishops.0 == nil {
                        whiteBishops.0 = piece
                    }else {
                        whiteBishops.1 = piece
                    }
                    break
                case .Knight:
                    if whiteKnights.0 == nil {
                        whiteKnights.0 = piece
                    }else {
                        whiteKnights.1 = piece
                    }
                    break
                case .Rook:
                    if whiteRooks.0 == nil {
                        whiteRooks.0 = piece
                    }else {
                        whiteRooks.1 = piece
                    }
                    break
                case .Pawn(false):
                    whitePawns.append(piece)
                    break
                case.Pawn(true):
                    whitePawnEnpassantBitboard = whitePawnEnpassantBitboard | piece.bitboard
                    whitePawns.append(piece)
                    break
                }
            }else {
                blackBitboard = blackBitboard | piece.bitboard
                blackBoard.append(piece)
                switch piece.pieceType {
                case .King:
                    blackKing = piece
                    break
                case .Queen:
                    blackQueen = piece
                    break
                case .Bishop:
                    if blackBishops.0 == nil {
                        blackBishops.0 = piece
                    }else {
                        blackBishops.1 = piece
                    }
                    break
                case .Knight:
                    if blackKnights.0 == nil {
                        blackKnights.0 = piece
                    }else {
                        blackKnights.1 = piece
                    }
                    break
                case .Rook:
                    if blackRooks.0 == nil {
                        blackRooks.0 = piece
                    }else {
                        blackRooks.1 = piece
                    }
                    break
                case .Pawn(false):
                    blackPawns.append(piece)
                    break
                case.Pawn(true):
                    blackPawnEnpassantBitboard = blackPawnEnpassantBitboard | piece.bitboard
                    blackPawns.append(piece)
                    break
                }
            }
        }
        let info = Info(whiteKing: whiteKing, blackKing: blackKing,
                        whiteQueen: whiteQueen, blackQueen: blackQueen,
                        whiteBishops: whiteBishops, blackBishops: blackBishops,
                        whiteKnights:whiteKnights, blackKnights:blackKnights,
                        whiteRooks: whiteRooks, blackRooks:blackRooks,
                        whitePawns:whitePawns,blackPawns:blackPawns,
                        whiteBitboard:whiteBitboard, blackBitboard:blackBitboard,
                        whitePawnEnpassantBitboard: whitePawnEnpassantBitboard,
                        blackPawnEnpassantBitboard: blackPawnEnpassantBitboard,
                        whiteBoard: whiteBoard, blackBoard: blackBoard)
        return info
    }
    // Keep static func to generate boards for potential scenarios, create mutating func (not static) to update current playing board handles error
    
    // Keep info as argument as it can be computed on a higher level of abstraction
    static func newBoardForMove(fromCase:UInt64, toCase:UInt64, team:Bool,board:Board, info:Info, promotionPieceType:PieceType = .Queen)throws ->(Board,Bool){
        let fromCaseBitboard:UInt64 = 2^^fromCase
        let toCaseBitboard:UInt64 = 2^^toCase
        let teamBitboard:UInt64 = info.getTeamBitboard(team: team)
        var newBoard = board
        guard fromCaseBitboard & toCaseBitboard == 0 else {
            throw NewBoardError.cannotMoveToSameCase
        }
        guard teamBitboard & fromCaseBitboard != 0 else {
            throw NewBoardError.doesNotOwnPiece
        }
        var idxFrom = -1
        var idxTo = -1
        // Handle piece removal - general case
        if let pieceTo = board.getPieceWithBitboard(bitboard: toCaseBitboard){
            idxTo = pieceTo.0
        }
        if let pieceFrom = newBoard.getPieceWithBitboard(bitboard: fromCaseBitboard){
            idxFrom = pieceFrom.0
            switch newBoard.pieces[idxFrom].pieceType {
            case .Pawn:
                if newBoard.pieces[idxFrom].moved == false {
                    newBoard.pieces[idxFrom].pieceType = .Pawn(true)
                }
                // Handle piece removal - en passant
                if fromCaseBitboard < toCaseBitboard {
                    if let pieceTo = board.getPieceWithBitboard(bitboard: (toCaseBitboard >> 8 )){
                        if pieceTo.1.team != team {
                            idxTo = pieceTo.0
                        }
                    }
                } else {
                    if let pieceTo = board.getPieceWithBitboard(bitboard: (toCaseBitboard << 8 )){
                        if pieceTo.1.team != team {
                            idxTo = pieceTo.0
                        }
                    }
                }
                // Promotion to queen
                if newBoard.pieces[idxFrom].team == false {
                    if (toCaseBitboard & BitboardSetup.PromotionForWhite) != 0 {
                        newBoard.pieces[idxFrom] = Piece(bitBoard: toCaseBitboard, pieceType: promotionPieceType, team: newBoard.pieces[idxFrom].team)
                    }
                }else {
                    if (toCaseBitboard & BitboardSetup.PromotionForBlack) != 0 {
                        newBoard.pieces[idxFrom] = Piece(bitBoard: toCaseBitboard, pieceType: promotionPieceType, team: newBoard.pieces[idxFrom].team)
                    }
                }
                break
            case .King:
                // If king is taking two steps forward, it's a queenside castle
                var newRookBitboard:UInt64 = 0
                if fromCaseBitboard == toCaseBitboard >> 2 {
                    if let pieceTo = board.getPieceWithBitboard(bitboard: (toCaseBitboard << 2)){
                        if pieceTo.1.team == team {
                            newRookBitboard = toCaseBitboard >> 1
                            newBoard.pieces[pieceTo.0].bitboard = newRookBitboard
                        }
                    }
                }
                // If king is taking two steps backward, it's a kingside castle
                if fromCaseBitboard == toCaseBitboard << 2{
                    if let pieceTo = board.getPieceWithBitboard(bitboard: (toCaseBitboard >> 1)){
                        if pieceTo.1.team == team {
                            newRookBitboard = toCaseBitboard << 1
                            newBoard.pieces[pieceTo.0].bitboard = newRookBitboard
                        }
                    }
                }
            default:
                break
            }
        }
        let moves = Bitboards.getMoveBitboard(piece: newBoard.pieces[idxFrom], info: info, check: true)
        guard moves & toCaseBitboard != 0 else {
            throw NewBoardError.moveImpossible
        }
        newBoard.nextTurn()
        newBoard.pieces[idxFrom].bitboard = toCaseBitboard
        newBoard.pieces[idxFrom].moved = true
        if idxTo > -1 {
            newBoard.pieces.remove(at: idxTo)
        }
        
        // Reset en passant
        for k in 0...(newBoard.pieces.count - 1) {
            if newBoard.pieces[k].team != team{
                switch newBoard.pieces[k].pieceType{
                case .Pawn(true):
                    newBoard.pieces[k].pieceType = .Pawn(false)
                default:
                    break
                }
            }
        }
        let newInfo = newBoard.getBoardInfo()
        let check = Bitboards.isCheck(info: newInfo, team: !team)
        let mate = Bitboards.isMate (info:newInfo, team:!team)
        if (check == true && mate == true){
           // print("check mate")
        } else if check {
           // print("check")
        } else if mate {
           // print("stale mate")
            
        }
        return (newBoard,check)
    }
    static func newBoardForMove(fromCase:UInt64, toCase:UInt64, team:Bool,board:Board)throws ->(Board,Bool){
        let info = board.getBoardInfo()
        return try Board.newBoardForMove(fromCase:fromCase, toCase:toCase, team:team,board:board, info:info)
    }
    
}


