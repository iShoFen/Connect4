//
// Created by Samuel on 29/01/2023.
//

import XCTest
@testable import Connect4Lib

class StandardRule_UT: XCTestCase {
    func testInit() throws {
        let rule = StandardRule()
        XCTAssertEqual(6, rule.row)
        XCTAssertEqual(7, rule.column)
        XCTAssertEqual(4, rule.nbPiecesToWin)
        XCTAssertTrue(rule.isDiagonalWinAllowed)
    }

    func testCreateBoard() throws {
        let rule = StandardRule()
        let board = rule.createBoard()
        XCTAssertEqual(6, board.nbRows)
        XCTAssertEqual(7, board.nbColumns)

        for row in 0..<board.nbRows {
            for column in 0..<board.nbColumns {
                XCTAssertNil(board.grid[row][column])
            }
        }
    }

    func testIsValid() throws {
        func expect(board: Board, withValidity valid: RuleResult) {
            let rule = StandardRule()
            let validity = rule.isValid(board: board)
            XCTAssertEqual(valid, validity)
        }

        expect(board: Board(withNbRows: 5, andNbColumns: 7)!, withValidity: .Invalid(reason: .TooFewRows))
        expect(board: Board(withNbRows: 7, andNbColumns: 7)!, withValidity: .Invalid(reason: .TooManyRows))
        expect(board: Board(withNbRows: 6, andNbColumns: 6)!, withValidity: .Invalid(reason: .TooFewColumns))
        expect(board: Board(withNbRows: 6, andNbColumns: 8)!, withValidity: .Invalid(reason: .TooManyColumns))
        expect(board: Board(withNbRows: 6, andNbColumns: 7)!, withValidity: .Valid)
    }

    func testIsGameOver() throws
    {
        func expect(board: Board, withLastMove lastMove: (row: Int, column: Int), andValidity valid: RuleResult) {
            let rule = StandardRule()
            let validity = rule.isGameOver(onBoard: board, withLastMove: lastMove)
            XCTAssertEqual(valid, validity)
        }

        expect(board: Board(withNbRows: 5, andNbColumns: 7)!, withLastMove: (0, 0), andValidity: .Invalid(reason: .TooFewRows))
        expect(board: Board(withNbRows: 7, andNbColumns: 7)!, withLastMove: (0, 0), andValidity: .Invalid(reason: .TooManyRows))
        expect(board: Board(withNbRows: 6, andNbColumns: 6)!, withLastMove: (0, 0), andValidity: .Invalid(reason: .TooFewColumns))
        expect(board: Board(withNbRows: 6, andNbColumns: 8)!, withLastMove: (0, 0), andValidity: .Invalid(reason: .TooManyColumns))
        expect(board: Board(withNbRows: 6, andNbColumns: 7)!, withLastMove: (0, 0), andValidity: .Invalid(reason: .EmptyLastMove))

        var grid: [[Int?]] = [[1, 2, 1, 2, 1, 2, 1],
                    [2, 2, 1, 2, 1, 1, 2],
                    [2, 2, 1, 2, 1, 1, 1],
                    [2, 1, 2, 1, 2, 2, 2],
                    [1, 1, 1, 2, 2, 1, 1],
                    [2, 1, 2, 1, 1, 1, 2]]
        var board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (5, 6), andValidity: .NotWon(reason: .BoardFull))

        grid = Array(repeating: Array(repeating: nil, count: 7), count: 6)
        grid[0][0] = 1
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (0, 0), andValidity: .NotWon(reason: .NoWinner))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [2, 2, nil, 2, nil, nil, nil],
                [1, 1, 1, 1, 2, 2, 2]]
        var winingIndexes = [(5, 0), (5, 1), (5, 2), (5, 3)]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (5, 3), andValidity: .Won(id: 1, at: winingIndexes))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [2, 2, 2, nil, nil, nil, nil],
                [1, 2, 2, 1, 1, 1, 1]]
        winingIndexes = [(5, 3), (5, 4), (5, 5), (5, 6)]
        board = Board(withGrid: grid)!
       expect(board: board, withLastMove: (5, 4), andValidity: .Won(id: 1, at: winingIndexes))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [1, 2, 1, 1, 1, 2, 2]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (5, 5), andValidity: .NotWon(reason: .NoWinner))

        grid = [[1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [2, 2, nil, nil, nil, nil, nil],
                [2, 2, 2, nil, nil, nil, nil]]
        winingIndexes = [(0, 0), (1, 0), (2, 0), (3, 0)]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (0, 0), andValidity: .Won(id: 1, at: winingIndexes))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, 2, nil, nil, nil, nil, nil],
                [2, 2, 2, nil, nil, nil, nil]]
        winingIndexes = [(1, 0), (2, 0), (3, 0), (4, 0)]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (1, 0), andValidity: .Won(id: 1, at: winingIndexes))

        grid = [[1, nil, nil, nil, nil, nil, nil],
                [2, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [2, 2, nil, nil, nil, nil, nil],
                [2, 2, 2, nil, nil, nil, nil]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (0, 0), andValidity: .NotWon(reason: .NoWinner))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, 1, nil, 1, 2],
                [nil, nil, nil, 1, 1, 2, 1],
                [nil, nil, nil, 2, 2, 1, 1],
                [nil, nil, nil, 2, 2, 2, 1]]
        winingIndexes = [(2, 3), (3, 4), (4, 5), (5, 6)]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (2, 3), andValidity: .Won(id: 1, at: winingIndexes))

        grid = [[1, nil, nil, nil, nil, nil, nil],
                [1, 1, nil, nil, nil, nil, nil],
                [1, 2, 1, nil, nil, nil, nil],
                [2, 2, 2, 1, nil, nil, nil],
                [1, 2, 1, 2, 2, nil, nil],
                [2, 2, 2, 1, 2, 1, nil]]
        winingIndexes = [(0, 0), (1, 1), (2, 2), (3, 3)]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (0, 0), andValidity: .Won(id: 1, at: winingIndexes))

        grid = [[nil, nil, nil, nil, 1, nil, nil],
                [nil, nil, nil, nil, 2, 1, nil],
                [nil, nil, nil, nil, 2, 2, 1],
                [nil, nil, nil, nil, 2, 1, 1],
                [nil, nil, nil, nil, 1, 1, 2],
                [nil, nil, nil, nil, 2, 2, 2]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (5, 4), andValidity: .NotWon(reason: .NoWinner))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [2, 1, 1, 1, nil, nil, nil],
                [1, 2, 1, 2, nil, nil, nil],
                [1, 1, 1, 2, nil, nil, nil],
                [1, 2, 2, 2, 1, nil, nil]]
    winingIndexes = [(2, 3), (3,2), (4,1), (5, 0)]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (2, 3), andValidity: .Won(id: 1, at: winingIndexes))

        grid = [[nil, nil, nil, nil, nil, nil, 1],
                [nil, nil, nil, nil, nil, 2, 1],
                [nil, nil, nil, nil, 1, 2, 1],
                [nil, nil, nil, 1, 2, 1, 2],
                [nil, nil, 1, 1, 2, 1, 2],
                [nil, 1, 1, 2, 1, 2, 2]]
        board = Board(withGrid: grid)!
        winingIndexes = [(2, 4), (3, 3), (4, 2), (5, 1)]
        expect(board: board, withLastMove: (3, 3), andValidity: .Won(id: 1, at: winingIndexes))

        grid = [[2, 2, 1, nil, nil, nil, nil],
                [2, 1, 2, nil, nil, nil, nil],
                [1, 2, 2, nil, nil, nil, nil],
                [2, 2, 1, nil, nil, nil, nil],
                [2, 1, 1, nil, nil, nil, nil],
                [2, 1, 1, 1, 2, nil, nil]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (0, 2), andValidity: .NotWon(reason: .NoWinner))
    }
}
