//
// Created by Samuel on 22/01/2023.
//

import Foundation

/// A player that can play on a board.
public class Player {
    /// The player's id.
    public let id: Int
    /// The player's playing id.
    public let playingId: Int

    /// Creates a new player.
    /// - Parameters:
    ///   - id: The player's id.
    ///   - playingId: The player's playing id.
    ///
    /// - Returns: A new player.
    public init?(withId id: Int, andPlayingId playingId: Int) {
        guard id > 0 && playingId > 0 else {
            return nil
        }

        self.id = id
        self.playingId = playingId
    }

    /// Play on a board.
    ///
    /// - Parameters:
    ///   - board: The board to play on.
    ///   - column: The column to play on.
    ///   - lastMove: The last move played on the board.
    ///
    /// - Returns: A `BoardResult` indicating if the move was valid.
    public func play(onBoard board: inout Board, onColumn column: Int, withLastMove lastMove: (row: Int, column: Int)) -> BoardResult {
        .unknown
    }
}
