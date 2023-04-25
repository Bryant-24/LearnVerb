//
//  IrregularVerbs.swift
//  MVCLesson
//
//  Created by Ruslan Galiev on 4/21/23.
//

import Foundation

final class IrregularVerbs {

    //Singleton
    static var shared = IrregularVerbs()
    private init() {
        configureVerbs()
    }
    
    // MARK: Properties
    var selectedVerbs: [Verb] = []
    private(set) var verbs: [Verb] = []
    
    // MARK: - Methods
    private func configureVerbs() {
        verbs = [
            Verb.init(infinitive: "awake", pastSimple: "awoke", participle: "awoken"),
            Verb.init(infinitive: "beat", pastSimple: "beat", participle: "beaten"),
            Verb.init(infinitive: "become", pastSimple: "became", participle: "become"),
            Verb.init(infinitive: "begin", pastSimple: "began", participle: "begun")
        ]
    }
}
