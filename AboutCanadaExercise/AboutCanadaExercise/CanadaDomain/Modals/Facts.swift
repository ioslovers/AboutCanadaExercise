//
//  Facts.swift
//  AboutCanadaExercise
//
//  Created by Ashish Tripathi on 15/02/20.
//  Copyright © 2020 Ashish Tripathi. All rights reserved.
//

import Foundation

public struct Facts: Codable {
    public let title: String?
    public let rows: [Row]?
}

public struct Row: Codable {
    public let title: String?
    public let rowDescription: String?
    public let imageHref: String?
    enum CodingKeys: String, CodingKey {
        case title
        case rowDescription = "description"
        case imageHref
    }
}
