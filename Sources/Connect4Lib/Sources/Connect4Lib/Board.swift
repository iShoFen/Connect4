//
//  Board.swift
//  
//
//  Created by Samuel on 17/01/2023.
//

import Foundation

public struct Board : CustomStringConvertible {
    
    private static let descriptionMapper: [Int?:String] = [nil:"-", 1:"X", 2:"O"]
    
    public var description: String {
        var string = String()
        for row in grid.reversed() {
            for cell in row {
                string.append("\(Board.descriptionMapper[cell] ?? "-") ")
            }
            string.append("\n")
        }

        return string
    }

    public let nbRows: Int

    public let nbColumns: Int
    
    public private(set) var grid: [[Int?]]
    
    public init?(withNbRows nbRows: Int = 6, andNbColumns nbColumns: Int = 7) {
        guard nbRows > 0 && nbColumns > 0 else {
            return nil
        }
        
        self.nbRows = nbRows
        self.nbColumns = nbColumns
        grid = Array(repeating: Array(repeating: nil, count: nbColumns), count: nbRows)
    }
    
    public init?(withGrid grid: [[Int?]]) {
        guard grid.count > 0 && grid[0].count > 0 else {
            return nil
        }

        guard grid.allSatisfy ({ $0.count == grid[0].count }) else {
            return nil
        }
        
        nbRows = grid.count
        nbColumns = grid[0].count
        self.grid = grid
    }

    private mutating func insertPiece(by id: Int, atRow row: Int, andAtColumn column: Int) -> Bool {
        guard grid[row][column] == nil else {
            return false
        }
        
        grid[row][column] = id
        
        return true
    }
    
    public mutating func insertPiece(by id: Int, atColumn column: Int) -> BoardResult {
        guard column >= 0 && column < nbColumns else { return .failed(reason: .outOfBounds) }
        
        for row in 0..<nbRows {
            if insertPiece(by: id, atRow: row, andAtColumn: column) {
                return .added(id: id, row: row + 1, column: column + 1)
            }
        }
        
        return .failed(reason: .columnFull)
    }
    
    private mutating func removePiece(atRow row: Int, andAtColumn column: Int) -> (id : Int?, isDeleted: Bool) {
        guard grid[row][column] != nil else {
            return (nil, false)
        }

        let id = grid[row][column]
        grid[row][column] = nil

        return (id, true)
    }
    
    public mutating func removePiece(atColumn column: Int) -> BoardResult {
        guard column >= 0 && column < nbColumns else {
            return .failed(reason: .outOfBounds)
        }
        
        for row in (0..<nbRows).reversed() {
            let (id, isDeleted) = removePiece(atRow: row, andAtColumn: column)
            if isDeleted {
                return .deleted(id: id!, row: row + 1, column: column + 1)
            }
        }

        return .failed(reason: .columnEmpty)
    }
    
    public func isFull() -> Bool {
        grid.allSatisfy {
            $0.allSatisfy {
                $0 != nil
            }
        }
    }

    public func isColumnFull(at column: Int) -> Bool {
        grid.allSatisfy {
            $0[column] != nil
        }
    }

    public func isRowFull(at row: Int) -> Bool {
        grid[row].allSatisfy {
            $0 != nil
        }
    }
}
