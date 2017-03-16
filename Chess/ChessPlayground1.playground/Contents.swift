//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

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
}

// White Pieces
let whitePawns:UInt64 = 65280
let whiteRookQueen:UInt64 = 128
let whiteKnightQueen:UInt64 = 64
let whiteBishopQueen:UInt64 = 32
let whiteQueen:UInt64 = 16
let whiteKing:UInt64 = 8
let whiteBishopKing:UInt64 = 4
let whiteKnightKing:UInt64 = 2
let whiteRookKing:UInt64 = 1

// Black Pieces
let blackPawns:UInt64 = 71776119061217280
let blackRookQueen:UInt64 = 9223372036854775808
let blackKnightQueen:UInt64 = 4611686018427387904
let blackBishopQueen:UInt64 = 2305843009213693952
let blackQueen:UInt64 = 1152921504606846976
let blackKing:UInt64 = 576460752303423488
let blackBishopKing:UInt64 = 288230376151711744
let blackKnightKing:UInt64 = 144115188075855872
let blackRookKing:UInt64 = 72057594037927936

// Rows


func searchPosition(piece:UInt64)->(UInt64) {
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

func searchPosition2(piece:UInt64)->(UInt64) {
    if piece == 0 {
        return 0
    }
    var update = piece
    var counter:UInt64 = 1
    while update % 2 == 0 {
        counter = counter + 1
        update = update/2
    }
    return counter
}

func movesVertical(piece:UInt64)->UInt64 {
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
func movesVertical(piece:UInt64,position:UInt64)->UInt64 {
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


func movesHorinzontal(piece:UInt64)->UInt64 {
    let position = searchPosition(piece: piece)
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
func movesHorinzontal(piece:UInt64,position:UInt64)->UInt64 {
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
func movesDiagonal(piece:UInt64)->UInt64 {
    let position = searchPosition(piece: piece)
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
func movesDiagonal(piece:UInt64,position:UInt64)->UInt64 {
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

func movesToBlack(piece:UInt64)->UInt64 {
    return ~(piece - 1)
}

func movesToWhite(piece:UInt64)->UInt64 {
    return (piece - 1)
}


func movesSingle(piece:UInt64)->UInt64 {
    let position = searchPosition(piece: piece)
    var col = (position % 8)
    col = col == 0 ? 8 : col
    var row = (position / 8)
    row =  position % 8 == 0 ? row : row + 1
    var mask = piece
    if row < 8 && col > 1  {
        mask = mask | (piece << (7))
    }
    if row < 8 {
        mask = mask | (piece << (8))
    }
    if col < 8 {
        mask = mask | (piece << (9))
    }
    
    if col > 1 {
        mask = mask | (piece << (1))
    }
    if col < 8 {
        mask = mask | (piece >> (1))
    }
    
    if row > 1 && col < 8 {
        mask = mask | (piece >> (7))
    }
    if row > 1 {
        mask = mask | (piece >> (8))
    }
    if row > 1 && col > 1 {
        mask = mask | (piece >> (9))
    }
   
    return mask
}

func movesKing(piece:UInt64,position:UInt64)->UInt64 {
    var col = (position % 8)
    col = col == 0 ? 8 : col
    var row = (position / 8)
    row =  position % 8 == 0 ? row : row + 1
    var mask = piece
    if row < 8 && col > 1  {
        mask = mask | (piece << (7))
    }
    if row < 8 {
        mask = mask | (piece << (8))
    }
    if row < 8 && col < 8{
        mask = mask | (piece << (9))
    }
    
    if col > 1 {
        mask = mask | (piece >> (1))
    }
    if col < 8 {
        mask = mask | (piece << (1))
    }
    
    if row > 1 && col < 8 {
        mask = mask | (piece >> (7))
    }
    if row > 1 {
        mask = mask | (piece >> (8))
    }
    if row > 1 && col > 1 {
        mask = mask | (piece >> (9))
    }
    
    return mask
}

func movesToBlackOne(piece:UInt64,position:UInt64)->UInt64 {
    var row = (position / 8)
    row =  position % 8 == 0 ? row : row + 1
    var mask = piece
    if row < 8 {
        mask = mask | (piece << (8))
    }
    return mask
}
func movesToBlackTwo(piece:UInt64,position:UInt64)->UInt64 {
    var row = (position / 8)
    row =  position % 8 == 0 ? row : row + 1
    var mask = piece
    if row < 7 {
        mask = mask | (piece << (16))
    }
    return mask
}

func movesToWhiteRightDiag(piece:UInt64,position:UInt64)->UInt64 {
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
func movesToWhiteLeftDiag(piece:UInt64,position:UInt64)->UInt64 {
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


func movesToBlackRightDiag(piece:UInt64,position:UInt64)->UInt64 {
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

func movesToBlackLeftDiag(piece:UInt64,position:UInt64)->UInt64 {
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


func movesToWhiteOne(piece:UInt64,position:UInt64)->UInt64 {
    var row = (position / 8)
    row =  position % 8 == 0 ? row : row + 1
    var mask = piece
    if row > 1 {
        mask = mask | (piece >> (8))
    }
    
    return mask
}

func movesToWhiteTwo(piece:UInt64,position:UInt64)->UInt64 {
    var row = (position / 8)
    row =  position % 8 == 0 ? row : row + 1
    var mask = piece
    if row > 2 {
        mask = mask | (piece >> (16))
    }
    
    return mask
}



func movesKnight(piece:UInt64)->UInt64{
    let position = searchPosition(piece: piece)
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

func movesKnight(piece:UInt64,position:UInt64)->UInt64{
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



enum MoveBit:UInt8 {
    case Vertical   = 0b00000001
    case Horizontal = 0b00000010
    case Diagonal =   0b00000100
    case Single =     0b00001000
    case Double =     0b00010000
    case BlackWay =   0b00100000
    case WhiteWay =   0b01000000
    case Knight =     0b10000000
}

enum PieceType {
    case Rook
    case Knight
    case Bishop
    case Queen
    case King
    case BlackPawn(Int) // 1 = standard step, 2 = double step, 3 = side step left, 4 = side step right
    case WhitePawn(Int) // 1 = standard step, 2 = double step, 3 = side step left, 4 = side step right
}


struct Piece {
    var bitBoard:UInt64
    var pieceType:PieceType
    var moveBitBoard:UInt64  {
        get {
            let position = searchPosition(piece: bitBoard)
            var mask = bitBoard
            switch pieceType {
            case .Rook:
                mask = mask | movesVertical(piece: bitBoard, position:position)
                mask = mask | movesHorinzontal(piece: bitBoard, position:position)
                break
            case .Knight:
                mask = mask | movesKnight(piece: bitBoard, position:position)
                break
            case .Bishop:
                mask = mask | movesDiagonal(piece: bitBoard, position:position)
                break
            case .King:
                mask = mask | movesKing(piece: bitBoard, position:position)
                break
            case .Queen:
                mask = mask | movesHorinzontal(piece: bitBoard, position:position)
                mask = mask | movesVertical(piece: bitBoard, position:position)
                mask = mask | movesDiagonal(piece: bitBoard, position:position)
                break
            case .WhitePawn (1):
                mask = mask | movesToBlackOne(piece: bitBoard, position:position)
                break
            case .BlackPawn(1):
                mask = mask | movesToWhiteOne(piece: bitBoard, position:position)
            case .WhitePawn(2):
                mask = mask | movesToBlackOne(piece: bitBoard, position:position)
                mask = mask | movesToBlackTwo(piece: bitBoard, position:position)
                break
            case .BlackPawn(2):
                mask = mask | movesToWhiteOne(piece: bitBoard, position:position)
                mask = mask | movesToWhiteTwo(piece: bitBoard, position:position)
                break
            case .WhitePawn(3):
                mask = mask | movesToBlackLeftDiag(piece: bitBoard, position:position)
                break
            case .BlackPawn(3):
                mask = mask | movesToWhiteLeftDiag(piece: bitBoard, position:position)
                break
            case .WhitePawn(4):
                mask = mask | movesToBlackRightDiag(piece: bitBoard, position:position)
                break
            case .BlackPawn(4):
                mask = mask | movesToWhiteRightDiag(piece: bitBoard, position:position)
                break

            default: break
            }
            return mask
        }
    }
    init (bitBoard:UInt64,pieceType:PieceType){
        self.bitBoard = bitBoard
        self.pieceType = pieceType
    }
}

let dest:UInt64 = 9223372036854775808
let queen = Piece(bitBoard: dest, pieceType: .King)



struct ChessGame{
    var board:[Piece] // Collection of pieces
}
func XTestMovesHorizontal(){
    for i in 0...63 {
        let piecePosition = UInt64(pow(Double(2), Double(i)))
        movesHorinzontal(piece: piecePosition,position: UInt64(i+1)).toBitboard()
    }
}
func XTestMovesVertical(){
    for i in 0...63 {
        let piecePosition = UInt64(pow(Double(2), Double(i)))
        movesVertical(piece: piecePosition,position: UInt64(i+1)).toBitboard()
    }
}
func XTestMovesDiagonal(){
    for i in 0...63 {
        let piecePosition = UInt64(pow(Double(2), Double(i)))
        movesDiagonal(piece: piecePosition,position: UInt64(i+1)).toBitboard()
    }
}
func XTestMovesKnight(){
    for i in 0...63 {
        let piecePosition = UInt64(pow(Double(2), Double(i)))
        movesKnight(piece: piecePosition,position: UInt64(i+1)).toBitboard()
    }
}
func XTestMovesKing(){
    for i in 0...63 {
        let piecePosition = UInt64(pow(Double(2), Double(i)))
        movesKing(piece: piecePosition,position: UInt64(i+1)).toBitboard()
    }
}

func XTestMovesToBlackLeftDiag(){
    for i in 0...63 {
        let piecePosition = UInt64(pow(Double(2), Double(i)))
        movesToBlackLeftDiag(piece: piecePosition,position: UInt64(i+1)).toBitboard()
    }
}
func XTestMovesToBlackRightDiag(){
    for i in 0...63 {
        let piecePosition = UInt64(pow(Double(2), Double(i)))
        movesToBlackRightDiag(piece: piecePosition,position: UInt64(i+1)).toBitboard()
    }
}
func XTestMovesToWhiteLeftDiag(){
    for i in 0...63 {
        let piecePosition = UInt64(pow(Double(2), Double(i)))
        movesToWhiteLeftDiag(piece: piecePosition,position: UInt64(i+1)).toBitboard()
    }
}
func XTestMovesToWhiteRightDiag(){
    for i in 0...63 {
        let piecePosition = UInt64(pow(Double(2), Double(i)))
        movesToWhiteRightDiag(piece: piecePosition,position: UInt64(i+1)).toBitboard()
    }
}

func XTestSearchPosition(){
    for i in 0...63 {
        let piecePosition = UInt64(pow(Double(2), Double(i)))
        searchPosition(piece: piecePosition)
    }
}
