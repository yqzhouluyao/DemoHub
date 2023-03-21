//
//  ARFacePropsView.swift
//  DemoHub
//
//  Created by zhouluyao on 3/21/23.
//

import SwiftUI

struct ARFacePropsView: View {
    @ObservedObject var currentPropModel: CurrentPropModel

    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(currentProp: $currentPropModel.currentProp).edgesIgnoringSafeArea(.all)
            PropChooser(currentProp: $currentPropModel.currentProp)
        }
    }
}

