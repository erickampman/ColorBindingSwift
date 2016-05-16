//
//  ColorsWindowController.swift
//  ColorBindingSwift
//
//  Created by Eric Kampman on 5/14/16.
//  Copyright © 2016 Eric Kampman. All rights reserved.
//

import Cocoa

class ColorsWindowController: NSWindowController {

	override var windowNibName: String? {
		return "ColorsWindowController"
	}

    override func windowDidLoad() {
        super.windowDidLoad()

		let array = colorsController.valueForKey("arrangedObjects") as! [Color]
		print("\(array)")
		
		colorsView.bind(COLORS_BINDING_NAME, toObject: colorsController, withKeyPath: "arrangedObjects", options: nil)
		colorsView.bind(SELECTION_BINDING_NAME, toObject: colorsController, withKeyPath: "selection", options: nil)
		colorsView.bind(RED_BINDING_NAME, toObject: colorsController, withKeyPath: "selection.red", options: nil)
		colorsView.bind(GREEN_BINDING_NAME, toObject: colorsController, withKeyPath: "selection.green", options: nil)
		colorsView.bind(BLUE_BINDING_NAME, toObject: colorsController, withKeyPath: "selection.blue", options: nil)
		
		colorsView.boundInited = true
    }
	
	@IBOutlet weak var colorsView: ColorsView!
	@IBOutlet weak var colorsController: NSArrayController!
}
