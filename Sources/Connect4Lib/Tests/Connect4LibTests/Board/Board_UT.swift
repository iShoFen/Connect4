//
//  Board_UT.swift
//
//
//  Created by Samuel on 18/01/2023.
//

import XCTest
@testable import Connect4Lib

final class Board_UT: XCTestCase {
    
    func testInit() throws {
        func expect(initBoardWithNbRows nbRows: Int, andNbColumns nbColumns: Int, shouldBeNotNil notNil: Bool) {
            let board = Board(withNbRows: nbRows, andNbColumns: nbColumns)
            
            if !notNil {
                XCTAssertNil(board)
                return
            }
            XCTAssertNotNil(board)
            XCTAssertEqual(nbRows, board?.nbRows)
            XCTAssertEqual(nbColumns, board?.nbColumns)
            XCTAssertEqual(nbRows, board?.grid.count)
            XCTAssertEqual(nbColumns, board?.grid[0].count)
        }
        
        expect(initBoardWithNbRows: 6, andNbColumns: 7, shouldBeNotNil: true)
        expect(initBoardWithNbRows: 0, andNbColumns: 7, shouldBeNotNil: false)
        expect(initBoardWithNbRows: 6, andNbColumns: 0, shouldBeNotNil: false)
        expect(initBoardWithNbRows: -6, andNbColumns: 7, shouldBeNotNil: false)
        expect(initBoardWithNbRows: 6, andNbColumns: -7, shouldBeNotNil: false)
        expect(initBoardWithNbRows: 0, andNbColumns: 0, shouldBeNotNil: false)
    }

    func testInitWithGrid() throws {
        func expect(initBoardWithGrid grid: [[Int?]], shouldBeNotNil notNil: Bool) {
            let board = Board(withGrid: grid)

            if !notNil {
                XCTAssertNil(board)
                return
            }

            XCTAssertNotNil(board)
            XCTAssertEqual(grid.count, board!.nbRows)
            XCTAssertEqual(grid[0].count, board!.nbColumns)
            XCTAssertEqual(grid, board!.grid)
        }
        expect(initBoardWithGrid: [[1,2,1,2,1,2,1], [1,2,1,2,1,2,1]], shouldBeNotNil: true)
        expect(initBoardWithGrid: [[1,2,nil,2,1,nil,1], [1,nil,nil,nil,1,2,1]], shouldBeNotNil: true)
        expect(initBoardWithGrid: [], shouldBeNotNil: false)
        expect(initBoardWithGrid: [[], []], shouldBeNotNil: false)
        expect(initBoardWithGrid: [[1,2,1,2,1,2,1], [1,2,1,2,1,2]], shouldBeNotNil: false)
    }

    func testDescription() throws {
        let loadBoard = [[1,2,nil,nil], [1,2,3,nil], [3,2,3,2]]
        let board = Board(withGrid: loadBoard)!
        let expectedDescription = """
                                  |-|O|-|O|
                                  |X|O|-|-|
                                  |X|O|-|-|\n
                                  """
        XCTAssertEqual(expectedDescription, board.description)
    }

    func testInsert() throws {
        func expect(insertPieceBy id: Int, atRow row: Int, andAtColumn column: Int, inBoard board: Board, shouldFail fail: FailedReason?) {
            var board = board
            let result = board.insertPiece(by: id, atColumn: column)

            if fail != nil {
                XCTAssertEqual(.Failed(reason: fail!), result)
                return
            }

            XCTAssertEqual(.Added(id: id, row: row + 1, column: column + 1), result)
        }

        expect(insertPieceBy: 1, atRow: 0, andAtColumn: 0, inBoard: Board(withNbRows: 3, andNbColumns: 2)!, shouldFail: nil)
        expect(insertPieceBy: 1, atRow: 0, andAtColumn: -1, inBoard: Board(withNbRows: 3, andNbColumns: 2)!, shouldFail: .OutOfBounds)
        expect(insertPieceBy: 1, atRow: 0, andAtColumn: 2, inBoard: Board(withGrid: [[1,2,1]])!, shouldFail: .ColumnFull)
    }

    func testDelete() throws {
        func expect(deletePieceBy id: Int, atRow row: Int, andAtColumn column: Int, inBoard board: Board, shouldFail fail: FailedReason?) {
            var board = board
            let result = board.removePiece(atColumn: column)

            if fail != nil {
                XCTAssertEqual(.Failed(reason: fail!), result)
                return
            }

            XCTAssertEqual(.Deleted(id: id, row: row + 1, column: column + 1), result)
        }

        expect(deletePieceBy: 1, atRow: 0, andAtColumn: 0, inBoard: Board(withGrid: [[1,2,1]])!, shouldFail: nil)
        expect(deletePieceBy: 1, atRow: 0, andAtColumn: -1, inBoard: Board(withGrid: [[1,2,1]])!, shouldFail: .OutOfBounds)
        expect(deletePieceBy: 1, atRow: 0, andAtColumn: 2, inBoard: Board(withGrid: [[nil,nil,nil]])!, shouldFail: .ColumnEmpty)
    }

    func testIsFull() throws {
        func expect(board: Board, isFull valid: Bool) {
            XCTAssertEqual(valid, board.isFull())
        }

        expect(board: Board(withGrid: [[1,2,1], [1,2,1], [1,2,1]])!, isFull: true)
        expect(board: Board(withGrid: [[1,2,1], [1,2,1], [1,2,nil]])!, isFull: false)
    }

    func testIsColumnFull() throws {
        func expect(board: Board, column: Int, isFull valid: Bool) {
            XCTAssertEqual(valid, board.isColumnFull(at: column))
        }

        expect(board: Board(withGrid: [[1,2,1], [1,2,1], [1,2,1]])!, column: 0, isFull: true)
        expect(board: Board(withGrid: [[1,2,1], [nil,2,nil], [1,2,1]])!, column: 1, isFull: true)
        expect(board: Board(withGrid: [[1,2,1], [1,2,nil], [1,2,1]])!, column: 2, isFull: false)
    }

    func testIsRowFull() throws {
        func expect(board: Board, row: Int, isFull valid: Bool) {
            XCTAssertEqual(valid, board.isRowFull(at: row))
        }

        expect(board: Board(withGrid: [[1,2,1], [1,2,1], [1,2,1]])!, row: 0, isFull: true)
        expect(board: Board(withGrid: [[1,2,1], [nil,nil,nil], [1,2,1]])!, row: 2, isFull: true)
        expect(board: Board(withGrid: [[1,2,1], [1,2,1], [1,nil,1]])!, row: 2, isFull: false)
    }

    func testEqual() throws {
        func expect(board1: Board, isEqualTo board2: Board, valid: Bool) {
            XCTAssertEqual(valid, board1 == board2)
        }

        expect(board1: Board(withGrid: [[1,2,1], [1,2,1], [1,2,1]])!, isEqualTo: Board(withGrid: [[1,2,1], [1,2,1], [1,2,1]])!, valid: true)
        expect(board1: Board(withGrid: [[1,2,1], [1,2,1], [1,2,1]])!, isEqualTo: Board(withGrid: [[1,2,1], [1,2,1]])!, valid: false)
        expect(board1: Board(withGrid: [[1,2,1], [1,2,1], [1,2,1]])!, isEqualTo: Board(withGrid: [[1,2], [1,2], [1,2]])!, valid: false)
        expect(board1: Board(withGrid: [[1,2,1], [1,2,1], [1,2,1]])!, isEqualTo: Board(withGrid: [[1,2,1], [1,2,1], [1,2,2]])!, valid: false)
    }
}
