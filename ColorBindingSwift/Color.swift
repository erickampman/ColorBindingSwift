//
//  Color.swift
//  ColorBindingSwift
//
//  Created by Eric Kampman on 5/15/16.
//  Copyright © 2016 Eric Kampman. All rights reserved.
//

import Cocoa

@objc(Color)
class Color: NSObject {
	dynamic var red = CGFloat(0)
	dynamic var green = CGFloat(0)
	dynamic var blue = CGFloat(0)
	
	dynamic var color: NSColor {
		get {
			return NSColor(deviceRed: red, green: green, blue: blue, alpha: 1.0)
		}
	}

	class func keyPathsForValuesAffectingColor() -> Set<String> {
		return Set<String>(arrayLiteral: RED_BINDING_NAME, GREEN_BINDING_NAME, BLUE_BINDING_NAME)
	}
}
