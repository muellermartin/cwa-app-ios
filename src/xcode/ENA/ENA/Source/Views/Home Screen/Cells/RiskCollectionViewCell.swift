//
//  RiskCollectionViewCell.swift
//  ENA
//
//  Created by Tikhonov, Aleksandr on 03.05.20.
//  Copyright © 2020 SAP SE. All rights reserved.
//

import UIKit

protocol RiskCollectionViewCellDelegate: AnyObject {
    func contactButtonTapped(cell: RiskCollectionViewCell)
}

/// A cell that visualizes the current risk and allows the user to calculate he/his current risk.
final class RiskCollectionViewCell: UICollectionViewCell {
    // MARK: Helpers
    private static let dateFormatter: DateFormatter = {
          let dateFormatter = DateFormatter()
          dateFormatter.dateStyle = .medium
          return dateFormatter
    }()
    
    // MARK: Model related Types
    struct Risk {
        let level: RiskLevel
        let date: Date?
    }
    
    struct Model {
        let risk: Risk
    }
    
    class ViewModel {
        let title: String
        let titleColor: UIColor
        let chevronTintColor: UIColor
        let iconImage: UIImage?
        let chevronImage: UIImage?
        let body: String
        let date: String?
        
        init(title: String, titleColor: UIColor, chevronTintColor: UIColor, iconImage: UIImage?, chevronImage: UIImage?, body: String, date: String?) {
            self.title = title
            self.titleColor = titleColor
            self.chevronTintColor = chevronTintColor
            self.iconImage = iconImage
            self.chevronImage = chevronImage
            self.body = body
            self.date = date
        }
    }
    
    // MARK: Properties
    weak var delegate: RiskCollectionViewCellDelegate?

    // MARK: Outlets
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var chevronImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contactButton: UIButton!
    @IBOutlet var riskIndicatorContainer: UIView!

    // MARK: Nib Loading
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
    }
    
    // MARK: Actions
    @IBAction func contactButtonTapped(_ sender: UIButton) {
        delegate?.contactButtonTapped(cell: self)
    }
    
    // MARK: Configuring the UI
    func configure(with viewModel: ViewModel, delegate: RiskCollectionViewCellDelegate) {
        self.delegate = delegate
        
        //riskIndicatorContainer?.backgroundColor = level.backgroundColor
        titleLabel.text = viewModel.title
        titleLabel.textColor = viewModel.titleColor
        chevronImageView.tintColor = viewModel.chevronTintColor
        iconImageView.image = viewModel.iconImage //UIImage(named: "onboarding_ipad")
        chevronImageView.image = viewModel.chevronImage // UIImage(systemName: "chevron.right")
        bodyLabel.text = viewModel.body
        dateLabel.text = viewModel.date
        dateLabel.isHidden = viewModel.date == nil
        contactButton.setTitle(AppStrings.Home.riskCardButton, for: .normal)
    }
}


private extension RiskCollectionViewCell.Risk {
    var localizedDateLabelText: String? {
        guard let formattedDate = formattedDate else {
            return nil
        }
        let localizedFormat = AppStrings.Home.riskCardDate.localized()
        return String(format: localizedFormat, formattedDate)
    }
    
    var formattedDate: String? {
        if let date = date {
            return RiskCollectionViewCell.dateFormatter.string(from: date)
        }
        return nil
    }
}
