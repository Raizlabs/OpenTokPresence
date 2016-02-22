//
//  EmptyStateViewController.swift
//  OpenTokPresence
//
//  Created by Brian King on 2/16/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit

class EmptyStateViewController: UIViewController {
    let state: EmptyState
    init(state: EmptyState) {
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if case .Spinner = state.style {
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            spinner.startAnimating()
            spinner.hidesWhenStopped = false
            stackView.addArrangedSubview(spinner)
        }

        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(22.0)
        titleLabel.text = state.title
        titleLabel.textAlignment = .Center
        stackView.addArrangedSubview(titleLabel)

        let messageLabel = UILabel()
        messageLabel.font = UIFont.systemFontOfSize(14.0)
        messageLabel.text = state.message
        messageLabel.textColor = UIColor.darkGrayColor()
        messageLabel.textAlignment = .Center
        stackView.addArrangedSubview(messageLabel)

        view = UIView()
        view.addSubview(stackView)
        NSLayoutConstraint.activateConstraints([
            view.centerXAnchor.constraintEqualToAnchor(stackView.centerXAnchor),
            view.widthAnchor.constraintEqualToAnchor(stackView.widthAnchor),
            view.centerYAnchor.constraintEqualToAnchor(stackView.centerYAnchor)
        ])
    }
}
