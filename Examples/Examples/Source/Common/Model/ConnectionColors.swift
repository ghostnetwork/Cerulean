//
//  ConnectionColors.swift
//  Examples
//
//  Created by Keith Ermel on 4/27/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

import UIKit


@objc enum ConnectionStatus: Int {
    case Unknown
    case Connected
    case Disconnected
    
    var description: String {
        switch self {
        case Unknown: return "Unknown"
        case Connected: return "Connected"
        case Disconnected: return "Disconnected"
        }
    }
}


@objc class ConnectionColors {

    static func colorForStatus(status: ConnectionStatus) -> UIColor {
        switch status {
        case .Connected: return UIColor.greenColor()
        case .Disconnected: return UIColor.redColor()
        case .Unknown: return UIColor.grayColor()
        default: return UIColor.blackColor()
        }
    }
}
