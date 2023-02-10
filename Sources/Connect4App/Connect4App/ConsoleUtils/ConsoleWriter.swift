//
// Created by Samuel on 10/02/2023.
//

import Foundation
import Connect4Lib

public struct ConsoleWriter {
    private let gridMapper: [Int?:String] = [nil:"-", 1:"X", 2:"O"]

    public func write(_ string: String) {
        print(string)
    }

    public func write(_ int: Int) {
        print(int)
    }

    public func write(_ bool: Bool) {
        print(bool)
    }

    public func writeGrid(_ grid: [[Int?]]) {
        var string = String()
        for row in grid.reversed() {
            string.append("|")
            for cell in row {
                string.append("\(gridMapper[cell] ?? "-")|")
            }
            string.append("\n")
        }

        print(string)
    }

    private func writeTupleArray(_ tuple: [(Int, Int)]) {
        var string = String()
        for (row, column) in tuple {
            string.append("(\(row + 1), \(column + 1))")
        }

        print(string)
    }

    private func writeInitError(_ error: InitialisationError) {
        switch error {
        case .TooFewRows:
            print("Error while initialising the grid: too few rows")
        case .TooFewColumns:
            print("Error while initialising the grid: too few columns")
        case .TooManyRows:
            print("Error while initialising the grid: too many rows")
        case .TooManyColumns:
            print("Error while initialising the grid: too many columns")
        case .BoardFull:
            print("Error while initialising the grid: board full")
        case .NotEnoughPlayers(let expected, let actual):
            print("Error while initialising the grid: not enough players (expected: \(expected), actual: \(actual))")
        default:
            print("Error while initialising the grid: unknown error")
        }
    }

    private func writePlayingError(_ error: PlayingError) {
        switch error {
        case .OutOfBounds:
            print("Error while playing: out of bounds")
        case .ColumnFull:
            print("Error while playing: column full")
        case .ColumnEmpty:
            print("Error while playing: column empty")
        default:
            print("Error while playing: unknown error")
        }
    }

    public func writeGameResponse(_ response: GameResponse) {
        switch response {
        case .FailedInit(let reason):
            writeInitError(reason)
        case .FailedPlays(let reason):
            writePlayingError(reason)
        case .Added(let id, let row, let column):
            print("Player \(id) added a token at (\(row + 1), \(column + 1))")
        case .Show(let board):
            writeGrid(board)
        case .PlayerTurn(let id):
            print("Player \(id)'s turn")
        case .NoWinner:
            print("No winner, the board is full")
        case .Win(let id, let positions):
            print("Player \(id) won at \(positions)")
        default:
            print("Unknown response")
        }
    }
}
