//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 01.05.2021.
//

import Foundation

public extension Bundle {
    
    func bundle(for locale: Locale, tableName: String) -> Bundle {
        
        var languages = { locale -> [String] in
            if localizations.contains(locale.identifier) {
                if let language = locale.languageCode, localizations.contains(language) {
                    return [locale.identifier, language]
                } else {
                    return [locale.identifier]
                }
            } else if let language = locale.languageCode, localizations.contains(language) {
                return [language]
            } else {
                return []
            }
        }(locale)
        
        // If there's no languages, use development language as backstop
        if languages.isEmpty {
            if let developmentLocalization = developmentLocalization {
                languages = [developmentLocalization]
            }
        } else {
            // Insert Base as second item (between locale identifier and languageCode)
            languages.insert("Base", at: 1)

            // Add development language as backstop
            if let developmentLocalization = developmentLocalization {
                languages.append(developmentLocalization)
            }
        }

        for language in languages {
            guard let lproj = url(forResource: language, withExtension: "lproj"), let lbundle = Bundle(url: lproj) else {
                continue
            }
            let strings = lbundle.url(forResource: tableName, withExtension: "strings")
            let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

            if strings != nil || stringsdict != nil {
                return lbundle
            }
        }
        return self
    }
}
