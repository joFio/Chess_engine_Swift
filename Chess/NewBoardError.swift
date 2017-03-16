//
//  NewBoardError.swift
//  Chess
//
//  Created by Jonathan on 14/1/17.
//  Copyright © 2017 Jonathan Fiorentini. All rights reserved.
//
import Foundation
enum NewBoardError: Error {
    case doesNotOwnPiece
    case moveImpossible
    case cannotMoveToSameCase
}
