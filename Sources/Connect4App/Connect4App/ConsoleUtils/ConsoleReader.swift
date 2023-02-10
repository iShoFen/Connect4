//
// Created by Samuel on 10/02/2023.
//

import Foundation

public struct ConsoleReader {
    public func stringReader() -> String {
        readLine() ?? ""
    }

    public func intReader() -> Int? {
        Int(stringReader())
    }
}
