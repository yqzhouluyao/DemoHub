

import ARKit
import SwiftUI
import RealityKit

var arView: ARView!
/*
 1、设置：初始化 ARViewContainer 并创建一个 ARView 实例。将 AR 会话委托设置为 ADelegateHandler 的实例。
 2、使用 TrueDepth 相机跟踪面部特征。使用配置和选项运行 AR 会话以重置跟踪并删除现有锚点。
 3、检测面部和面部特征：ARKit 自动检测用户的面部并创建 ARFaceAnchor 对象。这些对象包含有关用户面部几何形状的信息，包括眼睛、鼻子和嘴巴等面部特征的位置和方向。
 4、更新场景：在session(_:didUpdate:)委托函数中，在更新的anchors列表中找到ARFaceAnchor。使用来自 ARFaceAnchor 的混合形状值和其他面部信息将动画应用于场景，例如让眼球注视特定点或为机器人的面部设置动画。
 5、渲染和显示：ARView 使用应用的道具和动画实时渲染更新的场景。用户可以通过屏幕上添加的道具和动画看到自己的脸。
 6、响应用户输入：应用程序通过更新 ARView 并相应地添加或删除锚点来响应用户输入，例如更改当前道具。
 实施过程包括设置和配置用于面部跟踪的 AR 会话、检测面部特征、根据面部信息更新 AR 场景、渲染场景以及对用户输入做出反应。
 */

//根据用户的面部表情使用各种面部道具和动画显示和更新 AR 场景。
struct ARViewContainer: UIViewRepresentable {

  @Binding var currentProp: Prop
  //创建一个 ARView 实例并将会话委托设置为 context.coordinator。此函数返回将在 SwiftUI 视图层次结构中使用的 ARView 实例
  func makeUIView(context: Context) -> ARView {
    arView = ARView(frame: .zero)
    arView.session.delegate = context.coordinator
    return arView
  }
  
    
  func updateUIView(_ uiView: ARView, context: Context) {
      //此函数从场景中删除所有现有锚点
    uiView.scene.anchors.removeAll()
    
      //使用 ARFaceTrackingConfiguration 配置 AR 会话，然后根据当前 currentProp 值添加新锚点
    let arConfiguration = ARFaceTrackingConfiguration()
    uiView.session.run(arConfiguration, options: [.resetTracking, .removeExistingAnchors])
    
    var anchor: RealityKit.HasAnchoring
    switch currentProp {
    case .fancyHat:
      anchor = try! Experience.loadFancyHat()
    case .glasses:
      anchor = try! Experience.loadGlasses()
    case .mustache:
      anchor = try! Experience.loadMustache()
    case .eyeball:
      anchor = try! Experience.loadEyeball()
    case .robot:
      anchor = try! Experience.loadRobot()
    }
    uiView.scene.addAnchor(anchor)
  }
  
    //创建一个 ADelegateHandler 实例。 ARDelegateHandler 是一个自定义类，符合ARSessionDelegate 协议，用于处理AR 会话更新
  func makeCoordinator() -> ARDelegateHandler {
    ARDelegateHandler(self)
  }
  
    //它负责处理 AR 会话更新并根据面部锚点数据应用动画。
  class ARDelegateHandler: NSObject, ARSessionDelegate {
    
    var arViewContainer: ARViewContainer
    
    init(_ control: ARViewContainer) {
      arViewContainer = control
      super.init()
    }
    
      //可让眼球注视特定点
    func eyeballLook(at point: simd_float3) {
        //在场景中找到眼球实体
      guard let eyeball = arView.scene.findEntity(named: "Eyeball")
      else { return }
      //根据face anchor的lookAtPoint让眼球看向特定的点
      eyeball.look(at: point, from: eyeball.position, upVector: SIMD3<Float>(0, 1, -1), relativeTo: eyeball.parent)
    }
    
    func deg2Rad(_ value: Float) -> Float {
      return value * .pi / 180
    }
    //可根据面部锚点提供的混合形状为机器人面部设置动画
    func animateRobot(faceAnchor: ARFaceAnchor) {
        //在场景中找到机器人实体
      guard let robot = arView.scene.anchors.first(where: { $0 is Experience.Robot }) as? Experience.Robot
      else { return }
      //然后从面部锚点获得混合形状。
      let blendShapes = faceAnchor.blendShapes
      guard
        let jawOpen = blendShapes[.jawOpen]?.floatValue,
        let eyeBlinkLeft = blendShapes[.eyeBlinkLeft]?.floatValue,
        let eyeBlinkRight = blendShapes[.eyeBlinkRight]?.floatValue,
        let browInnerUp = blendShapes[.browInnerUp]?.floatValue,
        let browLeft = blendShapes[.browDownLeft]?.floatValue,
        let browRight = blendShapes[.browDownRight]?.floatValue
      else { return }
      
        //基于混合形状，使用 simd_quatf 和 simd_mul 函数更新机器人的面部表情（eyeLidL、eyeLidR 和 jaw）
      robot.eyeLidL?.orientation = simd_mul(
        simd_quatf(
          angle: deg2Rad( -120 + (90 * eyeBlinkLeft) ),
          axis: [1, 0, 0]),
        simd_quatf(
          angle: deg2Rad( (90 * browLeft) - (30 * browInnerUp) ),
          axis: [0, 0, 1])
      )
      
      robot.eyeLidR?.orientation = simd_mul(
        simd_quatf(
          angle: deg2Rad( -120 + (90 * eyeBlinkRight) ),
          axis: [1, 0, 0]),
        simd_quatf(
          angle: deg2Rad( (-90 * browRight) - (-30 * browInnerUp) ),
          axis: [0, 0, 1])
      )
      
      robot.jaw?.orientation = simd_quatf(
        angle: deg2Rad( -100 + (60 * jawOpen) ),
        axis: [1, 0, 0]
      )
    }
    
      //首先从更新的anchors中获取人脸anchor,并根据面部锚点数据将动画应用于场景中的对象。
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
      guard let faceAnchor = anchors.first(where: { $0 is ARFaceAnchor }) as? ARFaceAnchor else { return }
      eyeballLook(at: faceAnchor.lookAtPoint)
      
      animateRobot(faceAnchor: faceAnchor)
    }
  }
}
