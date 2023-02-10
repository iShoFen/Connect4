//
// Created by Samuel on 22/01/2023.
//

import Foundation

/// An AI player.
public class DumbAI : Player {

    /// Creates a AI player.
    ///
    /// - Parameter id: The player's id.
    ///
    /// - Returns: A new AI player.
    ///
    /// - Note: The id must be 0, prefer using the `init()` CI instead.
    public override init?(withId id: UInt64) {
        guard id == 0 else {
            return nil
        }
        super.init(withId: id)
    }

    /// Creates a new AI player.
    ///
    /// - Returns: A new AI player.
    ///
    /// - Note: CI to create a new AI player.
    public convenience init() {
        self.init(withId: 0)!
    }

    /// Play on a board.
    ///
    /// - Parameters:
    ///   - board: The board to play on.
    ///   - column: The column to play on.
    ///   - lastMove: The last move played on the board.
    ///   - rule: The rule to apply.
    ///
    /// - Returns: The column to play on.
    ///
    /// - Note: Play around the last move and if it's not possible, play randomly.
    override public func playOnColumn(onBoard board: Board,
                              withLastMove lastMove: (row: Int, column: Int),
                              withThisRule rule: IRule) -> Int? {
        var myBoard = board
        let column = lastMove.column
        let columnOffset = Int.random(in: -1...1)

        if column + columnOffset >= 0 && column + columnOffset < board.nbColumns {
            let result = myBoard.insertPiece(by: 0, atColumn: column + columnOffset)
            if result != .Failed(reason: .ColumnFull)
            {
                return column + columnOffset
            }
        }

        for i in 0..<myBoard.nbColumns {
            let result = myBoard.insertPiece(by: 0, atColumn: i)
            if result != .Failed(reason: .ColumnFull) {
                return i
            }
        }

        return nil
    }
}
