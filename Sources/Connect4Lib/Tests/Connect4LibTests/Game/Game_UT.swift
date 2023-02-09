//
// Created by Samuel on 09/02/2023.
//

import XCTest
@testable import Connect4Lib

final class Game_UT: XCTestCase {
    public func testInitWithBoard() throws {
        func expect(withBoard board: Board,
                    andRule rule: IRule,
                    withPlayers players: [Player],
                    andDisplay display: @escaping (GameResponse) -> Void,
                    thatShouldThrow isThrowing: Bool,
                    thisError gameError: GameResponse? = nil) {
            if isThrowing {
                XCTAssertThrowsError(try Game(
                        withBoard: board,
                        andRule: rule,
                        withPlayers: players,
                        andDisplay: display)) { error in
                    if let initError = error as! GameResponse? {
                        XCTAssertEqual(gameError, initError)
                    } else {
                        XCTFail("The error thrown is not a GameError.")
                    }
                }
            } else {
                let game = try! Game(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display)
                XCTAssertEqual(game.board, board)
                XCTAssertTrue(type(of: rule) == type(of: game.rule))
                XCTAssertEqual(game.players, Dictionary(uniqueKeysWithValues: players.enumerated().map { ($1, $0 + 1) }))
            }
        }

        var board = Board(withNbRows: 6, andNbColumns: 7)!
        let rule = StandardRule()
        var players = [Player(withId: 1)!, Player(withId: 2)!]
        let display: (GameResponse) -> Void = { _ in }
        expect(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display, thatShouldThrow: false)

        board = Board(withNbRows: 1, andNbColumns: 7)!
        expect(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display, thatShouldThrow: true,
                thisError: .FailedInit(reason: .TooFewRows))

        board = Board(withNbRows: 8, andNbColumns: 7)!
        expect(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display, thatShouldThrow: true,
                thisError: .FailedInit(reason: .TooManyRows))

        board = Board(withNbRows: 6, andNbColumns: 1)!
        expect(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display, thatShouldThrow: true,
                thisError: .FailedInit(reason: .TooFewColumns))

        board = Board(withNbRows: 6, andNbColumns: 9)!
        expect(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display, thatShouldThrow: true,
                thisError: .FailedInit(reason: .TooManyColumns))

        board = Board(withNbRows: 6, andNbColumns: 7)!
        players = []
        expect(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display, thatShouldThrow: true,
                thisError: .FailedInit(reason: .NotEnoughPlayers(expected: 2, actual: 0)))
    }

    public func testInitWithRule() throws {
        func expected(gameWithRule rule: IRule,
                      withPlayers players: [Player],
                      andDisplay display: @escaping (GameResponse) -> Void,
                      thatShouldThrow isThrowing: Bool,
                      andShouldInitBoardLike board: Board? = nil){
            if isThrowing {
                XCTAssertThrowsError(try Game(
                        withRule: rule,
                        andPlayers: players,
                        withDisplay: display)) { error in
                    if let initError = error as! GameResponse? {
                        XCTAssertEqual(initError, .FailedInit(reason: .NotEnoughPlayers(expected: 2, actual: players.count)))
                    } else {
                        XCTFail("The error thrown is not a GameError.")
                    }
                }
            } else {
                let game = try! Game(withRule: rule, andPlayers: players, withDisplay: display)
                XCTAssertNotNil(game)

                XCTAssertTrue(type(of: rule) == type(of: game.rule))
                XCTAssertEqual(game.players, Dictionary(uniqueKeysWithValues: players.enumerated().map { ($1, $0 + 1) }))
                if let board = board {
                    XCTAssertEqual(game.board, board)
                }
            }
        }

        let rule = StandardRule()
        var players = [Player(withId: 1)!, Player(withId: 2)!]
        let display: (GameResponse) -> Void = { _ in }
        expected(gameWithRule: rule, withPlayers: players, andDisplay: display, thatShouldThrow: false, andShouldInitBoardLike: rule.createBoard())

        players = []
        expected(gameWithRule: rule, withPlayers: players, andDisplay: display, thatShouldThrow: true)
    }

    public func testResetGame() throws {
        let rule = StandardRule()
        let players = [Player(withId: 1)!, Player(withId: 2)!]
        let display: (GameResponse) -> Void = { _ in }

        let grid = [[0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0]]
        let board = Board(withGrid: grid)!

        var game = try! Game(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display)
        XCTAssertEqual(board, game.board)

        game.resetGame()
        XCTAssertEqual(rule.createBoard(), game.board)
    }
}
