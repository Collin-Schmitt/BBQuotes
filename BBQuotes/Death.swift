//
//  Death.swift
//  BBQuotes
//
//  Created by Collin Schmitt on 1/9/25.
//

import Foundation

struct Death: Decodable {
    let character: String
    let image: URL
    let details: String
    let lastWords: String
}
