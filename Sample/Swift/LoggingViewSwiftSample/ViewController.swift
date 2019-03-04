//
//  ViewController.swift
//  LoggingViewSwiftSample
//
//  Created by Masaki Ando on 2018/12/15.
//  Copyright © 2018年 Hituzi Ando. All rights reserved.
//

import UIKit
import LoggingViewKit

class ViewController: UIViewController, LGVLoggingViewServiceDelegate {


    @IBOutlet weak var stepperLabel: LGVLabel!
    @IBOutlet weak var sampleView:   LGVView!
    var testButton: LGVButton!

    override func loadView() {
        super.loadView()

        testButton = LGVButton(frame: CGRect(x: 0, y: 0, width: 100.0, height: 40.0))
        testButton.loggingName = "TestButton"
        testButton.isLogging = true
        testButton.touchableExtension = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        testButton.backgroundColor = UIColor.blue.withAlphaComponent(0.7)
        testButton.setTitle("Test", for: .normal)
        testButton.setTitleColor(UIColor.white, for: .normal)
        testButton.addTarget(self, action: #selector(testButtonPressed), for: .touchUpInside)
        self.sampleView.addSubview(testButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        LGVLoggingViewService.shared().delegate = self

        // Deletes all logs.
//        LGVLoggingViewService.shared().deleteAllLogs()
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

            print("All Logs: \(LGVLoggingViewService.shared().allLogs())")
        }
    }

    // MARK: - LGVLoggingViewServiceDelegate

    func loggingViewService(_ service: LGVLoggingViewService,
                            willSave log: LGVLog,
                            of view: LGVLogging,
                            with event: UIEvent?) {

    }

    func loggingViewService(_ service: LGVLoggingViewService,
                            didSave log: LGVLog,
                            of view: LGVLogging,
                            with event: UIEvent?,
                            error: LGVError?) {

    }
}
