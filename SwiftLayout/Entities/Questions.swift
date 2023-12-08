//
//  Questions.swift
//  SwiftLayout
//
//  Created by Shuai Zhang on 12/5/23.
//

import Foundation

struct DataEntity: Codable {
    var questions: [Question]
}

struct Question: Codable {
    var text: String
    var type: String
}
