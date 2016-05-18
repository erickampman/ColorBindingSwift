//
//  ColorsView.swift
//  ColorBindingSwift
//
//  Created by Eric Kampman on 5/14/16.
//  Copyright © 2016 Eric Kampman. All rights reserved.
//

import Cocoa

let COLORS_BINDING_NAME = "colors"
let SELECTION_BINDING_NAME = "selection"
let RED_BINDING_NAME = "red"
let GREEN_BINDING_NAME = "green"
let BLUE_BINDING_NAME = "blue"

typealias StringObjectDictionary = [String:AnyObject]
typealias BindingDictionary = [String:StringObjectDictionary]

class ColorsView: NSView {

	var bindingInfo = BindingDictionary()
	var boundInited = false
	let emptyDictionary = StringObjectDictionary()

/*
	override class func initialize() {
		exposeBinding(COLORS_BINDING_NAME)
		exposeBinding(SELECTION_BINDING_NAME)
	}
*/
	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		initBindingInfo()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		initBindingInfo()
	}
	
	// MARK: - KVO
	func initBindingInfo() {
		bindingInfo = [:]
		bindingInfo[COLORS_BINDING_NAME] = emptyDictionary
		bindingInfo[SELECTION_BINDING_NAME] = emptyDictionary
		bindingInfo[RED_BINDING_NAME] = emptyDictionary
		bindingInfo[GREEN_BINDING_NAME] = emptyDictionary
		bindingInfo[BLUE_BINDING_NAME] = emptyDictionary
	}

	override func bind(binding: String, toObject observable: AnyObject, withKeyPath keyPath: String, options: [String : AnyObject]?) {
		for (key, value) in bindingInfo {
			if binding == key {
				if value.count != 0	{ // i.e. is this an 'empyDictionary'?'
					unbind(key)
				}
				
				let options = options ?? emptyDictionary
				
				let bindingsData: StringObjectDictionary = [
					NSObservedObjectKey : observable,
					NSObservedKeyPathKey : keyPath,
					NSOptionsKey : options
				]
				bindingInfo[binding] = bindingsData
				
				observable.addObserver(self, forKeyPath: keyPath, options: [.Old,.New], context: &colorsViewContext)
				
				return
			}
		}
		super.bind(binding, toObject: observable, withKeyPath: keyPath, options: options)
	}
	
	override func unbind(binding: String) {
		for (key, value) in bindingInfo {
			// if key matches and value is not emptyDictionary
			if key == binding && value.count != 0 {
				let observed = value[NSObservedObjectKey]
				if let obs = observed {
					obs.removeObserver(self, forKeyPath: key)
					bindingInfo[key] = emptyDictionary
				} else {
					Swift.print("Called unbind on unbound key")
				}
				needsDisplay = true
				return
			}
		}
		super.unbind(binding)
		needsDisplay = true // ?
	}
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		
		if context != &colorsViewContext {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
			return
		}
		
		needsDisplay = true
		
		if let change = change {
			for (key, _) in change {
				Swift.print("observeValueForKeyPath keypath: \(keyPath) key: \(key)")
			}
		}
	}
	
	override func infoForBinding(binding: String) -> [String : AnyObject]? {
		if let info = bindingInfo[binding] {
			if info.count != 0 {
				return info
			} else {
				// then it's empty dictionary
				return nil
			}
		}
		return super.infoForBinding(binding)
	}
	dynamic var colorsContainer: NSArrayController? {
		get {
			if let dict = infoForBinding(COLORS_BINDING_NAME) {
				return dict[NSObservedObjectKey] as? NSArrayController
			}
			return nil
		}
	}
	dynamic var colorsKeyPath: String? {
		get {
			if let dict = infoForBinding(COLORS_BINDING_NAME) {
				return dict[NSObservedKeyPathKey] as? String
			}
			return nil
		}
	}
	@IBInspectable dynamic var colors: NSArray? {
		get {
			if colorsContainer != nil && colorsKeyPath != nil {
				return colorsContainer!.valueForKeyPath(colorsKeyPath!) as? NSArray
			}
			return nil
		}
	}

	// MARK: - Drawing
	override func drawRect(dirtyRect: NSRect) {
		guard boundInited else {
			needsDisplay = true
			return
		}
		
		if let colors = colors {
			let count = colors.count
			let heightPerColor = bounds.size.height / CGFloat(count)
			var tRect = NSMakeRect(bounds.origin.x, bounds.origin.y,
			                       bounds.size.width, heightPerColor)
			for color in colors {
//				Swift.print("red \(color.red) greem \(color.green) blue \(color.blue)")
				let nscolor = NSColor(deviceRed: color.red, green: color.green, blue: color.blue, alpha: 1.0)
				nscolor.set()
				NSBezierPath.fillRect(tRect)
				tRect.origin.y += heightPerColor
			}
		}
	}
}

private var colorsViewContext: Int = 0

