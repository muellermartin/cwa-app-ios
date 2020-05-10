//
//  HomeRiskCellConfigurator.swift
//  ENA
//
//  Created by Tikhonov, Aleksandr on 04.05.20.
//  Copyright © 2020 SAP SE. All rights reserved.
//

import UIKit
import ExposureNotification

final class HomeRiskCellConfigurator {
    
    // MARK: Properties
    var contactAction: (() -> Void)?
    
    private var date: Date?
    private var riskLevel: RiskLevel
    
    // MARK: Creating a Home Risk Cell Configurator
    init(detectionSummary: ENExposureDetectionSummary, date: Date?) {
        self.riskLevel = RiskLevel.risk(riskScore: detectionSummary.maximumRiskScore)
        self.date = date
    }
    
    private static let dateFormatter: DateFormatter = {
          let dateFormatter = DateFormatter()
          dateFormatter.dateStyle = .medium
          return dateFormatter
    }()
    
}

extension HomeRiskCellConfigurator: CollectionViewCellConfigurator {
    func configure(cell: RiskCollectionViewCell) {

        let titleKey: String = self.titleKey(for: riskLevel)
        let titleColor: UIColor = self.titleColor(for: riskLevel)
        
        let bodyKey: String = self.bodyKey(for: riskLevel)
        var dateString: String?
        if let date = date {
            let string = HomeRiskCellConfigurator.dateFormatter.string(from: date)
            let dateKey = AppStrings.Home.riskCardDate
            dateString = String(format: dateKey, string)
        }
        
        
        let chevronTintColor: UIColor = self.chevronTintColor(for: riskLevel)
        let iconImage: UIImage? = UIImage(named: "onboarding_ipad")
        let chevronImage: UIImage? = UIImage(systemName: "chevron.right")

        
        let viewModel = RiskCollectionViewCell.ViewModel(
            title: titleKey,
            titleColor: titleColor,
            chevronTintColor: chevronTintColor,
            iconImage: iconImage,
            chevronImage: chevronImage,
            body: bodyKey,
            date: dateString
        )
        
        
        // The delegate will be called back when the cell's primary action is triggered
        cell.configure(with: viewModel, delegate: self)
    }
}

extension HomeRiskCellConfigurator: RiskCollectionViewCellDelegate {
    func contactButtonTapped(cell: RiskCollectionViewCell) {
        contactAction?()
    }
}

extension HomeRiskCellConfigurator {
    func titleKey(for riskLevel: RiskLevel) -> String {
        let key: String
        switch riskLevel {
        case .unknown:
            key = "Risk_Unknown_Button_Title"
        case .low:
            key = "Risk_Low_Button_Title"
        case .high:
            key = "Risk_High_Button_Title"
        case .moderate:
            key = "Risk_Moderate_Button_Title"
        }
        return key
    }

    func bodyKey(for riskLevel: RiskLevel) -> String {
        let key: String
        switch riskLevel {
        case .unknown:
            key = AppStrings.RiskView.unknownRiskDetail
        case .low:
            key = AppStrings.RiskView.lowRiskDetail
        case .high:
            key = AppStrings.RiskView.highRiskDetail
        case .moderate:
            key = AppStrings.RiskView.moderateRiskDetail
        }
        return key
    }

    
    func containerColor(for riskLevel: RiskLevel) -> UIColor {
        switch riskLevel {
        case .unknown:
            return .clear
        case .low:
            return .green
        case .high:
            return .red
        case .moderate:
            return .orange
        }
    }
    
    
    func chevronTintColor(for riskLevel: RiskLevel) -> UIColor {
        riskLevel == .unknown ? .systemBlue : titleColor(for: riskLevel)
    }
    
    func titleColor(for riskLevel: RiskLevel) -> UIColor {
        switch riskLevel {
        case .unknown:
            // swiftlint:disable:next discouraged_object_literal
            return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .low:
            // swiftlint:disable:next discouraged_object_literal
            return #colorLiteral(red: 0.9090440273, green: 1, blue: 0.8056635857, alpha: 1)
        case .high:
            // swiftlint:disable:next discouraged_object_literal
            return #colorLiteral(red: 1, green: 0.8961167932, blue: 0.8636761308, alpha: 1)
        case .moderate:
            // swiftlint:disable:next discouraged_object_literal
            return #colorLiteral(red: 1, green: 0.9306703806, blue: 0.8244562745, alpha: 1)
        }
    }
}
