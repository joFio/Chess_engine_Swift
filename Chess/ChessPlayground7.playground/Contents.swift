//: Playground - noun: a place where people can play

import UIKit

// asdhsaldkhjasdhlakjs
var str = "Hello, playground"
enum PieceType {
    case Rook
    case Knight
    case Bishop
    case Queen
    case King
    case Pawn (Bool) // true when entering with 2 steps
}
enum NewBoardError: Error {
    case doesNotOwnPiece
    case moveImpossible
    case cannotMoveToSameCase
}
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


struct BitboardSetup {
    static let CastlingBlackMask1:UInt64 = 17870283321406128128
    static let CastlingBlackMask2:UInt64 = 1080863910568919040
    static let CastlingWhiteKing1:UInt64 = 2
    static let CastlingWhiteKing2:UInt64 = 32
    static let CastlingWhiteMask1:UInt64 = 15
    static let CastlingWhiteMask2:UInt64 = 248
    static let CastlingBlackKing1:UInt64 = 2305843009213693952
    static let CastlingBlackKing2:UInt64 = 144115188075855872
    // White Pieces
    static let WhiteRookQueen:UInt64 = 128
    static let WhiteKnightQueen:UInt64 = 64
    static let WhiteBishopQueen:UInt64 = 32
    static let WhiteQueen:UInt64 = 16
    static let WhiteKing:UInt64 = 8
    static let WhiteBishopKing:UInt64 = 4
    static let WhiteKnightKing:UInt64 = 2
    static let WhiteRookKing:UInt64 = 1
    static let WhitePawns:[UInt64] = [256,512,1024,2048,4096,8192,16384,4294967296]
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
        BitboardSetup.BlackPawns.forEach({(bitboard) in blackPawns.append(Piece(bitBoard: bitboard, pieceType: .Pawn(true), team: true))})
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
            self = newBoard
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
        var whiteKing:Piece!
        var blackKing:Piece!
        //var whitePawns = [Piece]()
        //var blackPawns = [Piece]()
        var whiteBoard = [Piece]()
        var blackBoard = [Piece]()
        var whiteRooks:(Piece?,Piece?)
        var blackRooks:(Piece?,Piece?)
        for piece in self.pieces {
            if piece.team == false {
                whiteBitboard = whiteBitboard | piece.bitboard
                whiteBoard.append(piece)
                switch piece.pieceType {
                case .King:
                    whiteKing = piece
                    break
                case .Rook:
                    if whiteRooks.0 == nil {
                        whiteRooks.0 = piece
                    }else {
                        whiteRooks.1 = piece
                    }
                    break
                case.Pawn(true):
                    whitePawnEnpassantBitboard = whitePawnEnpassantBitboard | piece.bitboard
                default:
                    break
                }
            }else {
                blackBitboard = blackBitboard | piece.bitboard
                blackBoard.append(piece)
                switch piece.pieceType {
                case .King:
                    blackKing = piece
                    break
                case .Rook:
                    if blackRooks.0 == nil {
                        blackRooks.0 = piece
                    }else {
                        blackRooks.1 = piece
                    }
                    break
                case.Pawn(true):
                    blackPawnEnpassantBitboard = blackPawnEnpassantBitboard | piece.bitboard
                default:
                    break
                }
            }
        }
        let info = Info(whiteBitboard: whiteBitboard, blackBitboard: blackBitboard, whiteKing: whiteKing, blackKing: blackKing, whitePawnEnpassantBitboard: whitePawnEnpassantBitboard, blackPawnEnpassantBitboard: blackPawnEnpassantBitboard, whiteBoard: whiteBoard, blackBoard: blackBoard, whiteRooks: whiteRooks, blackRooks: blackRooks)
        return info
    }
    // Keep static func to generate boards for potential scenarios, create mutating func (not static) to update current playing board handles error
    
    static func newBoardForMove(fromCase:UInt64, toCase:UInt64, team:Bool,board:Board, info:Info)throws ->Board{
        let fromCaseBitboard:UInt64 = 2^^fromCase
        let toCaseBitboard:UInt64 = 2^^toCase
        let teamBitboard:UInt64 = info.getTeamBitboard(team: team)
        var newBoard = board
        guard teamBitboard & fromCaseBitboard != 0 else {
            throw NewBoardError.doesNotOwnPiece
        }
        var idxFrom = -1
        var idxTo = -1
        if let pieceFrom = newBoard.getPieceWithBitboard(bitboard: fromCaseBitboard){
            idxFrom = pieceFrom.0
            if newBoard.pieces[idxFrom].moved == false {
                switch newBoard.pieces[idxFrom].pieceType {
                case .Pawn:
                    newBoard.pieces[idxFrom].pieceType = .Pawn(true)
                    break
                default:
                    break
                }
            }
        }
        if let pieceTo = board.getPieceWithBitboard(bitboard: toCaseBitboard){
            idxTo = pieceTo.0
        }
        switch newBoard.pieces[idxFrom].pieceType {
        case.Pawn:
            if fromCaseBitboard < toCaseBitboard {
                if let pieceTo = board.getPieceWithBitboard(bitboard: (toCaseBitboard << 8 )){
                    if pieceTo.1.team != team {
                        idxTo = pieceTo.0
                        newBoard.pieces.remove(at: idxTo)
                    }
                }
            } else {
                if let pieceTo = board.getPieceWithBitboard(bitboard: (toCaseBitboard >> 8 )){
                    if pieceTo.1.team != team {
                        idxTo = pieceTo.0
                        newBoard.pieces.remove(at: idxTo)
                    }
                }
            }
            break
        default:
            break
        }
        let moves = Bitboards.getMoveBitboard(piece: newBoard.pieces[idxFrom], info: info, check: true)
        guard moves & toCaseBitboard != 0 else {
            throw NewBoardError.moveImpossible
        }
        newBoard.nextTurn()
        newBoard.pieces[idxFrom].bitboard = toCaseBitboard
        if idxTo > -1 {
            newBoard.pieces.remove(at: idxTo)
        }
        return newBoard
    }
    
    static func newBoardForMove(fromCase:UInt64, toCase:UInt64, team:Bool,board:Board)throws ->Board{
        let info = board.getBoardInfo()
        return try Board.newBoardForMove(fromCase:fromCase, toCase:toCase, team:team,board:board, info:info)
    }
}

struct Info {
    var whiteBitboard:UInt64
    var blackBitboard:UInt64
    var whiteKing:Piece
    var blackKing:Piece
    var whitePawnEnpassantBitboard:UInt64
    var blackPawnEnpassantBitboard:UInt64
    //var whitePawns:[Piece]
    //var blackPawns:[Piece]
    var whiteBoard:[Piece]
    var blackBoard:[Piece]
    var whiteRooks:(Piece?,Piece?)
    var blackRooks:(Piece?,Piece?)
    
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
    static func getMoveBitboard(piece:Piece,info:Info,check:Bool)->UInt64{
        let team  = piece.team
        let bitboard = piece.bitboard
        let teamBitboards = info.getTeamBitboard(team: team)
        var teamKing:Piece = info.getTeamKing(team: team)
        let _:[Piece] = info.getTeamPieces(team: team)
        let teamRooks:(Piece?,Piece?) = info.getTeamRooks(team: team)
        let adversaryBitboards = info.getAdversaryBitboard(team: team)
        let adversaryPawnEnpassantBitboards = info.getAdversaryEnPassantBitboard(team: team)
        let _ = info.getAdversaryKing(team: team)
        let adversaryBoard:[Piece] = info.getAdversaryPieces(team: team)
        let _ = info.getAdversaryRooks(team: team)
        var moves = Bitboards.getMoveBitboardNoKingCheck(piece: piece, teamBitboards: teamBitboards, adversaryBitboards: adversaryBitboards,adversaryPawnEnpassantBitboards:adversaryPawnEnpassantBitboards,rooks: teamRooks).0
        if check{
            let bitboardsWithoutPiece = bitboard ^ teamBitboards
            for selPiece in adversaryBoard {
                let threatBitboards =  Bitboards.getMoveBitboardNoKingCheck(piece: selPiece, teamBitboards:adversaryBitboards , adversaryBitboards:  bitboardsWithoutPiece,adversaryPawnEnpassantBitboards:adversaryPawnEnpassantBitboards, rooks: teamRooks)
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
    /* static func getThreatMasks(threatBitboards:(UInt64,[UInt64]),bitbord:UInt64)->UInt64 {
     var mask:UInt64 = 0
     let threatMasks = threatBitboards.0
     if (threatMasks & bitbord != 0){
     print("threat")
     let splitThreatMasks = threatBitboards.1
     for threatMask in splitThreatMasks{
     if (threatMask & bitbord != 0) {
     print("that's the threat")
     mask = mask | threatMask
     }
     }
     }
     return mask
     } */
    static func getMoveBitboard(piece:Piece,board:Board,check:Bool)->UInt64{
        let info = board.getBoardInfo()
        return Bitboards.getMoveBitboard(piece:piece,info:info,check:check)
    }
    
    // Returns move bitboards without king check
    static func getMoveBitboardNoKingCheck(piece:Piece,teamBitboards:UInt64,adversaryBitboards:UInt64,adversaryPawnEnpassantBitboards:UInt64,rooks:(Piece?,Piece?))->(UInt64,[UInt64]) {
        
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
            let castle = movesCastling(piece:piece,bitboards:bitboards,rooks:rooks)|piece.bitboard
            mask = mask | ks | castle
            splitMasks.append(ks)
            splitMasks.append(castle)
            break
        case .Pawn:
            if team == false{
                let enpassantMask =  (piece.bitboard << 1 | piece.bitboard >> 1) << 8
                let enpassant = ((adversaryPawnEnpassantBitboards << 8) & enpassantMask)|piece.bitboard
                var mtb = (Bitboards.movesToBlackOne(piece: piece) & ~bitboards)
                // If mtw == 0 then cannot take 1 step so cannot take 2 steps
                if moved == false && mtb != 0 {
                    mtb = (mtb | Bitboards.movesToBlackTwo(piece: piece)) & ~bitboards
                }
                mtb = mtb | piece.bitboard
                let attackMaskLeft = (Bitboards.movesToBlackLeftDiag(piece: piece) & adversaryBitboards)|piece.bitboard
                let attackMaskRight = (Bitboards.movesToBlackRightDiag(piece:piece) & adversaryBitboards)|piece.bitboard
                mask = mask|mtb|attackMaskLeft|attackMaskRight|enpassant
                splitMasks.append(mtb)
                splitMasks.append(enpassant)
                splitMasks.append(attackMaskLeft)
                splitMasks.append(attackMaskRight)
            }else {
                let enpassantMask =  (piece.bitboard << 1 | piece.bitboard >> 1) >> 8
                let enpassant = ((adversaryPawnEnpassantBitboards >> 8) & enpassantMask)|piece.bitboard
                var mtw = (Bitboards.movesToWhiteOne(piece: piece) & ~bitboards)
                // If mtw == 0 then cannot take 1 step so cannot take 2 steps
                if moved == false && mtw != 0 {
                    mtw = (mtw | Bitboards.movesToWhiteTwo(piece: piece)) & ~bitboards
                }
                mtw = mtw | piece.bitboard
                let attackMaskLeft = (Bitboards.movesToWhiteLeftDiag(piece: piece) & adversaryBitboards)|piece.bitboard
                let attackMaskRight = (Bitboards.movesToWhiteRightDiag(piece: piece) & adversaryBitboards)|piece.bitboard
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



var game = Board()
let info  = game.getBoardInfo()
info.whiteBitboard.toBitboard()
info.blackBitboard.toBitboard()

let test = game.didSucessfullyUpdateMove(fromCase: 1, toCase: 16)
print(test)
let test2 = game.didSucessfullyUpdateMove(fromCase: 49, toCase: 33)
print(test2)

let piece = game.getPieceAtPosition(position: 32)!.1
print(piece.pieceType)
let moves = Bitboards.getMoveBitboard(piece: piece, board: game, check:true)
moves.toBitboard()

let info2 = game.getBoardInfo()
info2.whiteBitboard.toBitboard()
info2.blackBitboard.toBitboard()
