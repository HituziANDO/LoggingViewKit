//
//  LVKLogViewController.swift
//  LoggingViewKit
//
//  Created by Masaki Ando on 2024/05/26.
//  Copyright © 2024 Hituzi Ando. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit

/// The log viewer.
@objc(LVKLogViewController)
public class LVKLogViewController: UIViewController {
    private lazy var titleView: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .systemBackground
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.backgroundColor = .systemBackground
        textView.textColor = .label
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    private lazy var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("CLEAR", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(clearLogs), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("CLOSE", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.addTarget(self, action: #selector(hide), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let sourceFile: LGVFileDestination

    init(sourceFile: LGVFileDestination) {
        self.sourceFile = sourceFile

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        view.addSubview(titleView)
        view.addSubview(textView)
        view.addSubview(clearButton)
        view.addSubview(closeButton)

        NSLayoutConstraint
            .activate([titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                      constant: 16),
                       titleView.leadingAnchor
                           .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                       titleView.trailingAnchor
                           .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                       titleView.heightAnchor.constraint(equalToConstant: 32),

                       textView.topAnchor.constraint(equalTo: titleView.bottomAnchor,
                                                     constant: 16),
                       textView.leadingAnchor
                           .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                       textView.trailingAnchor
                           .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                       textView.bottomAnchor
                           .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

                       closeButton.rightAnchor
                           .constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                       closeButton.bottomAnchor
                           .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                       constant: -16),
                       closeButton.widthAnchor.constraint(equalToConstant: 80),

                       clearButton.rightAnchor
                           .constraint(equalTo: closeButton.rightAnchor),
                       clearButton.bottomAnchor
                           .constraint(equalTo: closeButton.topAnchor,
                                       constant: -8),
                       clearButton.widthAnchor
                           .constraint(equalTo: closeButton.widthAnchor)])

        let filePath = sourceFile.filePath

        let fileName = URL(fileURLWithPath: filePath).lastPathComponent
        titleView.text = fileName

        let text = try? String(contentsOfFile: filePath, encoding: .utf8)
        textView.text = text
    }

    @objc private func clearLogs() {
        try? sourceFile.deleteAllLogs()

        textView.text = ""
    }

    @objc private func hide() {
        dismiss(animated: true, completion: nil)
    }
}

@objc
public extension LVKLogViewController {
    /// Shows the log view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller from which to present the log view controller.
    ///   - sourceFile: The source file of the log.
    @objc(showFromViewController:withSourceFile:)
    static func show(from viewController: UIViewController, sourceFile: LGVFileDestination) {
        let logViewController = LVKLogViewController(sourceFile: sourceFile)
        viewController.present(logViewController, animated: true, completion: nil)
    }
}

#endif
