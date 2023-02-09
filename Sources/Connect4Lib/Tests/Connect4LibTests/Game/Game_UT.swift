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
                XCTAssertEqual(board, game.board)
                XCTAssertTrue(type(of: rule) == type(of: game.rule))
                XCTAssertEqual(players, game.players)
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
                        XCTAssertEqual(.FailedInit(reason: .NotEnoughPlayers(expected: 2, actual: 0)), initError)
                    } else {
                        XCTFail("The error thrown is not a GameError.")
                    }
                }
            } else {
                let game = try! Game(withRule: rule, andPlayers: players, withDisplay: display)
                XCTAssertNotNil(game)

                XCTAssertTrue(type(of: rule) == type(of: game.rule))
                XCTAssertEqual(players, game.players)
                if let board = board {
                    XCTAssertEqual(board, game.board)
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

    public func testStart() throws {
        let display: (GameResponse) -> Void = {
            switch $0 {
            case let .Show(board: grid):
                XCTAssertEqual([[0, 0, 0, 0, 0, 0, nil],
                                      [0, 0, 0, 0, 0, 0, 0],
                                      [0, 0, 0, 0, 0, 0, 0],
                                      [0, 0, 0, 0, 0, 0, 0],
                                      [0, 0, 0, 0, 0, 0, 0],
                                      [0, 0, 0, 0, 0, 0, 0]], grid)

            case .PlayerTurn(id: let id):
                XCTAssert(id == 1 || id == 2)
            case .NoWinner: break
            case .Added(id: let id, row: let row, column: let column):
                XCTAssert(id == 1 || id == 2)
                XCTAssertEqual(0, row)
                XCTAssertEqual(6, column)
            default:XCTFail("The response is not the expected one.")
            }
        }

        let rule = StandardRule()
        let players = [Human(withId: 1, andScanner: { 6 })!, DumbAI()]
        let grid = [[0, 0, 0, 0, 0, 0, nil],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0]]
        let board = Board(withGrid: grid)!
        var game = try! Game(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display)
        game.start()

        let result = game.board.grid
        let expected1v1 = [[0, 0, 0, 0, 0, 0, 1],
                        [0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0]]
        let expected1v2 = [[0, 0, 0, 0, 0, 0, 2],
                        [0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0],
                        [0, 0, 0, 0, 0, 0, 0]]
        XCTAssertTrue(expected1v1 == result || expected1v2 == result)

        let display2: (GameResponse) -> Void = {
            switch $0 {
            case .Show(board: _): break
            case .PlayerTurn(id: _): break
            case .NoWinner: break
            case .Added(id: let id, row: let row, column: let column):
                XCTAssert(id == 1 || id == 2)
                XCTAssertEqual(0, row)
                XCTAssertEqual(6, column)
            case .FailedPlays(reason: let reason):
                XCTAssertEqual(.OutOfBounds, reason)
            default:XCTFail("The response is not the expected one.")
            }
        }
        var play = 8
        func scanner() -> Int {
            play -= 1
            return play
        }
        let players2 = [Human(withId: 1, andScanner: scanner)!, DumbAI()]
        var game2 = try! Game(withBoard: board, andRule: rule, withPlayers: players2, andDisplay: display2)
        game2.start()

        let result2 = game2.board.grid
        XCTAssert(expected1v1 == result2 || expected1v2 == result2)

        let display3: (GameResponse) -> Void = {
            switch $0 {
            case .Show(board: _): break
            case .PlayerTurn(id: _): break
            case .NoWinner: break
            case .Added(id: _, row: _, column: _): break
            case .FailedPlays(reason: let reason):
                XCTAssertEqual(.ColumnFull, reason)
            default:XCTFail("The response is not the expected one.")
            }
        }
        var play3 = 4
        func scanner2() -> Int {
            play3 += 1
            return play3
        }
        let players3 = [Human(withId: 1, andScanner: scanner2)!, DumbAI()]
        var game3 = try! Game(withBoard: board, andRule: rule, withPlayers: players3, andDisplay: display3)
        game3.start()

        let result3 = game3.board.grid
        XCTAssert(expected1v1 == result3 || expected1v2 == result3)

        var player4 = 0
        let display4: (GameResponse) -> Void = {
            switch $0 {
            case .Show(board: _): break
            case .PlayerTurn(id: _): break
            case .Added(id: let id, row: _, column: _): player4 = id
            case . NoWinner:
                if player4 == 1 {
                    XCTFail("The response is not the expected at this point.")
                }
            case .Win(id: let id, at: let positions):
                XCTAssert(id == 1 || id == 2)
                let expPosition = [(0,6), (1,6), (2,6), (3,6)]
                for (index, position) in positions.enumerated() {
                    XCTAssertEqual(expPosition[index].0, position.0)
                    XCTAssertEqual(expPosition[index].1, position.1)
                }
            default:XCTFail("The response is not the expected one.")
            }
        }

        let players4 = [Human(withId: 1, andScanner: {6})!, DumbAI()]
        let grid4 = [[0, 0, 0, 0, 0, nil, nil],
                     [0, 0, 0, 0, 0, 0, 1],
                     [0, 0, 0, 0, 0, 0, 1],
                     [0, 0, 0, 0, 0, 0, 1],
                     [0, 0, 0, 0, 0, 0, 0],
                     [0, 0, 0, 0, 0, 0, 0]]
        let board4 = Board(withGrid: grid4)!
        var game4 = try! Game(withBoard: board4, andRule: rule, withPlayers: players4, andDisplay: display4)
        game4.start()

        let result4 = game4.board.grid
        let expected4v1 = [[0, 0, 0, 0, 0, nil, 1],
                         [0, 0, 0, 0, 0, 0, 1],
                         [0, 0, 0, 0, 0, 0, 1],
                         [0, 0, 0, 0, 0, 0, 1],
                         [0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0]]
        let expected4v2 = [[0, 0, 0, 0, 0, 2, 1],
                         [0, 0, 0, 0, 0, 0, 1],
                         [0, 0, 0, 0, 0, 0, 1],
                         [0, 0, 0, 0, 0, 0, 1],
                         [0, 0, 0, 0, 0, 0, 0],
                         [0, 0, 0, 0, 0, 0, 0]]
        XCTAssert(expected4v1 == result4 || expected4v2 == result4)

        var state = 1
        var player = 0
        let display5: (GameResponse) -> Void = {
            switch $0 {
            case let .Show(board: grid):
                if state == 1 {
                    XCTAssertEqual([[0, 0, 0, 0, 0, nil, nil],
                                          [0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0],
                                          [0, 0, 0, 0, 0, 0, 0]], grid)
                    state += 1
                } else if state == 2 {
                    let gridP1 = [[0, 0, 0, 0, 0, nil, 1],
                                  [0, 0, 0, 0, 0, 0, 0],
                                  [0, 0, 0, 0, 0, 0, 0],
                                  [0, 0, 0, 0, 0, 0, 0],
                                  [0, 0, 0, 0, 0, 0, 0],
                                  [0, 0, 0, 0, 0, 0, 0]]
                    let gridP2 = [[0, 0, 0, 0, 0, 2, nil],
                                  [0, 0, 0, 0, 0, 0, 0],
                                  [0, 0, 0, 0, 0, 0, 0],
                                  [0, 0, 0, 0, 0, 0, 0],
                                  [0, 0, 0, 0, 0, 0, 0],
                                  [0, 0, 0, 0, 0, 0, 0]]
                    XCTAssertEqual(player == 1 ? gridP1 : gridP2, grid)
                    state += 1
                } else {
                    XCTFail("The response is not expected at this state.")
                }
            case let .PlayerTurn(id: id):
                if player == 0 {
                    XCTAssert(id == 1 || id == 2)
                    player = id
                } else {
                    XCTAssertEqual(player == 1 ? 2 : 1, id)
                    player = id
                }

            case let .Added(id: id, row: row, column: column):
                XCTAssertEqual(player, id)
                XCTAssertEqual(0, row)
                XCTAssertEqual(player == 1 ? 6 : 5, column)

            case .NoWinner: break
            default:XCTFail("The response is not the expected one.")
            }
        }

        let grid5 = [[0, 0, 0, 0, 0, nil, nil],
                     [0, 0, 0, 0, 0, 0, 0],
                     [0, 0, 0, 0, 0, 0, 0],
                     [0, 0, 0, 0, 0, 0, 0],
                     [0, 0, 0, 0, 0, 0, 0],
                     [0, 0, 0, 0, 0, 0, 0]]
        let board5 = Board(withGrid: grid5)!

        let players5 = [Human(withId: 1, andScanner: {6})!, Human(withId: 2, andScanner: {5})!]
        var game5 = try! Game(withBoard: board5, andRule: rule, withPlayers: players5, andDisplay: display5)
        game5.start()

        let result5 = game5.board.grid
        let expResult5 = [[0, 0, 0, 0, 0, 2, 1],
                          [0, 0, 0, 0, 0, 0, 0],
                          [0, 0, 0, 0, 0, 0, 0],
                          [0, 0, 0, 0, 0, 0, 0],
                          [0, 0, 0, 0, 0, 0, 0],
                          [0, 0, 0, 0, 0, 0, 0]]
        XCTAssertEqual(expResult5, result5)
    }
}

