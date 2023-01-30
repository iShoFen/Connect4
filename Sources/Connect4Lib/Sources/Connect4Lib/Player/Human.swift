//
// Created by Samuel on 22/01/2023.
//

import Foundation

/// A human player.
public class  Human : Player, Equatable {
    /// The player's pseudo.
    public var pseudo: String

    /// Compares two human players.
    ///
    /// - Parameters:
    ///   - lhs: The first player.
    ///   - rhs: The second player.
    ///
    /// - Returns: `true` if the two players are equal, `false` otherwise.
    public static func ==(lhs: Human, rhs: Human) -> Bool {
        lhs.id == rhs.id && lhs.playingId == rhs.playingId
    }

    /// Creates a new human player.
    ///
    /// - Parameters:
    ///   - id: The player's id.
    ///   - playingId: The player's playing id.
    ///   - pseudo: The player's pseudo.
    public init?(withId id: Int, andPlayingId playingId: Int = 1, andPseudo pseudo: String = "Player") {
        self.pseudo = pseudo
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
    /// - Note: Simply inserts a piece on the board.
    override public func play(onBoard board: inout Board, onColumn column: Int, withLastMove lastMove: (row: Int, column: Int)) -> BoardResult {
        board.insertPiece(by: playingId, atColumn: column)
    }
}
