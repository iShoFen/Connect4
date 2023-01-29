//
// Created by etudiant on 25/01/2023.
//

import Foundation

public enum RuleResult {
    case unknown
    case invalid
    case valid
    case won(id: Int, at: [[Int]])
}
