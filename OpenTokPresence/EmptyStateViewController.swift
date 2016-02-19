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

        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(22.0)
        titleLabel.text = state.title
        stackView.addArrangedSubview(titleLabel)

        let messageLabel = UILabel()
        messageLabel.font = UIFont.systemFontOfSize(14.0)
        messageLabel.text = state.message
        messageLabel.textColor = UIColor.darkGrayColor()
        stackView.addArrangedSubview(messageLabel)

        self.view = stackView
    }
}
