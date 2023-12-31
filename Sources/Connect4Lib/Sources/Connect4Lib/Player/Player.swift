//
// Created by Samuel on 22/01/2023.
//

import Foundation

/// A player that can play on a board.
public class Player: Equatable, Hashable {
    /// The player's id.
    public let id: UInt64

    /// Compares two players.
    ///
    /// - Parameters:
    ///   - lhs: The first player.
    ///   - rhs: The second player.
    ///
    /// - Returns: `true` if the two players are equal, `false` otherwise.
    public static func ==(lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }

    /// Hashes the player.
    ///
    /// - Parameter hasher: The hasher to use.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// Creates a new player.
    /// - Parameters:
    ///   - id: The player's id.
    ///   - playingId: The player's playing id.
    ///
    /// - Returns: A new player.
    public init?(withId id: UInt64) {
        self.id = id
    }

    /// Play on a board.
    ///
    /// - Parameters:
    ///   - board: The board to play on.
    ///   - column: The column to play on.
    ///   - lastMove: The last move played on the board.
    ///   - rule: The rule to apply.
    ///
    /// - Returns: A `nil` because it's an abstract class.
    ///
    /// - Note: This method is abstract and should be overriden.
    public func playOnColumn(onBoard board: Board,
                             withLastMove lastMove: (row: Int, column: Int),
                             withThisRule rule: IRule) -> Int? {
        nil
    }
}
