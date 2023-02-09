//
// Created by Samuel on 08/02/2023.
//

import Foundation

/// The game is the main class of the library. It is used to create a game and to start it.
public struct Game {

    /// The board of the game
    public var board: Board

    /// The rule of the game
    public let rule: IRule

    /// The players of the game
    public let players: [Player]

    /// The current player index
    private var currentPlayer = -1

    /// The last move played
    private var lastMove: (row: Int, column: Int) = (-1, -1)

    /// The display function
    private let display: (GameResponse) -> Void

    /// Create a game with a board, a rule, players and a display function
    ///
    /// - Parameters:
    ///   - board: The board of the game
    ///   - rule: The rule of the game
    ///   - players: The players of the game
    ///   - display: The display function
    public init(withBoard board: Board,
                andRule rule: IRule,
                withPlayers players: [Player],
                andDisplay display: @escaping (GameResponse) -> Void)
    throws {
        let result = rule.isValid(board: board)
        guard result == .Valid else {
            if case let .Invalid(reason) = result {
                throw GameResponse.FailedInit(reason: try! reason.toInitError())
            }

            preconditionFailure("The result of the rule is not valid or invalid")
        }


        guard (players.count > 1) else {
            throw GameResponse.FailedInit(reason: .NotEnoughPlayers(expected: 2, actual: players.count))
        }

        self.players = players
        self.board = board
        self.rule = rule
        self.display = display

        currentPlayer = Int.random(in: 0..<players.count)
    }

    /// Create a game with a rule, players and a display function
    ///
    /// - Parameters:
    ///   - rule: The rule of the game
    ///   - players: The players of the game
    ///   - display: The display function
    public init(withRule rule: IRule, andPlayers players: [Player], withDisplay display: @escaping (GameResponse) -> Void) throws {
        try self.init(withBoard: rule.createBoard(), andRule: rule, withPlayers: players, andDisplay: display)
    }

    /// Reset the game
    public mutating func resetGame() {
        board = rule.createBoard()
        currentPlayer = Int.random(in: 0..<players.count)
    }

    /// Try to play a move
    /// If the move is valid, the game state is updated
    /// If the move is not valid, the player is asked to play again
    private mutating func play() {
        var validMove = false
        repeat {
            let column = players[currentPlayer].playOnColumn(onBoard: board, withLastMove: lastMove, withThisRule: rule)!
            validMove = validateMove(onColumn: column)
        } while !validMove
    }

    /// Play the game
    ///
    /// - Parameter column: The column to play on
    /// - Returns: True if the piece was added, false otherwise
    private mutating func validateMove(onColumn column: Int) -> Bool {
        let result = board.insertPiece(by: currentPlayer + 1, atColumn: column)
        switch result {
            case let .Added(id, row, column):
                lastMove = (row, column)
                display(.Added(id: id, row: row, column: column))
                return true
            case let .Failed(reason):
                display(.FailedPlays(reason: reason.toPlayingError()))
            default: preconditionFailure("Unexpected result")
        }

        return false
    }

    /// Validate the game state
    ///
    /// - Parameter result: The result of the game
    /// - Returns: True if the game is over, false otherwise
    private func validateGameState(withResult result: RuleResult) -> Bool {
        switch result {
            case let .Won(player, winingIndexes):
                display(.Win(id: player, at: winingIndexes))
                return true
            case let .NotWon(reason):
                if reason == .BoardFull {
                    display(.NoWinner)
                    return true
                }
            default: preconditionFailure("Unexpected result")
        }

        return false
    }

    /// Start the game
    /// Play the game until it's over
    /// Display the result of the game with the display function
    public mutating func start() {
        var isOver = false
        while !isOver {
            display(.Show(board: board.grid))
            display(.PlayerTurn(id: currentPlayer + 1))
            play()
            let result = rule.isGameOver(onBoard: board, withLastMove: lastMove)
            isOver = validateGameState(withResult: result)
            currentPlayer = (currentPlayer + 1) % players.count
        }
    }
}
