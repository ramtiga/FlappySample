//
//  RandomFunction.swift
//  FlappySample
//
//  Created by Dai Haneda on 2017/11/20.
//  Copyright © 2017年 Dai Haneda. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
  public static func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
  }
  
  public static func random(min: CGFloat, max : CGFloat) -> CGFloat {
    return CGFloat.random() * (max - min) + min
  }
}
