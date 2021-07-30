//
//  File.swift
//  
//
//  Created by Sergey Starukhin on 30.07.2021.
//

import Foundation

public protocol LanguageProtocol {
	var languageCode: String { get }
	var localizedDescription: String { get }

	static var defaultLanguage: Self { get }
	static var current: Self { get }
}

public extension LanguageProtocol {
	var locale: Locale {
		Locale.current.updating(language: languageCode)
	}
	
	var localizedDescription: String {
		Self.current.locale.localizedString(forLanguageCode: languageCode)?.capitalized ?? ""
	}
}

public extension LanguageProtocol where Self: RawRepresentable, RawValue == String {
	var languageCode: String { rawValue }
}

public extension LanguageProtocol where Self: CaseIterable {
	static var defaultLanguage: Self {
		allCases.first!
	}
}

public extension LanguageProtocol where Self: RawRepresentable, RawValue == String {
	static var current: Self {
		get {
			if let lang = UserDefaults.standard.string(forKey: key).flatMap(Self.init) {
				return lang
			}
			return Locale.current.languageCode.flatMap(Self.init) ?? .defaultLanguage
		}
		set {
			UserDefaults.standard.set(newValue.rawValue, forKey: key)
		}
	}
	
	static func resetToSystemLocale() {
		UserDefaults.standard.removeObject(forKey: key)
	}
}

fileprivate var key = "appLang"
