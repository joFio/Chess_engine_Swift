//
//  Evaluation.swift
//  Chess
//
//  Created by Jonathan on 24/2/17.
//  Copyright © 2017 Jonathan Fiorentini. All rights reserved.
//

import Foundation

struct Evaluation {
    // Default score is for White pieces.
    // Multiply by -1 for Black pieces
    
    static func BoardScore(board:Board)->Int {
        var score = Evaluation.MaterialScore(board: board) + Evaluation.PieceSquareScore(board:board)        
        if board.team == true {
            score *= -1
        }        
        return score
    }
    private static func PieceSquareScore(board:Board)->Int {
        // Bonus for Bishop pair
        let info = board.getBoardInfo()
        var wScore = 0
        var bScore = 0
        //Kings
        let wK = info.whiteKing
        wScore += PieceSquareValue.King[Int(wK.position)]
        let bK = info.blackKing
        bScore += PieceSquareValue.King.reversed()[Int(bK.position)]
        //Queens
        if let piece = info.whiteQueen  {
            wScore += PieceSquareValue.Queen[Int(piece.position)]
        }
        if let piece = info.blackQueen  {
            bScore += PieceSquareValue.Queen.reversed()[Int(piece.position)]
        }
        //Bishops
        if let piece = info.whiteBishops.0  {
            wScore += PieceSquareValue.Bishop[Int(piece.position)]
        }
        if let piece = info.whiteBishops.1 {
            wScore += PieceSquareValue.Bishop[Int(piece.position)]
        }
        if let piece = info.blackBishops.0  {
            bScore += PieceSquareValue.Bishop.reversed()[Int(piece.position)]
        }
        if let piece = info.blackBishops.1  {
            bScore  += PieceSquareValue.Bishop.reversed()[Int(piece.position)]
        }
        //Knights
        if let piece = info.whiteKnights.0  {
            wScore += PieceSquareValue.Knight[Int(piece.position)]
        }
        if let piece = info.whiteKnights.1  {
            wScore += PieceSquareValue.Knight[Int(piece.position)]
        }
        if let piece = info.blackKnights.0  {
            bScore += PieceSquareValue.Knight.reversed()[Int(piece.position)]
        }
        if let piece = info.blackKnights.1  {
            bScore  += PieceSquareValue.Knight.reversed()[Int(piece.position)]
        }
        //Rooks
        if let piece = info.whiteRooks.0  {
            wScore += PieceSquareValue.Rook[Int(piece.position)]
        }
        if let piece = info.whiteRooks.1  {
            wScore += PieceSquareValue.Rook[Int(piece.position)]
        }
        if let piece = info.blackRooks.0  {
            bScore += PieceSquareValue.Rook.reversed()[Int(piece.position)]
        }
        if let piece = info.blackKnights.1  {
            bScore  += PieceSquareValue.Rook.reversed()[Int(piece.position)]
        }
        //Pawns
        let whitePawns = info.whitePawns
        whitePawns.forEach(
            { (pawn) in
                wScore += PieceSquareValue.Pawn[Int(pawn.position)]
            }
        )
        let blackPawns = info.blackPawns
        blackPawns.forEach(
            { (pawn) in
                bScore += PieceSquareValue.Pawn.reversed()[Int(pawn.position)]
            }
        )
        let score = wScore - bScore
        return score
    }
    private static func MaterialScore(board:Board)->Int {
        // Considerations
        // Bonus for Bishop pair
        let info = board.getBoardInfo()
        let wQ = info.whiteQueen == nil ? 0 : 1
        let bQ = info.blackQueen == nil ? 0 : 1
        let queenScore = (wQ - bQ)*PieceValue.Queen
        let wB1 = info.whiteBishops.0 == nil ? 0:1
        let wB2 = info.whiteBishops.1 == nil ? 0:1
        let bB1 = info.blackBishops.0 == nil ? 0:1
        let bB2 = info.blackBishops.1 == nil ? 0:1
        let wBScore = wB1*wB2 == 1 ? (wB1+wB2)*PieceValue.Bishop + PieceValue.BishopPairBonus : (wB1+wB2)*PieceValue.Bishop // add 50 if both bishops
        let bBScore = bB1*bB2 == 1 ? (bB1+bB2)*PieceValue.Bishop + PieceValue.BishopPairBonus : (bB1+bB2)*PieceValue.Bishop // add 50 if both bishops
        let bishopScore = (wBScore-bBScore)
        let wK1 = info.whiteKnights.0 == nil ? 0:1
        let wK2 = info.whiteKnights.1 == nil ? 0:1
        let bK1 = info.blackKnights.0 == nil ? 0:1
        let bK2 = info.blackKnights.1 == nil ? 0:1
        let knightScore = ((wK1+wK2) - (bK1+bK2))*PieceValue.Knight
        let wR1 = info.whiteRooks.0 == nil ? 0:1
        let wR2 = info.whiteRooks.1 == nil ? 0:1
        let bR1 = info.whiteRooks.0 == nil ? 0:1
        let bR2 = info.whiteRooks.1 == nil ? 0:1
        let rookScore = (wR1+wR2 - (bR1+bR2))*PieceValue.Rook
        let wP = info.whitePawns.count
        let bP = info.blackPawns.count
        let pawnScore = (wP - bP)*PieceValue.Pawn
        let materialScore = queenScore + bishopScore + knightScore + rookScore + pawnScore
        return materialScore
    }
}
