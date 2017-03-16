//
//  Bitboards.swift
//  Chess
//
//  Created by Jonathan on 31/12/16.
//  Copyright © 2016 Jonathan Fiorentini. All rights reserved.
//

import Foundation

struct Bitboards {
    static func searchPosition(bitboard:UInt64)->(UInt64) {
        if bitboard == 0 {
            return 0 // should return error
        }
        var bound:UInt64 = 32
        var scope = bound
        var stop:Bool = false
        while stop == false {
            scope = scope/2
            if bitboard == UInt64(pow(Double(2), Double(bound))) {
                stop = true
            }else if bitboard > UInt64(pow(Double(2), Double(bound))) {
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
        return UInt64(bound)
    }
    static func movesVertical(piece:Piece,bitboards:UInt64)->UInt64 {
        let bitboard = piece.bitboard
        let position = piece.position
        let row:UInt64 = position / 8
        var mask:UInt64 = bitboard
        var rowdec:UInt64 = row
        var rowinc:UInt64 = row
        while rowdec > 0 {
            rowdec -= 1
            let offset = (8*(row - (rowdec)))
            let bit = bitboard >> offset
            mask = mask | (bitboard >> offset)
            if bit & bitboards != 0 {
                break
            }
        }
        while rowinc < 7 {
            rowinc += 1
            let offset = (8*((rowinc) - (row)))
            let bit = bitboard << offset
            mask = mask | (bitboard << offset)
            if bit & bitboards != 0 {
                break
            }
        }
        return mask
    }
    
    static func movesHorinzontal(piece:Piece,bitboards:UInt64)->UInt64 {
        let bitboard = piece.bitboard
        let position = piece.position
        let col = (position % 8)
        var mask = bitboard
        var coldec = col
        var colinc = col
        while coldec > 0 {
            coldec -= 1
            let offset = (col-coldec)
            let bit = bitboard >> offset
            mask = mask | (bitboard >> offset)
            if bit & bitboards != 0 {
                break
            }
        }
        while colinc < 7 {
            colinc += 1
            let offset = (colinc-col)
            let bit = bitboard << offset
            mask = mask | (bitboard << offset)
            if bit & bitboards != 0 {
                break
            }
        }
        return mask
    }
    static func movesDiagonal(piece:Piece,bitboards:UInt64)->(UInt64,UInt64) {
        let bitboard = piece.bitboard
        let position = piece.position
        let col:UInt64 = UInt64(position % 8)
        let row:UInt64 = UInt64(position / 8)
        var maskLeftToRight = bitboard
        var maskRightToLeft = bitboard
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
        while colinc < 7 && rowinc < 7 {
            rowinc += 1
            colinc += 1
            let temp = (8*((rowinc) - (row)))
            let offset = (colinc-col) + temp
            let bit = bitboard << offset
            maskLeftToRight = maskLeftToRight | (bitboard << offset)
            if bit & bitboards != 0 {
                break
            }
        }
        resetInstruction()
        while colinc < 7 && rowdec > 0{
            rowdec -= 1
            colinc += 1
            let temp = (8*(row - (rowdec)))
            let offset =  temp-(colinc-col)
            let bit = (bitboard >> (offset))
            maskRightToLeft = maskRightToLeft | (bitboard >> (offset))
            if bit & bitboards != 0 {
                break
            }
        }
        resetInstruction()
        while coldec > 0 && rowdec > 0 {
            rowdec -= 1
            coldec -= 1
            let temp = (8*(row - (rowdec)))
            let offset =  temp + (col-coldec)
            let bit = (bitboard >> (offset))
            maskLeftToRight = maskLeftToRight | (bitboard >> (offset))
            if bit & bitboards != 0 {
                break
            }
        }
        resetInstruction()
        while coldec > 0 && rowinc < 7 {
            rowinc += 1
            coldec -= 1
            let temp = (8*((rowinc) - (row)))
            let offset = temp - (col-coldec)
            let bit = (bitboard << (offset))
            maskRightToLeft = maskRightToLeft | (bitboard << (offset))
            if bit & bitboards != 0 {
                break
            }
        }
        return (maskLeftToRight,maskRightToLeft)
    }
    static func movesKnight(piece:Piece)->UInt64{
        let bitboard = piece.bitboard
        let position = piece.position
        let col = (position % 8)
        let row = (position / 8)
        var mask = bitboard
        if row < 6 && col > 0  {
            mask = mask | (bitboard << (15))
        }
        if row < 6 && col < 7 {
            mask = mask | (bitboard << (17))
        }
        if row < 7 && col > 1 {
            mask = mask | (bitboard << (6))
        }
        if row < 7 && col < 6 {
            mask = mask | (bitboard << (10))
        }
        if row > 0 && col < 6 {
            mask = mask | (bitboard >> (6))
        }
        if row > 0 && col > 1 {
            mask = mask | (bitboard >> (10))
        }
        if row > 1 && col > 0 {
            mask = mask | (bitboard >> (17))
        }
        if row > 1 && col < 7 {
            mask = mask | (bitboard >> (15))
        }
        return mask
    }
    static func movesCastling(piece:Piece,bitboards:UInt64,rooks:(Piece?,Piece?))->UInt64 {
        let bitboard = piece.bitboard
        var mask:UInt64 = 0
        if piece.moved == false {
            if piece.team == false {
                if let rook = rooks.0 {
                    if rook.moved == false {
                        if (bitboards & BitboardSetup.CastlingWhiteMask1) == ((bitboard | rook.bitboard) & BitboardSetup.CastlingWhiteMask1) {
                            mask = mask|BitboardSetup.CastlingWhiteKing1
                        }
                        if (bitboards & BitboardSetup.CastlingWhiteMask2) == ((bitboard | rook.bitboard) & BitboardSetup.CastlingWhiteMask2) {
                            mask = mask | BitboardSetup.CastlingWhiteKing2
                        }
                    }
                }
                if let rook = rooks.1 {
                    if rook.moved == false {
                        if (bitboards & BitboardSetup.CastlingWhiteMask1) == ((bitboard | rook.bitboard) & BitboardSetup.CastlingWhiteMask1) {
                            mask = mask|BitboardSetup.CastlingWhiteKing1
                        }
                        if (bitboards & BitboardSetup.CastlingWhiteMask2) == ((bitboard | rook.bitboard) & BitboardSetup.CastlingWhiteMask2) {
                            mask = mask | BitboardSetup.CastlingWhiteKing2
                        }
                        
                    }
                }
            }
            else {
                if let rook = rooks.0 {
                    if rook.moved == false {
                        if (bitboards & BitboardSetup.CastlingBlackMask1) == ((bitboard | rook.bitboard) & BitboardSetup.CastlingBlackMask1) {
                            mask = mask | BitboardSetup.CastlingBlackKing1
                        }
                        if (bitboards & BitboardSetup.CastlingBlackMask2) == ((bitboard | rook.bitboard) & BitboardSetup.CastlingBlackMask2) {
                            mask = mask | BitboardSetup.CastlingBlackKing2
                        }
                    }
                }
                
                if let rook = rooks.1 {
                    if rook.moved == false {
                        if (bitboards & BitboardSetup.CastlingBlackMask1) == ((bitboard | rook.bitboard) & BitboardSetup.CastlingBlackMask1) {
                            mask = mask | BitboardSetup.CastlingBlackKing1
                        }
                        if (bitboards & BitboardSetup.CastlingBlackMask2) == ((bitboard | rook.bitboard) & BitboardSetup.CastlingBlackMask2) {
                            mask = mask | BitboardSetup.CastlingBlackKing2
                        }
                    }
                }
            }
        }
        return mask
    }
    static func movesKing(piece:Piece)->UInt64 {
        let bitboard = piece.bitboard
        let position = piece.position
        let col = (position % 8)
        let row = (position / 8)
        var mask = bitboard
        if row < 7 && col > 0  {
            mask = mask | (bitboard << (7))
        }
        if row > 0 && col < 7 {
            mask = mask | (bitboard >> (7))
        }
        if row < 7 && col < 7{
            mask = mask | (bitboard << (9))
        }
        if row > 0 && col > 0 {
            mask = mask | (bitboard >> (9))
        }
        if row < 7 {
            mask = mask | (bitboard << (8))
        }
        if row > 0 {
            mask = mask | (bitboard >> (8))
        }
        if col > 0 {
            mask = mask | (bitboard >> (1))
        }
        if col < 7 {
            mask = mask | (bitboard << (1))
        }
        return mask
    }
    
    static  func movesToBlackOne(piece:Piece)->UInt64 {
        let bitboard = piece.bitboard
        let position = piece.position
        let row = (position / 8)
        var mask = bitboard
        if row < 7 {
            mask = mask | (bitboard << (8))
        }
        return mask
    }
    static  func movesToBlackTwo(piece:Piece)->UInt64 {
        let bitboard = piece.bitboard
        let position = piece.position
        let row = (position / 8)
        var mask = bitboard
        if row < 6 {
            mask = mask | (bitboard << (16))
        }
        return mask
    }
    static func movesToWhiteOne(piece:Piece)->UInt64 {
        let bitboard = piece.bitboard
        let position = piece.position
        let row = (position / 8)
        var mask = bitboard
        if row > 0 {
            mask = mask | (bitboard >> (8))
        }
        return mask
    }
    static func movesToWhiteTwo(piece:Piece)->UInt64 {
        let bitboard = piece.bitboard
        let position = piece.position
        let row = (position / 8)
        var mask = bitboard
        if row > 1 {
            mask = mask | (bitboard >> (16))
        }
        return mask
    }
    static func movesToWhiteRightDiag(piece:Piece)->UInt64 {
        let bitboard = piece.bitboard
        let position = piece.position
        let col = (position % 8)
        let row = (position / 8)
        var mask = bitboard
        if row > 0 && col > 0 {
            mask = mask | (bitboard >> (9))
        }
        return mask
    }
    static  func movesToWhiteLeftDiag(piece:Piece)->UInt64 {
        let bitboard = piece.bitboard
        let position = piece.position
        let col = (position % 8)
        let row = (position / 8)
        var mask = bitboard
        
        if row > 0 && col < 7 {
            mask = mask | (bitboard >> (7))
        }
        return mask
    }
    static  func movesToBlackRightDiag(piece:Piece)->UInt64 {
        let bitboard = piece.bitboard
        let position = piece.position
        let col = (position % 8)
        let row = (position / 8)
        var mask = bitboard
        if row < 7 && col > 0  {
            mask = mask | (bitboard << (7))
        }
        return mask
    }
    static  func movesToBlackLeftDiag(piece:Piece)->UInt64 {
        let bitboard = piece.bitboard
        let position = piece.position
        let col = (position % 8)
        let row = (position / 8)
        var mask = bitboard
        
        if col < 7 &&  row < 7  {
            mask = mask | (bitboard << (9))
        }
        return mask
    }
    // Returns move Bitboard and verfies King check by removing potentially moving piece and check whether king is in check.
    static func getMoveBitboard(piece:Piece,info:Info,check:Bool)->UInt64{
        let team  = piece.team
        let bitboard = piece.bitboard
        let teamBitboards = info.getTeamBitboard(team: team)
        var teamKing:Piece = info.getTeamKing(team: team)
        let _:[Piece] = info.getTeamPieces(team: team)
        let teamRooks:(Piece?,Piece?) = info.getTeamRooks(team: team)
        let adversaryRooks:(Piece?,Piece?) = info.getAdversaryRooks(team: team)

        let adversaryBitboards = info.getAdversaryBitboard(team: team)
        let teamPawnEnpassantBitboards = info.getTeamEnPassantBitboard(team: team)

        let adversaryPawnEnpassantBitboards = info.getAdversaryEnPassantBitboard(team: team)
        let _ = info.getAdversaryKing(team: team)
        let adversaryBoard:[Piece] = info.getAdversaryPieces(team: team)
        let _ = info.getAdversaryRooks(team: team)
        var moves = Bitboards.getMoveBitboardNoKingCheck(piece: piece, teamBitboards: teamBitboards, adversaryBitboards: adversaryBitboards,adversaryPawnEnpassantBitboards:adversaryPawnEnpassantBitboards,teamRooks: teamRooks).0
        
        if check{
            let bitboardsWithoutPiece = bitboard ^ teamBitboards
            for selPiece in adversaryBoard {
                if bitboard == teamKing.bitboard {
                    // Considers the possibility of the king's eating an adversary piece and end up checked
                    let newAdversaryBitboard = ((~moves) & adversaryBitboards) //adversary bitboard without the king's possible attacks
                    let newBitboardWithoutPiece = bitboardsWithoutPiece | (moves & adversaryBitboards) // team bitboard with possible king attacks
                    //
                    let threatBitboards =  Bitboards.getMoveBitboardNoKingCheck(piece: selPiece, teamBitboards:newAdversaryBitboard , adversaryBitboards:  newBitboardWithoutPiece,adversaryPawnEnpassantBitboards:teamPawnEnpassantBitboards, teamRooks: adversaryRooks, attackMove:true)
                    let threatMasks = threatBitboards.0
                    moves = moves & ~(threatMasks^selPiece.bitboard) // The exact case on which the threatening piece is is not a threat => can be eaten by king
                    if piece.moved == false {
                    // Checks if there is a threat to castling
                        let splitThreatMasks = threatBitboards.1
                        for threatMask in splitThreatMasks{
                            let queenSideCheckMask = bitboard << 1
                            let kingSideCheckMask = bitboard >> 1
                            if threatMask & queenSideCheckMask != 0 {
                                moves = moves ^ (bitboard << 2)
                                break
                            }
                            if threatMask & kingSideCheckMask != 0 {
                                moves = moves ^ (bitboard >> 2)
                                moves = moves ^ (bitboard << 2)
                                break
                            }
                        }
                    }
                }
                else {
                    let threatBitboards =  Bitboards.getMoveBitboardNoKingCheck(piece: selPiece, teamBitboards:adversaryBitboards , adversaryBitboards:  bitboardsWithoutPiece,adversaryPawnEnpassantBitboards:teamPawnEnpassantBitboards, teamRooks: adversaryRooks , attackMove:true)

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
        }
        return moves
    }
    static func isCheck(info:Info, team:Bool)->Bool{
        let adversaryPieces = info.getAdversaryPieces(team: team)
        let teamKing = info.getTeamKing(team: team)
        for selPiece in adversaryPieces {
            let threatMasks =  getMoveBitboard(piece:selPiece,info:info,check:true)
            if (threatMasks & teamKing.bitboard != 0){
                return true
            }
        }
        return false
    }
    
    static func isMate (info:Info, team:Bool)->Bool {
        let teamPieces = info.getTeamPieces(team: team)
        var moves:UInt64 = 0
        for piece in teamPieces {
            let pieceMove =  (Bitboards.getMoveBitboard(piece:piece,info:info,check:true))^piece.bitboard
            moves = moves | pieceMove
        }
        if moves == 0 {
            return true
        }
        return false
    }
    
    static func getMoveBitboard(piece:Piece,board:Board,check:Bool)->UInt64{
        let info = board.getBoardInfo()
        return Bitboards.getMoveBitboard(piece:piece,info:info,check:check)
    }
    
    // Returns move bitboards without king check
    static func getMoveBitboardNoKingCheck(piece:Piece,teamBitboards:UInt64,adversaryBitboards:UInt64,adversaryPawnEnpassantBitboards:UInt64,teamRooks:(Piece?,Piece?),attackMove:Bool = false)->(UInt64,[UInt64]) {
        let moved = piece.moved
        let team = piece.team
        var mask = piece.bitboard
        var splitMasks = [UInt64]()
        let bitboards = teamBitboards | adversaryBitboards
        switch piece.pieceType {
        case .Rook:
            let h = (Bitboards.movesHorinzontal(piece: piece, bitboards:bitboards) & ~teamBitboards)|piece.bitboard
            let v = (Bitboards.movesVertical(piece: piece, bitboards:bitboards) & ~teamBitboards)|piece.bitboard
            mask = mask | v | h
            splitMasks.append(h)
            splitMasks.append(v)
            break
        case .Knight:
            let k = (Bitboards.movesKnight(piece: piece) & ~teamBitboards)|piece.bitboard
            mask = mask | k
            splitMasks.append(k)
            break
        case .Bishop:
            let d = Bitboards.movesDiagonal(piece: piece, bitboards:bitboards)
            let d1 = (d.0 & ~teamBitboards)|piece.bitboard
            let d2 = (d.1 & ~teamBitboards)|piece.bitboard
            mask = mask | d1 | d2
            splitMasks.append(d1)
            splitMasks.append(d2)
        case .Queen:
            let d = Bitboards.movesDiagonal(piece: piece, bitboards:bitboards)
            let d1 = (d.0 & ~teamBitboards)|piece.bitboard
            let d2 = (d.1 & ~teamBitboards)|piece.bitboard
            let h = (Bitboards.movesHorinzontal(piece: piece, bitboards:bitboards) & ~teamBitboards)|piece.bitboard
            let v = (Bitboards.movesVertical(piece: piece, bitboards:bitboards) & ~teamBitboards)|piece.bitboard
            mask = mask | v | h | d1 | d2
            splitMasks.append(h)
            splitMasks.append(v)
            splitMasks.append(d1)
            splitMasks.append(d2)
            break
        case .King:
            let ks = (Bitboards.movesKing(piece: piece) & ~teamBitboards)|piece.bitboard
            let castle = movesCastling(piece:piece,bitboards:bitboards,rooks:teamRooks)|piece.bitboard
            mask = mask | ks | castle
            splitMasks.append(ks)
            splitMasks.append(castle)
            break
        case .Pawn:
            if team == false{
                let enpassantMask =  (piece.bitboard << 1 | piece.bitboard >> 1) << 8
                let enpassant = ((adversaryPawnEnpassantBitboards << 8) & enpassantMask)|piece.bitboard
                var mtb = (Bitboards.movesToBlackOne(piece: piece) & ~bitboards)
                var attackMaskLeft = (Bitboards.movesToBlackLeftDiag(piece: piece))
                var attackMaskRight = (Bitboards.movesToBlackRightDiag(piece:piece))
                // If mtw == 0 then cannot take 1 step so cannot take 2 steps
                if moved == false && mtb != 0 {
                    mtb = (mtb | Bitboards.movesToBlackTwo(piece: piece)) & ~bitboards
                }
                if attackMove {
                    mtb = 0
                }else {
                    attackMaskLeft = attackMaskLeft & adversaryBitboards
                    attackMaskRight = attackMaskRight & adversaryBitboards
                }
                mtb = mtb | piece.bitboard

                attackMaskLeft = attackMaskLeft|piece.bitboard
                attackMaskRight = attackMaskRight|piece.bitboard
                mask = mask|mtb|attackMaskLeft|attackMaskRight|enpassant
                splitMasks.append(mtb)
                splitMasks.append(enpassant)
                splitMasks.append(attackMaskLeft)
                splitMasks.append(attackMaskRight)
            }else {
                let enpassantMask =  (piece.bitboard << 1 | piece.bitboard >> 1) >> 8
                let enpassant = ((adversaryPawnEnpassantBitboards >> 8) & enpassantMask)|piece.bitboard
                var mtw = (Bitboards.movesToWhiteOne(piece: piece) & ~bitboards)
                var attackMaskLeft = (Bitboards.movesToWhiteLeftDiag(piece: piece))
                var attackMaskRight = (Bitboards.movesToWhiteRightDiag(piece: piece))
                // If mtw == 0 then cannot take 1 step so cannot take 2 steps
                if moved == false && mtw != 0 {
                    mtw = (mtw | Bitboards.movesToWhiteTwo(piece: piece)) & ~bitboards
                }
                if attackMove {
                    mtw = 0
                }else {
                    attackMaskLeft = attackMaskLeft & adversaryBitboards
                    attackMaskRight = attackMaskRight & adversaryBitboards
                }
                mtw = mtw | piece.bitboard
                attackMaskLeft = attackMaskLeft|piece.bitboard
                attackMaskRight = attackMaskRight|piece.bitboard
                mask = mask|mtw|attackMaskLeft|attackMaskRight|enpassant
                splitMasks.append(mtw)
                splitMasks.append(enpassant)
                splitMasks.append(attackMaskLeft)
                splitMasks.append(attackMaskRight)
            }
            break
        }
        return (mask,splitMasks)
    }
    static func getBitboardPositions(bitboard:UInt64)->[UInt64] {
        var positions = [UInt64]()
        if bitboard == 0 {
            return positions // should return error
        }
        var stop:Bool = false
        var counter:UInt64 = 0
        var val = bitboard
        while stop == false {
            let newVal:UInt64 = val / 2
            let mod = val % 2
            if mod == 1 {
                let position = (2^^counter)
                positions.append(position)
            }
            val = newVal
            counter += 1
            if val == 0 {
                stop = true
            }
        }
        return positions
    }
    static func getPositions(bitboard:UInt64)->[UInt64] {
        var positions = [UInt64]()
        if bitboard == 0 {
            return positions // should return error
        }
        var stop:Bool = false
        var counter:UInt64 = 0
        var val = bitboard
        while stop == false {
            let newVal:UInt64 = val / 2
            let mod = val % 2
            if mod == 1 {
                positions.append(counter)
            }
            val = newVal
            counter += 1
            if val == 0 {
                stop = true
            }
        }
        return positions
    }
}


