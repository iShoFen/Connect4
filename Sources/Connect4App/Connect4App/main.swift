//
//  main.swift
//  Power4App
//
//  Created by Samuel on 17/01/2023.
//

import Foundation
import Connect4Lib

print("Hello, World!")

// inout => passage by ref
func insertPiece(by id: Int, atColumn column: Int, in b: inout Board) {
    let result = b.insertPiece(by: 2, atColumn: column)
    switch result {
    case let .added(id, row, column):
        print("player \(id) has inserted a Piece at column \(column) and row \(row)")
    case let .deleted(id, row, column):
        print("player \(id) has deleted a Piece at column \(column) and row \(row)")
    case let .failed(reason):
        switch reason {
        case .columnEmpty:
            print("column \(column) is empty")
        case .columnFull:
            print("column \(column) is full")
        case .outOfBounds:
            print("column \(column) is out of bounds")
        }
    
    default:
        print("I don't know what to say!")
    }
    print(b)
}

func removePiece(atColumn column: Int, in b: inout Board) {
    let result = b.removePiece(atColumn: column)
    switch result {
    case let .deleted(id, row, column):
        print("admin has deleted a Piece from user \(id) at column \(column) and row \(row)")
    case let .failed(reason):
        switch reason {
        case .columnEmpty:
            print("column \(column) is empty")
        case .outOfBounds:
            print("column \(column) is out of bounds")
        default:
            print("I don't know what is the error")
        }
    default:
        print("I don't know what to say!")
    }
    print(b)
}

if var board = Board(withGrid: Array(repeating: Array(repeating: nil, count: 3), count: 3)) {
    print(board)
    insertPiece(by: 2, atColumn: 10, in: &board)
    insertPiece(by: 2, atColumn: 0, in: &board)
    insertPiece(by: 1, atColumn: 0, in: &board)
    insertPiece(by: 1, atColumn: 0, in: &board)
    insertPiece(by: 1, atColumn: 0, in: &board)
    insertPiece(by: 1, atColumn: 2, in: &board)
    removePiece(atColumn: 0, in: &board)
    print(board)
    print(board.isFull())
}

print("Another board\n")

if var board = Board(withNbRows: 1, andNbColumns: 1) {
    print(board)
    insertPiece(by: 1, atColumn: 0, in: &board)
    print(board.isFull())

    var player1 = Human(withId: 1, andPseudo: "samuel")!
}
