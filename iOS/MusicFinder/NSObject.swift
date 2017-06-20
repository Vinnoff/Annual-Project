//
//  NSObject.swift
//  MusicFinder
//
//  Created by TRAING Serey on 26/03/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//
import UIKit

extension NSObject{
    static func className()-> String{
        return String(describing: self)
    }
}
