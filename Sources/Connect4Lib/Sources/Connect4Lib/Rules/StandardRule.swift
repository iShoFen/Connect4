//
// Created by Samuel on 25/01/2023.
//

import Foundation

public struct StandardRule : IRule {
    public let minRow: Int = 6

    public let maxRow: Int = 6

    public let minColumn: Int = 7

    public let maxColumn: Int = 7

    public let nbPiecesToWin: Int = 4

    public let isDiagonalWinAllowed: Bool = true

    public func isValid(board: Board) -> RuleResult {
        guard board.nbRows >= minRow else {
            return .invalid(reason: .TooFewRows)
        }

        guard board.nbRows <= maxRow else {
            return .invalid(reason: .TooManyRows)
        }

        guard board.nbColumns >= minColumn  else {
            return .invalid(reason: .TooFewColumns)
        }

        guard board.nbColumns <= maxColumn else {
            return .invalid(reason: .TooManyColumns)
        }

        return .valid
    }

    public func isGameOver(onBoard board: Board, withLastMove lastMove: (row: Int, column: Int)) -> RuleResult {
        let validity = isValid(board: board)
        guard validity == .valid else {
            return validity
        }

        guard board.grid[lastMove.row][lastMove.column] != nil else {
            return .invalid(reason: .EmptyLastMove)
        }

        let winingIndexes = isWin(onBoard: board, withLastMove: lastMove)
        if let winingIndexes {
            return .won(id: board.grid[lastMove.row][lastMove.column]!, at: winingIndexes)
        }

        guard !board.isFull() else {
            return .notWon(reason: .BoardFull)
        }

        return .notWon(reason: .NoWinner)
    }

    /// Check if the last move won the game.
    ///
    /// - Parameters:
    ///   - board: The board to check.
    ///   - lastMove: The last move made on the board.
    /// - Returns: A `[[Int?]]` indicating the winning board.
    ///
    /// - Note: Check if the last move won the game horizontally, vertically, or diagonally.
    private func isWin(onBoard board: Board, withLastMove lastMove: (row: Int, column: Int)) -> [(Int, Int)]?
    {
        let playerId = board.grid[lastMove.row][lastMove.column]
        var winingBoard: [(Int, Int)] = []
        var nbPieces = 1

        let directions: [(row: Int, column: Int)] = [
            (row: 0, column: 1), // Horizontal
            (row: 0, column: -1), // Horizontal
            (row: 1, column: 0), // Vertical
            (row: -1, column: 0), // Vertical
            (row: 1, column: 1), // DiagonalLeft
            (row: -1, column: -1), // DiagonalLeft
            (row: 1, column: -1), // DiagonalRight
            (row: -1, column: 1) // DiagonalRight
        ]
        var directionsIndex = 0
        for direction in directions {
            if directionsIndex % 2 == 0 {
                winingBoard = []
                nbPieces = 1
            }

            var row = lastMove.row + direction.row
            var col = lastMove.column + direction.column
            while row >= 0 && row < board.nbRows && col >= 0 && col < board.nbColumns {
                if board.grid[row][col] == playerId {
                    nbPieces += 1
                    winingBoard.append((row, col))
                } else {
                    break
                }

                if nbPieces >= nbPiecesToWin {
                    winingBoard.append((lastMove.row, lastMove.column))
                    // Sort the array by row then column
                    winingBoard.sort(by: { (a, b) in a.0 == b.0 ? a.1 < b.1 : a.0 < b.0 })
                    return winingBoard
                }
                row += direction.row
                col += direction.column
            }

            directionsIndex += 1
        }

        return nil
    }
}
