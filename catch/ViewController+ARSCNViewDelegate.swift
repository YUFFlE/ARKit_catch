//
//  ViewController+ARSCNViewDelegate.swift
//  catch
//
//  Created by chaowenwang on 2018/7/27.
//  Copyright © 2018年 chaowenwang. All rights reserved.
//

import ARKit

extension CatchViewController: ARSCNViewDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if !isStopFalling {
            for fallingObject in fallingObjects {
                if fallingObject.simdPosition.y >= -2
                    && fabs(fallingObject.simdPosition.x - (session.currentFrame?.camera.transform.columns.3.x)!) <= 12
                    && fabs(fallingObject.simdPosition.z - (session.currentFrame?.camera.transform.columns.3.z)!) <= 12
                {
                    
                    let speed_y: Float = Float(arc4random_uniform(UInt32(1000)))/1000/50  + 0.01
                    
                    let rotationMatrix = fallingObject.rotationMatrix3x3()
                    let direct = matrix_multiply(float3(0,0,1), rotationMatrix)
                    
                    if fabsf(direct.y) > 0.001 {
                        let speed_x = speed_y * direct.x / direct.y
                        let speed_z = speed_y * direct.z / direct.y
                        fallingObject.simdPosition -= float3(speed_x, speed_y, speed_z)
                    }
                    else {
                        fallingObject.simdPosition.y -= speed_y
                    }
                    
                    let rotationAroundDirect = fallingObject.rotationAlphaAroundFloat3(alpha: 0.008, vector3: direct)
                    fallingObject.simdTransform = matrix_multiply(fallingObject.simdTransform, rotationAroundDirect)
                }
                else {
                    updataInitialPositionAndAngle(object: fallingObject)
                    fallingObject.setPositionAndAngle()
                }
            }
        }
    }
    
}
