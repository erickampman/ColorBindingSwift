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
	dynamic var _red = CGFloat(0)
	dynamic var _green = CGFloat(0)
	dynamic var _blue = CGFloat(0)
	
	override init() {
		super.init()
	}
	
	var color: NSColor {
		get {
			return NSColor(deviceRed: 0, green: 0, blue: 0, alpha: 1.0)
		}
	}

	dynamic var red: CGFloat {
		get {
			return _red
		}
		set (inRed) {
			willChangeValueForKey(RED_BINDING_NAME)
			_red = inRed
			didChangeValueForKey(RED_BINDING_NAME)
		}
	}

	dynamic var green: CGFloat {
		get {
			return _green
		}
		set (inGreen) {
			willChangeValueForKey(GREEN_BINDING_NAME)
			_green = inGreen
			didChangeValueForKey(GREEN_BINDING_NAME)
		}
	}
	dynamic var blue: CGFloat {
		get {
			return _blue
		}
		set (inBlue) {
			willChangeValueForKey(BLUE_BINDING_NAME)
			_blue = inBlue
			didChangeValueForKey(BLUE_BINDING_NAME)
		}
	}
}
