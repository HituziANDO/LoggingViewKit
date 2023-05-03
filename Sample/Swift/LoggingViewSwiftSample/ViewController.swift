//
//  ViewController.swift
//  LoggingViewSwiftSample
//
//  Created by Masaki Ando on 2018/12/15.
//  Copyright © 2018年 Hituzi Ando. All rights reserved.
//

import LoggingViewKit
import UIKit

class ViewController: UIViewController, LGVLoggingViewServiceDelegate {
    @IBOutlet var stepperLabel: LGVLabel!
    @IBOutlet var sampleView: LGVView!

    private lazy var testButton: LGVButton = {
        let button = LGVButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        button.loggingName = "TestButton"
        button.isLogging = true
        button.touchableExtension = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        button.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
        button.setTitle("Test", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(testButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var getLogButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 44, width: 100, height: 40))
        button.backgroundColor = UIColor.green.withAlphaComponent(0.7)
        button.setTitle("Get Log", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(getLogButtonPressed), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        sampleView.addSubview(testButton)
        sampleView.addSubview(getLogButton)

        LGVLoggingViewService.shared().delegate = self

        // Deletes all logs.
//        LGVLoggingViewService.shared().deleteAllLogs()

        // Records viewDidLoad as the custom event.
        let attr = LGVLoggingAttribute(name: "ViewController")
        LGVLoggingViewService.shared().customEvent("viewDidLoad", attribute: attr)

        #if DEBUG
        // Dumps hierarchy of the root view.
        LGVViewHierarchy.dump(view)
        #endif
    }

    // MARK: - IBAction

    @IBAction func stepperChanged(_ sender: Any) {
        if let stepper = sender as? LGVStepper {
            stepperLabel.text = String(format: "%.1lf", stepper.value)
        }
    }

    @objc func testButtonPressed(_ sender: LGVButton) {
        if let loggingName = sender.loggingName {
            print("\(loggingName) Pressed")
        }
    }

    @objc func getLogButtonPressed(_ sender: Any) {
        // Records a click event.
        let attr = LGVLoggingAttribute(view: sender,
                                       name: "GetLogButton",
                                       loggingEnabled: true)
        attr.info = ["more-info": "test"]
        LGVLoggingViewService.shared().click(attr)

        print("All Logs: \(LGVLoggingViewService.shared().allLogs())")
    }

    // MARK: - LGVLoggingViewServiceDelegate

    func loggingViewService(_ service: LGVLoggingViewService,
                            willSave log: LGVLog,
                            attribute: LGVLoggingAttribute) {}

    func loggingViewService(_ service: LGVLoggingViewService,
                            didSave log: LGVLog,
                            attribute: LGVLoggingAttribute,
                            error: LGVError?) {}
}
