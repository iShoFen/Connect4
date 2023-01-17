//
//  Board.swift
//  
//
//  Created by etudiant on 17/01/2023.
//

import Foundation

struct Board {
    private var grid : [[Int?]]
    private let rows : Int
    private let columns : Int
    private let description : String

    public init?(rows : Int = 6, columns : Int = 7) {
        guard rows > 0 && columns > 0 else {
            return nil
        }


        self.rows = rows
        self.columns = columns
        grid = Array(repeating: Array(repeating: nil, count: columns), count: rows)
        description = "Bound of \(rows) rows and \(columns) columns"
    }

    private mutating func insertPiece(playerId : Int, column : Int, row : Int) -> Bool {
        if row < 0 || row >= rows || column < 0 || column >= columns {
            return false
        }

        if grid[row][column] != nil {
            return false
        }

        grid[row][column] = playerId

        return true
    }

    public mutating func insertPiece(playerId : Int, column : Int) -> Bool {
        if column < 0 || column >= columns {
            return false
        }

        for row in 0..<rows {
            if insertPiece(playerId: playerId, column: column, row: row) {
                return true
            }
        }

        return false
    }

    private mutating func removePiece(column : Int, row : Int) -> Bool {
        if row < 0 || row >= rows || column < 0 || column >= columns {
            return false
        }

        if grid[row][column] == nil {
            return false
        }

        grid[row][column] = nil
        

        return true
    }

    public mutating func removePiece(column : Int) -> Bool {
        if column < 0 || column >= columns {
            return false
        }

        for row in (0..<rows).reversed() {
            if removePiece(column: column, row: row) {
                return true
            }
        }

        return false
    }

    public func isFull() -> Bool {
        for row in 0..<rows {
            for column in 0..<columns {
                if grid[row][column] == nil {
                    return false
                }
            }
        }

        return true
    }

    public subscript(row : Int, column : Int) -> Int? {
        get {
            if row < 0 || row >= rows || column < 0 || column >= columns {
                return nil
            }

            return grid[row][column]
        }
    }

}
