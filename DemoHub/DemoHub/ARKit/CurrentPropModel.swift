//
//  CurrentPropModel.swift
//  DemoHub
//
//  Created by zhouluyao on 3/21/23.
//

import Combine
import SwiftUI

class CurrentPropModel: ObservableObject {
    @Published var currentProp: Prop = .robot
}
