//
//  Document.swift
//  ColorBindingSwift
//
//  Created by Eric Kampman on 5/14/16.
//  Copyright © 2016 Eric Kampman. All rights reserved.
//

import Cocoa

class Document: NSDocument, NSWindowDelegate {

	override init() {
	    super.init()
		// Add your subclass-specific initialization here.
	}

	override class func autosavesInPlace() -> Bool {
		return true
	}


	override func dataOfType(typeName: String) throws -> NSData {
		return NSKeyedArchiver.archivedDataWithRootObject(colors)
	}
	
	override func readFromData(data: NSData, ofType typeName: String) throws {
		colors = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Color]
	}

	override func makeWindowControllers() {
		addWindowController(ColorsWindowController())
		
	}
	
	// MARK: - NSWindowDelegate
	func windowWillClose(notification: NSNotification) {
		colors = []
	}
	
	// MARK: - Undo
	func insertObject(color: Color, inColorsAtIndex index: Int) {
		let undo: NSUndoManager = undoManager!
		undo.prepareWithInvocationTarget(self).removeObjectFromColorsAtIndex(colors.count)
		if !undo.undoing {
			undo.setActionName("Add Color")
		}
		colors.insert(color, atIndex: index)
	}
	
	func removeObjectFromColorsAtIndex(index: Int) {
		let color: Color = colors[index]
		
		let undo: NSUndoManager = undoManager!
		undo.prepareWithInvocationTarget(self).insertObject(color, inColorsAtIndex: index)
		if !undo.undoing {
			undo.setActionName("Remove Color")
		}
		
		colors.removeAtIndex(index)
	}

	// MARK: - KVO
	func startObservingColor(color: Color) {
		color.addObserver(self, forKeyPath: "red",
		                  options: .Old, context: &documentKVOContext)
		color.addObserver(self, forKeyPath: "green",
		                  options: .Old, context: &documentKVOContext)
		color.addObserver(self, forKeyPath: "blue",
		                  options: .Old, context: &documentKVOContext)
	}
	
	func stopObservingColor(color: Color) {
		color.removeObserver(self, forKeyPath: "red",
		                     context: &documentKVOContext)
		color.removeObserver(self, forKeyPath: "green",
		                     context: &documentKVOContext)
		color.removeObserver(self, forKeyPath: "blue",
		                     context: &documentKVOContext)
	}
	
	override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		
		if context != &documentKVOContext {
			super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
			return
		}
		
		guard change != nil && object != nil && keyPath != nil else {
			return
		}
		
		var oldValue: AnyObject? = change![NSKeyValueChangeOldKey]
		if oldValue is NSNull {
			oldValue = nil
		}
		let undo = undoManager!
		undo.prepareWithInvocationTarget(object!).setValue(oldValue,
														forKeyPath: keyPath!)
	}

	// MARK: - Properties
	var windowController: ColorsWindowController? {
		get {
			if windowControllers.count == 0 {
				Swift.print("Document -- no window controllers!!")
				return nil
			}
			return windowControllers[0] as? ColorsWindowController
		}
	}

	dynamic var colors = [Color]() {
		willSet {
			for color in colors {
				stopObservingColor(color)
			}
		}
		didSet {
			for color in colors {
				startObservingColor(color)
			}
		}
	}
}

private var documentKVOContext: Int = 0
