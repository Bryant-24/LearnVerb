//
//  Verb.swift
//  MVCLesson
//
//  Created by Ruslan Galiev on 4/21/23.
//

import Foundation

struct Verb {
    let infinitive: String
    let pastSimple: String
    let participle: String
    var translation: String {
        NSLocalizedString(self.infinitive, comment: "")
    }
}
