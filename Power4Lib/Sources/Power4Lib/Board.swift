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
        for row in _grid.reversed() {
            for cell in row {
                string.append("\(String(describing: Board.descriptionMapper[cell] ?? "-")) ")
            }
            string.append("\n")
        }

        return string
    }

    public let nbRows: Int

    public let nbColumns: Int
    
    var _grid: [[Int?]]

    public var grid: [[Int?]] { _grid }
    
    public init?(withNbRows nbRows: Int = 6, andNbColumns nbColumns: Int = 7) {
        guard nbRows > 0 && nbColumns > 0 else {
            return nil
        }
        
        self.nbRows = nbRows
        self.nbColumns = nbColumns
        _grid = Array(repeating: Array(repeating: nil, count: nbColumns), count: nbRows)
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
        _grid = grid
    }
    
    private mutating func insertPiece(by id: Int, atRow row: Int, andAtColumn column: Int) -> Bool {
        guard _grid[row][column] == nil else {
            return false
        }
        
        _grid[row][column] = id
        
        return true
    }
    
    public mutating func insertPiece(by id: Int, atColumn column: Int) -> BoardResult {
        guard column > 0 && column <= nbColumns else { return .failed(reason: .outOfBounds) }
        
        for r in 0..<nbRows {
            if insertPiece(by: id, atRow: r, andAtColumn: column - 1) {
                return .added(id: id, row: r + 1, column: column)
            }
        }
        
        return .failed(reason: .columnFull)
    }
    
    private mutating func removePiece(atRow row: Int, andAtColumn column: Int) -> Bool {
        guard _grid[row][column] != nil else {
            return false
        }

        _grid[row][column] = nil

        return true
    }
    
    public mutating func removePiece(column: Int) -> BoardResult {
        guard column >= 0 && column < nbColumns else {
            return .failed(reason: .outOfBounds)
        }
        
        for r in (0..<nbRows).reversed() {
            if removePiece(atRow: r, andAtColumn: column) {
                return .deleted(row: r, column: column)
            }
        }
        
        return .failed(reason: .columnEmpty)
    }
    
    public func isFull() -> Bool {
        _grid.allSatisfy {
            $0.allSatisfy {
                $0 != nil
            }
        }
    }
}
