"
A workspace using TxTextStyler
"
Class {
	#name : #TxWorkspace,
	#superclass : #Object,
	#instVars : [
		'text',
		'editor',
		'styler'
	],
	#category : #'Tool-TxWorkspace'
}

{ #category : #'instance creation' }
TxWorkspace class >> open [
	<script>
	^ self openLabel: 'Tx-Workspace'
]

{ #category : #'instance creation' }
TxWorkspace class >> openLabel: aLabel [
	^ self new openLabel: aLabel ; yourself
]

{ #category : #opening }
TxWorkspace >> buildContextMenu: announcement [

	| menu isEmpty | 
	menu := MenuMorph new.
"	menu addTitle: 'Operations'."
		
	isEmpty := announcement editorMorph selectionIsEmpty.
	
	(menu add: 'Copy' target: announcement editorMorph selector: #copyToClipboard) enabled: isEmpty not.
	(menu add: 'Cut' target: announcement editorMorph selector: #cutToClipboard) enabled: isEmpty not.
	(menu add: 'Paste' target: announcement editorMorph selector: #pasteClipboard) enabled: Clipboard clipboardText isEmpty not.

	menu addLine.
	menu add: 'Do it' target: self selector: #invokeDoitIn: argument: announcement editorMorph.
	menu add: 'Print it' target: self selector: #invokePrintItIn: argument: announcement editorMorph.
	menu add: 'Inspect it' target: self selector: #invokeInspectItIn: argument: announcement editorMorph.
	
	menu popUpEvent: announcement event in: announcement editorMorph world.
	announcement editorMorph takeKeyboardFocus.
]

{ #category : #'morphic ui' }
TxWorkspace >> defaultExtent [
	^ 800@500
]

{ #category : #initialization }
TxWorkspace >> initialize [ 
	super initialize.
	styler := TxTextStyler new.
]

{ #category : #actions }
TxWorkspace >> invokeDoitIn: editorMorph [ 
	| myeditor |
	myeditor := editorMorph controller. 

	myeditor selection isEmpty ifTrue: [  
		myeditor moveToLineStart; extendSelectionToLineEnd. 
	].

	myeditor selection isEmpty ifFalse: [ 
		Smalltalk compiler evaluate: myeditor selection asString.
	 ].
]

{ #category : #actions }
TxWorkspace >> invokeInspectItIn: editorMorph [ 
	| myeditor |
	myeditor := editorMorph controller.

	myeditor selection isEmpty ifTrue: [  
		myeditor moveToLineStart; extendSelectionToLineEnd. 
	].

	myeditor selection isEmpty ifFalse: [ 
		(Smalltalk compiler evaluate: myeditor selection asString) inspect.	
	 ].
]

{ #category : #actions }
TxWorkspace >> invokePrintItIn: editorMorph [ 
	| myeditor result |
	myeditor := editorMorph controller.

	myeditor selection isEmpty ifTrue: [  
		myeditor moveToLineStart; extendSelectionToLineEnd. 
	].

	myeditor selection isEmpty ifFalse: [ 
		result := ' ' , (Smalltalk compiler evaluate: myeditor selection asString) printString.
		myeditor collapseSelection.
		editorMorph insert: result
		
	 ].
]

{ #category : #events }
TxWorkspace >> onTextDeleted: ann [ 
	"self scheduleSyntaxHighlightingUpdate."
	
	self updateSyntaxHighlighting.
]

{ #category : #events }
TxWorkspace >> onTextInserted: ann [ 
	self updateSyntaxHighlighting.
]

{ #category : #opening }
TxWorkspace >> openLabel: aLabel [
	^ self openText: '' withLabel: aLabel
	
]

{ #category : #opening }
TxWorkspace >> openText: aText withLabel: aLabel [
	| view wrapper |
	
	text := aText asTxModel.
	view := TxViewContainer new.

	view addDecorator: (TxScrollbarDecorator new placeRight color: Color blue;yourself).
	view addDecorator: (TxScrollbarDecorator new placeBottom color: Color green;yourself).
	view editText: text.
	view wrapText: true.
	view hResizing: #spaceFill ; vResizing: #spaceFill .
	view layoutFrame: LayoutFrame identity.
	
	view view onAnnouncement: TxContextMenuAnnouncement send: #buildContextMenu: to: self.
	editor := view view.
	
	self wireEvents.
	
	wrapper := AthensWrapMorph new.
	wrapper layoutPolicy: ProportionalLayout new.
	wrapper addMorph: view.
	
	^ (wrapper openInWindowLabeled: aLabel) extent: self defaultExtent.
]

{ #category : #'syntax highlighting' }
TxWorkspace >> updateSyntaxHighlighting [
	"don't try it at home"
	| textEditor start end  |
	true ifTrue: [ ^ self ].
	
	textEditor := editor controller.	
	text := textEditor text.
		
	self flag: 'styling changes the text, and we forced to use crappy method of preserving selection..'.
	start := textEditor selection start asTextIndex.
	end := textEditor selection end asTextIndex.
	
	styler restyle: text inContext: nil isMethod: false.

	"restore selection"	
	textEditor selection start: (text positionAtTextIndex: start).
	textEditor selection end: (text positionAtTextIndex: end).


]

{ #category : #opening }
TxWorkspace >> wireEvents [
	| textEditor |
	
	textEditor := editor controller.
	
	textEditor announcer when: TxDeletedTextAnnouncement send: #onTextDeleted: to: self.
	textEditor announcer when: TxInsertedTextAnnouncement send: #onTextInserted: to: self.
]
