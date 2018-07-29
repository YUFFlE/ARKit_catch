//
//  FallingObject.swift
//  catch
//
//  Created by chaowenwang on 2018/7/28.
//  Copyright © 2018年 chaowenwang. All rights reserved.
//

import Foundation
import ARKit

class FallingObject: SCNReferenceNode {
    
    let modelName: String
    var initialPositon = float3(x: 0, y: 0, z: 0)
    var initialAngle = float3(x: 0, y: 0, z: 0)
    
    // MARK: - Init function
    
    init(modelName: String) {
        self.modelName = modelName
        guard let url = Bundle.main.url(forResource: "Models.scnassets/\(modelName)/\(modelName)", withExtension: "scn")
            else { fatalError("can't find expected virtual object bundle resources") }
        super.init(url: url)!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Load and unload
    
    func loadObject() {
        self.load()
        setPositionAndAngle()
    }
    
    func setPositionAndAngle() {
        self.simdEulerAngles = initialAngle
        self.simdPosition = initialPositon
    }
    
    func unloadObject() {
        self.unload()
        self.removeFromParentNode()
    }
    
    // MARK: - Random float3
    
    static func randomFloat3(x: Float, y: Float, z: Float) -> float3 {
        let xr = Float(arc4random_uniform(UInt32(x*1000)))/1000
        let yr = Float(arc4random_uniform(UInt32(y*1000)))/1000
        let zr = Float(arc4random_uniform(UInt32(z*1000)))/1000
        return float3(x: xr, y: yr, z: zr)
    }
    
}

extension FallingObject {
    
    // MARK: -  Rotation Matrix 3x3
    func rotationMatrix3x3() -> matrix_float3x3 {
        let tsf = self.simdTransform
        return matrix_float3x3(
            float3(tsf.columns.0.x, tsf.columns.1.x, tsf.columns.2.x),
            float3(tsf.columns.0.y, tsf.columns.1.y, tsf.columns.2.y),
            float3(tsf.columns.0.z, tsf.columns.1.z, tsf.columns.2.z))
    }
    
    // MARK: - Unit vector float3
    func unitFloat3(vector3: float3 ) -> float3 {
        let sum = sqrt(vector3.x * vector3.x + vector3.y * vector3.y + vector3.z * vector3.z)
        return float3(vector3.x/sum, vector3.y/sum, vector3.z/sum)
    }
    
    // MARK: - Rotation alpha around float3(x,y,z)
    func rotationAlphaAroundFloat3(alpha: Float, vector3: float3 ) -> matrix_float4x4 {
        
        let unitVector3 = unitFloat3(vector3: vector3)
        let u = unitVector3.x
        let v = unitVector3.y
        let w = unitVector3.z
        return matrix_float4x4(
        float4(u*u+(1-u*u)*cos(alpha), u*v*(1-cos(alpha))-w*sin(alpha), u*w*(1-cos(alpha))+v*sin(alpha), 0),
        float4(u*v*(1-cos(alpha))+w*sin(alpha), v*v+(1-v*v)*cos(alpha), w*v*(1-cos(alpha))-u*sin(alpha), 0),
        float4(u*w*(1-cos(alpha))-v*sin(alpha), w*v*(1-cos(alpha))+u*sin(alpha), w*w+(1-w*w)*cos(alpha), 0),
        float4(0, 0, 0, 1))
        
        
    }
}

