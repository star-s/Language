//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.05.2021.
//

import Foundation

public extension Locale {
    
    func updating(language: String) -> Locale {
        var cmps = Locale.components(fromIdentifier: identifier)
        cmps[CFLocaleKey.languageCode.rawValue as String] = Locale.canonicalLanguageIdentifier(from: language)
        return Locale(identifier: Locale.identifier(fromComponents: cmps))
    }
}
