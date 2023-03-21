//
//  ARKitVC.swift
//  DemoHub
//
//  Created by zhouluyao on 3/21/23.
//

import SwiftUI

class ARKitVC: UIViewController {
    var currentPropModel = CurrentPropModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(rootView: ARFacePropsView(currentPropModel: currentPropModel))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        hostingController.didMove(toParent: self)
    }
}

