//
//  IntialState.swift
//  Chess
//
//  Created by Jonathan on 31/12/16.
//  Copyright © 2016 Jonathan Fiorentini. All rights reserved.
//

import Foundation

struct BitboardSetup {
    static let CastlingBlackMask1:UInt64 = 17870283321406128128
    static let CastlingBlackMask2:UInt64 = 1080863910568919040
    
    static let CastlingWhiteKing1:UInt64 = 2
    static let CastlingWhiteKing2:UInt64 = 32
    
    static let CastlingWhiteMask1:UInt64 = 15
    static let CastlingWhiteMask2:UInt64 = 248
    
    static let CastlingBlackKing1:UInt64 = 2305843009213693952
    static let CastlingBlackKing2:UInt64 = 144115188075855872
    static let PromotionForBlack:UInt64 = 255
    static let PromotionForWhite:UInt64 = 18374686479671623680

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
