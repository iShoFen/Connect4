//
//  BoardResult.swift
//  
//
//  Created by Samuel on 18/01/2023.
//

import Foundation

public enum FailedReason {
    case outOfBounds
    case columnFull
    case columnEmpty
}

public enum BoardResult: Equatable {
    case unknown
    case added(id: Int, row: Int, column: Int)
    case deleted(row: Int, column: Int)
    case failed(reason: FailedReason)
}
