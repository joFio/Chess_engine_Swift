//
//  Search.swift
//  Chess
//
//  Created by Jonathan on 24/2/17.
//  Copyright © 2017 Jonathan Fiorentini. All rights reserved.
//

import Foundation

struct Search {
    static func searchMoves2(board:Board){
        let info = board.getBoardInfo()
        for piece in info.getTeamPieces(team: board.team) {
            let movesBitboard = Bitboards.getMoveBitboard(piece: piece, info: info, check: true)
            let potentialMoves = Bitboards.getPositions(bitboard: movesBitboard)
            for position in potentialMoves {
                var tempBoard = board
                let check = tempBoard.didSucessfullyUpdateMove(fromCase: piece.position, toCase: position)
                if check {
                    print("Possible move:")
                    print(piece.position)
                    print("to")
                    print(position)
                    print("Value")
                    print(Evaluation.BoardScore(board: tempBoard))
                    print("TEAMTEAMTEAMTEAMTEAMTTEAM")
                    print(tempBoard.team)
                }
            }
        }
    }
    static func searchMoves(board:Board){
      // let test = Search.negaMax(board: board, depth: 3, move:(-1,-1))
        // let test = Search.alphaBeta(board: board, depth: 3,alpha:Int.min, move:(-1,-1))

      
        print(counter)
    }
    static var counter = 0
    
    
    // No value cast to beta
    static func alphaBeta(board:Board,depth:Int, alpha:Int,move:(Int,Int))->(Int,Int,Int){ // Val, from, to
        var alpha = alpha
        let beta = -alpha
        if depth == 0 {
            let value = Evaluation.BoardScore(board: board)
            return (value,move.0,move.1)
        }
        let info = board.getBoardInfo()
        var from = -1
        var to = -1
        for piece in info.getTeamPieces(team: board.team) {
            let movesBitboard = Bitboards.getMoveBitboard(piece: piece, info: info, check: true)
            let potentialMoves = Bitboards.getPositions(bitboard: movesBitboard)
            for position in potentialMoves {
                var tempBoard = board
                let check = tempBoard.didSucessfullyUpdateMove(fromCase: piece.position, toCase: position)
                counter += 1
                if check {
                    let info = Search.alphaBeta(board: tempBoard, depth: depth-1,alpha:-alpha,move:(Int(piece.position),Int(position)))
                    let score = -info.0
                    if score >= beta {
                        from = Int(piece.position)
                        to = Int(position)
                        return (beta,from,to)
                    }
                    if score > alpha {
                        alpha = score
                        from = Int(piece.position)
                        to = Int(position)
                    }
                }
            }
        }
        return (alpha,from,to)
    }

    
    static func negaMax(board:Board,depth:Int,move:(Int,Int))->(Int,Int,Int){ // Val, from, to
        if depth == 0 {
            let value = Evaluation.BoardScore(board: board)
            return (value,move.0,move.1)
        }
        let info = board.getBoardInfo()
        var max = Int.min
        var from = -1
        var to = -1
        for piece in info.getTeamPieces(team: board.team) {
            let movesBitboard = Bitboards.getMoveBitboard(piece: piece, info: info, check: true)
            let potentialMoves = Bitboards.getPositions(bitboard: movesBitboard)
            for position in potentialMoves {
                var tempBoard = board
                let check = tempBoard.didSucessfullyUpdateMove(fromCase: piece.position, toCase: position)
                counter += 1
                if check {
                    let info = Search.negaMax(board: tempBoard, depth: depth-1,move:(Int(piece.position),Int(position)))
                    let score = -info.0
                    if score > max {
                        max = score
                        from = Int(piece.position)
                        to = Int(position)
                    }
                }
            }
        }
        return (max,from,to)
    }
}
