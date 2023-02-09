//
//  BoardResult.swift
//  
//
//  Created by Samuel on 18/01/2023.
//

import Foundation

/// The reason why a board failed to delete a token.
public enum FailedReason {
    /// Unknown reason.
    case Unknown
    /// The column is out of bounds.
    case OutOfBounds
    /// The column is full.
    case ColumnFull
    /// The column is empty.
    case ColumnEmpty
}

/// The result of a board.
public enum BoardResult: Equatable {
    /// Unknown result.
    case Unknown
    /// The token was added.
    case Added(id: Int, row: Int, column: Int)
    /// The token was deleted.
    case Deleted(id: Int, row: Int, column: Int)
    /// The board failed to add or delete a token.
    case Failed(reason: FailedReason)
}
