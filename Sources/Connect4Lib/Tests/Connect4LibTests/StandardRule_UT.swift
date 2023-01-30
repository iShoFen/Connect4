//
// Created by Samuel on 29/01/2023.
//

import XCTest
@testable import Connect4Lib

class StandardRule_UT: XCTestCase {
    func testInit() throws {
        let rule = StandardRule()
        XCTAssertEqual(6, rule.minRow)
        XCTAssertEqual(6, rule.maxRow)
        XCTAssertEqual(7, rule.minColumn)
        XCTAssertEqual(7, rule.maxColumn)
        XCTAssertEqual(4, rule.nbPiecesToWin)
        XCTAssertTrue(rule.isDiagonalWinAllowed)
    }

    func testIsValid() throws {
        func expect(board: Board, withValidity valid: RuleResult) {
            let rule = StandardRule()
            let validity = rule.isValid(board: board)
            XCTAssertEqual(valid, validity)
        }

        expect(board: Board(withNbRows: 5, andNbColumns: 7)!, withValidity: .invalid(reason: .TooFewRows))
        expect(board: Board(withNbRows: 7, andNbColumns: 7)!, withValidity: .invalid(reason: .TooManyRows))
        expect(board: Board(withNbRows: 6, andNbColumns: 6)!, withValidity: .invalid(reason: .TooFewColumns))
        expect(board: Board(withNbRows: 6, andNbColumns: 8)!, withValidity: .invalid(reason: .TooManyColumns))
        expect(board: Board(withNbRows: 6, andNbColumns: 7)!, withValidity: .valid)
    }

    func testIsGameOver() throws
    {
        func expect(board: Board, withLastMove lastMove: (row: Int, column: Int), andValidity valid: RuleResult) {
            let rule = StandardRule()
            let validity = rule.isGameOver(onBoard: board, withLastMove: lastMove)
            XCTAssertEqual(valid, validity)
        }

        expect(board: Board(withNbRows: 5, andNbColumns: 7)!, withLastMove: (0, 0), andValidity: .invalid(reason: .TooFewRows))
        expect(board: Board(withNbRows: 7, andNbColumns: 7)!, withLastMove: (0, 0), andValidity: .invalid(reason: .TooManyRows))
        expect(board: Board(withNbRows: 6, andNbColumns: 6)!, withLastMove: (0, 0), andValidity: .invalid(reason: .TooFewColumns))
        expect(board: Board(withNbRows: 6, andNbColumns: 8)!, withLastMove: (0, 0), andValidity: .invalid(reason: .TooManyColumns))
        expect(board: Board(withNbRows: 6, andNbColumns: 7)!, withLastMove: (0, 0), andValidity: .invalid(reason: .EmptyLastMove))

        var grid: [[Int?]] = [[1, 2, 1, 2, 1, 2, 1],
                    [2, 2, 1, 2, 1, 1, 2],
                    [2, 2, 1, 2, 1, 1, 1],
                    [2, 1, 2, 1, 2, 2, 2],
                    [1, 1, 1, 2, 2, 1, 1],
                    [2, 1, 2, 1, 1, 1, 2]]
        var board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (5, 6), andValidity: .notWon(reason: .BoardFull))

        grid = Array(repeating: Array(repeating: nil, count: 7), count: 6)
        grid[0][0] = 1
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (0, 0), andValidity: .notWon(reason: .NoWinner))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [2, 2, nil, 2, nil, nil, nil],
                [1, 1, 1, 1, 2, 2, 2]]
        var winingGrid = [[nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [1, 1, 1, 1, nil, nil, nil]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (5, 3), andValidity: .won(id: 1, at: winingGrid))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [2, 2, 2, nil, nil, nil, nil],
                [1, 2, 2, 1, 1, 1, 1]]
        winingGrid = [[nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, 1, 1, 1, 1]]
        board = Board(withGrid: grid)!
       expect(board: board, withLastMove: (5, 4), andValidity: .won(id: 1, at: winingGrid))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [1, 2, 1, 1, 1, 2, 2]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (5, 5), andValidity: .notWon(reason: .NoWinner))

        grid = [[1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [2, 2, nil, nil, nil, nil, nil],
                [2, 2, 2, nil, nil, nil, nil]]
        winingGrid = [[1, nil, nil, nil, nil, nil, nil],
                      [1, nil, nil, nil, nil, nil, nil],
                      [1, nil, nil, nil, nil, nil, nil],
                      [1, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (0, 0), andValidity: .won(id: 1, at: winingGrid))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, 2, nil, nil, nil, nil, nil],
                [2, 2, 2, nil, nil, nil, nil]]
        winingGrid = [[nil, nil, nil, nil, nil, nil, nil],
                      [1, nil, nil, nil, nil, nil, nil],
                      [1, nil, nil, nil, nil, nil, nil],
                      [1, nil, nil, nil, nil, nil, nil],
                      [1, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (1, 0), andValidity: .won(id: 1, at: winingGrid))

        grid = [[1, nil, nil, nil, nil, nil, nil],
                [2, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [1, nil, nil, nil, nil, nil, nil],
                [2, 2, nil, nil, nil, nil, nil],
                [2, 2, 2, nil, nil, nil, nil]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (0, 0), andValidity: .notWon(reason: .NoWinner))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, 1, nil, 1, 2],
                [nil, nil, nil, 1, 1, 2, 1],
                [nil, nil, nil, 2, 2, 1, 1],
                [nil, nil, nil, 2, 2, 2, 1]]
        winingGrid = [[nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, 1, nil, nil, nil],
                      [nil, nil, nil, nil, 1, nil, nil],
                      [nil, nil, nil, nil, nil, 1, nil],
                      [nil, nil, nil, nil, nil, nil, 1]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (2, 3), andValidity: .won(id: 1, at: winingGrid))

        grid = [[1, nil, nil, nil, nil, nil, nil],
                [1, 1, nil, nil, nil, nil, nil],
                [1, 2, 1, nil, nil, nil, nil],
                [2, 2, 2, 1, nil, nil, nil],
                [1, 2, 1, 2, 2, nil, nil],
                [2, 2, 2, 1, 2, 1, nil]]
        winingGrid = [[1, nil, nil, nil, nil, nil, nil],
                      [nil, 1, nil, nil, nil, nil, nil],
                      [nil, nil, 1, nil, nil, nil, nil],
                      [nil, nil, nil, 1, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (0, 0), andValidity: .won(id: 1, at: winingGrid))

        grid = [[nil, nil, nil, nil, 1, nil, nil],
                [nil, nil, nil, nil, 2, 1, nil],
                [nil, nil, nil, nil, 2, 2, 1],
                [nil, nil, nil, nil, 2, 1, 1],
                [nil, nil, nil, nil, 1, 1, 2],
                [nil, nil, nil, nil, 2, 2, 2]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (5, 4), andValidity: .notWon(reason: .NoWinner))

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [2, 1, 1, 1, nil, nil, nil],
                [1, 2, 1, 2, nil, nil, nil],
                [1, 1, 1, 2, nil, nil, nil],
                [1, 2, 2, 2, 1, nil, nil]]
    winingGrid = [[nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, 1, nil, nil, nil],
              [nil, nil, 1, nil, nil, nil, nil],
              [nil, 1, nil, nil, nil, nil, nil],
              [1, nil, nil, nil, nil, nil, nil]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (2, 3), andValidity: .won(id: 1, at: winingGrid))

        grid = [[nil, nil, nil, nil, nil, nil, 1],
                [nil, nil, nil, nil, nil, 2, 1],
                [nil, nil, nil, nil, 1, 2, 1],
                [nil, nil, nil, 1, 2, 1, 2],
                [nil, nil, 1, 1, 2, 1, 2],
                [nil, 1, 1, 2, 1, 2, 2]]
        winingGrid = [[nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, nil, nil, nil],
                      [nil, nil, nil, nil, 1, nil, nil],
                      [nil, nil, nil, 1, nil, nil, nil],
                      [nil, nil, 1, nil, nil, nil, nil],
                      [nil, 1, nil, nil, nil, nil, nil]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (3, 3), andValidity: .won(id: 1, at: winingGrid))

        grid = [[2, 2, 1, nil, nil, nil, nil],
                [2, 1, 2, nil, nil, nil, nil],
                [1, 2, 2, nil, nil, nil, nil],
                [2, 2, 1, nil, nil, nil, nil],
                [2, 1, 1, nil, nil, nil, nil],
                [2, 1, 1, 1, 2, nil, nil]]
        board = Board(withGrid: grid)!
        expect(board: board, withLastMove: (0, 2), andValidity: .notWon(reason: .NoWinner))
    }
}
