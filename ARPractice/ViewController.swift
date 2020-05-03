//
//  ViewController.swift
//  ARPractice
//
//  Created by 下村 一将 on 2020/05/04.
//  Copyright © 2020 Kazumasa Shimomura. All rights reserved.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
    }
}
