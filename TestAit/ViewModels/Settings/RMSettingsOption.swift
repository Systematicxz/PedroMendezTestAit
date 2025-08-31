//
//  RMSettingsOption.swift
//  TestAit
//
//  Created by PEDRO MENDEZ on 31/08/25.
//


import UIKit

enum RMSettingsOption: CaseIterable {
    case rateApp
    case contactUS
    case terms
    case privacy
    case APIReferennce
    case viewSeries
    case viewCode
    
    var targetUrl: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUS:
            return URL(string: "https://www.linkedin.com/in/pedro-mendez-tostado/")
        case .terms:
            return URL(string: "https://www.google.com")
        case .privacy:
            return URL(string: "https://www.google.com")
        case .APIReferennce:
            return URL(string: "https://rickandmortyapi.com")
        case .viewSeries:
            return URL(string: "https://www.google.com")
        case .viewCode:
            return URL(string: "https://www.google.com")
        }
    }
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUS:
            return "Contact Us"
        case .terms:
            return "Terms of Service"
        case .privacy:
            return "Privacy Policy"
        case .APIReferennce:
            return "API Reference"
        case .viewSeries:
            return "View Video Channel Series"
        case .viewCode:
            return "View App Code Source"
        }
    }
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUS:
            return .systemGray
        case .terms:
            return .systemPurple
        case .privacy:
            return .systemMint
        case .APIReferennce:
            return .systemTeal
        case .viewSeries:
            return .systemPink
        case .viewCode:
            return .systemIndigo
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUS:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .APIReferennce:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
}

