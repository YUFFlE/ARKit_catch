//
//  ViewController.swift
//  catch
//
//  Created by chaowenwang on 2018/7/27.
//  Copyright © 2018年 chaowenwang. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class CatchViewController: UIViewController {

    // MARK: - ARKit Config Properties
    
    let session = ARSession()
    let standardConfiguration: ARWorldTrackingConfiguration = {
       let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
    
    // MARK: - UI Elements
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var stopOrRunButton: UIButton!
    @IBAction func stopOrRun(_ sender: UIButton) {
        isStopFalling = !isStopFalling
        if isStopFalling {
            sender.setTitle("Run", for: .normal)
            sender.setTitleColor(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), for: .normal)
        }
        else {
            sender.setTitle("Stop", for: .normal)
            sender.setTitleColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), for: .normal)
        }
    }
    
    var isStopFalling = false
    
    @IBAction func startFalling(_ sender: UIButton) {
        
        sender.isHidden = true
        stopOrRunButton.isHidden = false
        
        for _ in 0..<15 {
            let object = FallingObject(modelName: "ship")
            updataInitialPositionAndAngle(object: object)
            DispatchQueue.global(qos: .userInitiated).async {
                object.loadObject()
                self.sceneView.scene.rootNode.addChildNode(object)
            }
            fallingObjects.append(object)
        }
    }
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true //防止屏幕在一段时间后变暗
        
        if ARWorldTrackingConfiguration.isSupported {
            session.run(standardConfiguration, options: [.resetTracking, .removeExistingAnchors])
        } else {
            //处理机型不支持ARWorldTrackingConfiguration的错误
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.pause()
    }
    
    // MARK: - Setup
    
    func setupScene() {

        sceneView.delegate = self
        sceneView.session = session
        
        stopOrRunButton.isHidden = true
    }
    
    // MARK: - Falling Object
    
    var fallingObjects = [FallingObject]()
    
    func updataInitialPositionAndAngle( object: FallingObject ) {
        
        let cameraPosition = (session.currentFrame?.camera.transform.columns.3)!
        let position = float3(cameraPosition.x, cameraPosition.y, cameraPosition.z)
                     + FallingObject.randomFloat3(x:8, y:4, z:8)
                     + float3(-4, 4, -4)
        
        let PI = Float(Double.pi)
        let angle = FallingObject.randomFloat3(x: 0, y: 2*PI, z: PI/2)
                  + float3(x: PI/2, y: -1*PI, z: -1*PI/4)
        
        object.initialPositon = position
        object.initialAngle = angle
    }

}

extension CatchViewController {
    static func distance4x4 ( matrix1: matrix_float4x4, matrix2: matrix_float4x4 ) -> Float {
        let v1 = float3(matrix1.columns.3.x, matrix1.columns.3.y, matrix1.columns.3.z)
        let v2 = float3(matrix2.columns.3.x, matrix2.columns.3.y, matrix2.columns.3.z)
        return sqrt((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y) + (v1.z - v2.z)*(v1.x - v2.x))
    }
}
