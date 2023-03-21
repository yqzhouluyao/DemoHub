//
//  PropChooser.swift
//  DemoHub
//
//  Created by zhouluyao on 3/21/23.
//

import SwiftUI

enum Prop: CaseIterable, Equatable {
  case fancyHat
  case glasses
  case mustache
  case eyeball
  case robot
  
  private func nextCase(_ cases: [Self]) -> Self? {
    if self == cases.last {
      return cases.first
    } else {
      return cases
        .drop(while: ) { $0 != self }
        .dropFirst()
        .first
    }
  }
  
  func next() -> Self {
    nextCase(Self.allCases) ?? .eyeball
  }
  
  func previous() -> Self {
    nextCase(Self.allCases.reversed()) ?? .fancyHat
  }
}


struct PropChooser: View {
  
  @Binding var currentProp: Prop
  
  func takeSnapshot() {
    arView.snapshot(saveToHDR: false) { (image) in
      let compressedImage = UIImage(data: (image?.pngData())!)
      UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
    }
  }
  
  var body: some View {
    HStack {
      Button(action: {
        currentProp = currentProp.previous()
      }) {
        Image(systemName: "arrowtriangle.left.fill")
          .resizable()
          .frame(width: 44, height: 44)
      }
      
      Spacer()
      
      Button(action: {
        takeSnapshot()
      }) {
        Circle().stroke(lineWidth: 12.0)
      }
      
      Spacer()
      
      Button(action: {
        currentProp = currentProp.next()
      }) {
        Image(systemName: "arrowtriangle.right.fill")
          .resizable()
          .frame(width: 44, height: 44)
      }
    }
    .frame(height: 100)
    .foregroundColor(.primary)
    .padding(.horizontal)
  }
}

struct PropChooser_Previews: PreviewProvider {
    static var previews: some View {
      PropChooser(currentProp: .constant(.eyeball))
    }
}
