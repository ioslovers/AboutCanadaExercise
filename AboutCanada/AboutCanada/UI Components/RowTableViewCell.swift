//
//  RowTableViewCell.swift
//  AboutCanada
//
//  Created by Ashish Tripathi on 16/02/20.
//  Copyright © 2020 Ashish Tripathi. All rights reserved.
//

import UIKit

class RowTableViewCell: UITableViewCell {
    // MARK: - Public Variables

    public var id = 0
    public var row: Row? {
        didSet {
            titleLabel.text = row?.title
            descriptionLabel.text = row?.description
            activityIndicator.startAnimating()
            rowImage.loadThumbnail(urlSting: row?.imageHref ?? ConstantsString.noImage) { _ in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
            titleLabel.accessibilityIdentifier = AccessibilityKey.titleIdentifier.accessibilityIdentifier(with: id)
            descriptionLabel.accessibilityIdentifier = AccessibilityKey.descriptionIdentifier.accessibilityIdentifier(with: id)
            rowImage.accessibilityIdentifier = AccessibilityKey.imageViewIdentifier.accessibilityIdentifier(with: id)
            accessibilityIdentifier = AccessibilityKey.cellIdentifier.accessibilityIdentifier(with: id)
        }
    }

    // MARK: - Private Variables

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.darkModeSupportedColor()
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.textAlignment = .left
        return lbl
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            activityIndicator.style = .gray
        }
        activityIndicator.color = UIColor.darkModeSupportedColor()
        return activityIndicator
    }()

    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.darkModeSupportedColor()
        lbl.font = UIFont.systemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    private let rowImage: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: ConstantsString.noImage))
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 12
        imgView.layer.borderWidth = 1.0
        imgView.layer.borderColor = UIColor.black.cgColor
        return imgView
    }()

    // MARK: - initilization

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(rowImage)
        addSubview(activityIndicator)

        /// Setting up constraints for the rowImage
        setupRowImage()

        /// Setting up constraints for the activityIndicator
        setupActivityIndicator()

        /// Setting up constraints for the titleLabel
        setupTitleLabel()

        /// Setting up constraints for the descriptionLabel
        setupDescriptionLabel()
    }

    // MARK: - Private Functions

    private func setupRowImage() {
        rowImage.addAnchor(top: nil,
                           left: leftAnchor,
                           bottom: nil,
                           right: titleLabel.leftAnchor,
                           paddingTop: 5,
                           paddingLeft: 5,
                           paddingBottom: 5,
                           paddingRight: 10,
                           width: 90,
                           height: 90,
                           enableInsets: false)
        let imageCenterY = NSLayoutConstraint(item: self,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: rowImage,
                                              attribute: .centerY,
                                              multiplier: 1.0,
                                              constant: 0.0)
        imageCenterY.isActive = true
    }

    private func setupActivityIndicator() {
        activityIndicator.addAnchor(top: rowImage.topAnchor,
                                    left: rowImage.leftAnchor,
                                    bottom: nil,
                                    right: nil,
                                    paddingTop: 20,
                                    paddingLeft: 40,
                                    paddingBottom: 0,
                                    paddingRight: 0,
                                    width: 10,
                                    height: 10,
                                    enableInsets: false)
    }

    private func setupTitleLabel() {
        titleLabel.addAnchor(top: topAnchor,
                             left: rowImage.rightAnchor,
                             bottom: descriptionLabel.topAnchor,
                             right: rightAnchor,
                             paddingTop: 10,
                             paddingLeft: 10,
                             paddingBottom: 0,
                             paddingRight: 20,
                             width: 0,
                             height: 0,
                             enableInsets: false)
    }

    private func setupDescriptionLabel() {
        descriptionLabel.addAnchor(top: titleLabel.bottomAnchor,
                                   left: rowImage.rightAnchor,
                                   bottom: bottomAnchor,
                                   right: rightAnchor,
                                   paddingTop: 0,
                                   paddingLeft: 10,
                                   paddingBottom: 10,
                                   paddingRight: 20,
                                   width: 0,
                                   height: 0,
                                   enableInsets: false)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
