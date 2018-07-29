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
    @IBOutlet weak var moreCloser: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var andOne: UILabel!
    
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
        //未调用setup
        sceneView.delegate = self
        sceneView.session = session
        
        moreCloser.isHidden = true
        andOne.isHidden = true
    }
    
    // MARK: - Gesture Recongnizer
    
    

}

