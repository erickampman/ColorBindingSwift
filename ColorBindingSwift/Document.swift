//
//  Document.swift
//  ColorBindingSwift
//
//  Created by Eric Kampman on 5/14/16.
//  Copyright © 2016 Eric Kampman. All rights reserved.
//

import Cocoa

class Document: NSDocument {

	override init() {
	    super.init()
		// Add your subclass-specific initialization here.
	}

	override class func autosavesInPlace() -> Bool {
		return true
	}

	override func dataOfType(typeName: String) throws -> NSData {
		// Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
		// You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
		throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
	}

	override func readFromData(data: NSData, ofType typeName: String) throws {
		// Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
		// You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
		// If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
		throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
	}

	override func makeWindowControllers() {
		addWindowController(ColorsWindowController())
		
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

	dynamic var colors = [Color]()
}

