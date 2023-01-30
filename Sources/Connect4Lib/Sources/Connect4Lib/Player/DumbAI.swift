//
// Created by Samuel on 22/01/2023.
//

import Foundation

/// An AI player.
public class DumbAI : Player {

    public override init?(withId id: Int, andPlayingId playingId: Int = 1) {
        super.init(withId: id, andPlayingId: playingId)
    }

    /// Play on a board.
    ///
    /// - Parameters:
    ///   - board: The board to play on.
    ///   - column: The column to play on.
    ///   - lastMove: The last move played on the board.
    ///
    /// - Returns: A `BoardResult` indicating if the move was valid.
    ///
    /// - Note: Try to play on the column next to the last move, if it's not possible, play on a random column.
    override public func play(onBoard board: inout Board, onColumn column: Int, withLastMove lastMove: (row: Int, column: Int)) -> BoardResult {
        let row = lastMove.row
        let column = lastMove.column
        let columnOffset = Int.random(in: -1...1)

        if column + columnOffset >= 0 && column + columnOffset < board.nbColumns {
            if board.grid[row][column + columnOffset] == nil {
                return board.insertPiece(by: playingId, atColumn: column + columnOffset)
            }
        }

        for i in 0..<board.nbColumns {
            if board.grid[row][i] == nil {
                return board.insertPiece(by: playingId, atColumn: i)
            }
        }

        return .unknown
    }
}
