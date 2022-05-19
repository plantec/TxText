Class {
	#name : #TxTextEditorMorph,
	#superclass : #TxBasicViewMorph,
	#instVars : [
		'controller',
		'cursorMorph',
		'layoutViewMorph'
	],
	#classVars : [
		'CursorEdgeMargin'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #keybindings }
TxTextEditorMorph class >> buildTextEditorKeymapsOn: aBuilder [	 
	<keymap> 
	 
	{  
		Character home. #moveToLineStart.
		Character home shift. #selectToLineStart.
		Character end. #moveToLineEnd.
		Character end shift. #selectToLineEnd.
		
		Character arrowRight. #moveRight.
		Character arrowLeft. #moveLeft.
		Character arrowUp. #moveUp.
		Character arrowDown. #moveDown.
		Character cr. #handleEnterKey.
		Character delete. #handleDeleteKey.
		Character backspace. #handleBackspaceKey.
		Character pageDown. #movePageDown.
		Character pageUp. #movePageUp.
		$z meta. #undo.
		Character arrowRight shift. #extendSelectionRight.
		Character arrowLeft shift. #extendSelectionLeft.
		Character arrowUp shift. #extendSelectionUp.
		Character arrowDown shift. #extendSelectionDown.
		$v command. #pasteClipboard.
		$c command. #copyToClipboard.
		$x command. #cutToClipboard.
		$a command. #selectAll.
		
	 } pairsDo: [ :key :action |
		(aBuilder shortcut: action )
		category: #TxTextEditorMorph
		default: key asKeyCombination
		do: [ :morph | morph perform: action ].
	]
]

{ #category : #examples }
TxTextEditorMorph class >> exampleHugeText [

	| text |
	text := TxModel new.
	1 to: 100000 do: [ :i | 
		text endPosition
			insert: i asString , ' The quick brown fox jumps over the lazy dog 1234567890';
			insert: String cr.
	].
	^ self openInWindowWithText: text
]

{ #category : #examples }
TxTextEditorMorph class >> exampleSimple [

	| text |
	text := TxModel new.
	text endPosition
		insert: (String loremIpsum: 1000);
		insert: String cr.
	^ self openInWindowWithText: text
]

{ #category : #examples }
TxTextEditorMorph class >> exampleTextMultiSizeFont [

	| text |
	text := TxModel new.
	100 timesRepeat: [ 	
		1 to: 10 do: [ :i | | font lastLineSelection | 
			text endPosition insert: 'The quick brown fox jumps over the lazy dog 1234567890'.
			font := LogicalFont familyName: self fontFamilyForExamples pointSize: 9 + i.
			lastLineSelection := text endPosition moveToLineStart selectTo: text endPosition.
			lastLineSelection applyAttribute: (TxFontAttribute with: font).
			text endPosition insert: String cr.
		].
	].
	^ self openInWindowWithText: text
]

{ #category : #examples }
TxTextEditorMorph class >> exampleWithCustomClickAction [
	| text action selection |
	text := 'abciuwhfi whifu wehifuhweifu wi ' asTxModel.
	action := TxActionAttribute new 
			filter: [ :evt | evt commandKeyPressed and: [ evt isMouseDown ] ];
			value: [ self inform: 'action' ].
	selection := text startPosition selectTo: (text startPosition + 10).
	selection
		applyAttribute: action;
		applyAttribute: (TxForeColorAttribute with: Color red).
	^ self openInWindowWithText: text
]

{ #category : #examples }
TxTextEditorMorph class >> exampleWithCustomCursor [
	| text selection |
	text := 'abciuwhfi whifu wehifuhweifu wi ' asTxModel.
	selection := text startPosition selectTo: (text startPosition + 20).
	selection
		applyAttribute: (TxMouseCursorAttribute with: Cursor webLink);
		applyAttribute: (TxForeColorAttribute with: Color blue).
	^ self openInWindowWithText: text
]

{ #category : #examples }
TxTextEditorMorph class >> exampleWithEmbeddedObject [

	| text |
	text := TxModel new.
	1000 timesRepeat: [ 
		text endPosition
			insert: 'wioeuhfiw eufi';
			insertObject:  Morph new;
			insert: 'uwe hfiuweh fiue', String cr;
			insert: '-------', String cr.
	].
	^ self openInWindowWithText: text

]

{ #category : #initialization }
TxTextEditorMorph class >> initialize [
	
	CursorEdgeMargin := 10. "This constant controls the margin between the view's edge and the cursor, used when the view is auto-scrolled to make the current cursor position fully visible and not clipped"
]

{ #category : #editing }
TxTextEditorMorph >> addNewLineAtCursor [
	self insert: Character cr
]

{ #category : #testing }
TxTextEditorMorph >> allowsKeymapping [
	^ true
]

{ #category : #scrolling }
TxTextEditorMorph >> autoScrollView: evt [
	"This is kind of a hack because the PluggableTextMorph expects me to first expand the selection before auto scrolling will work."

	evt position y < self top
		ifTrue: [ layoutViewMorph scrollBy: 0 @ (evt position y - self top) abs negated ]
		ifFalse: [ layoutViewMorph scrollBy: 0 @ (evt position y - self top) abs ].
	
	self selectTo: evt position - layoutViewMorph innerBounds origin.
]

{ #category : #accessing }
TxTextEditorMorph >> borderWidth [
	^ 0
]

{ #category : #'text wrapping' }
TxTextEditorMorph >> characterWrappingStrategy [

	^ TxAthensCharacterWrappingStrategy new rightMargin: CursorEdgeMargin
]

{ #category : #accessing }
TxTextEditorMorph >> clipSubmorphs [
	"we're always clipping"
	^ true
]

{ #category : #accessing }
TxTextEditorMorph >> contents: anObject [
 
	controller contents: anObject.
	
	self resetViewTo: controller cursorPosition.
	self controllerChanged.
]

{ #category : #accessing }
TxTextEditorMorph >> controller [
	^ controller
]

{ #category : #updating }
TxTextEditorMorph >> controllerChanged [
	layoutViewMorph updateMorph.
	self updateCursor: true.
]

{ #category : #editing }
TxTextEditorMorph >> copyToClipboard [
	self halt.
	controller selection isEmpty ifTrue: [ ^ self ].

	
	Clipboard clipboardText: controller selection asString.
	

]

{ #category : #accessing }
TxTextEditorMorph >> cursor: aTxCursor [ 

	cursorMorph delete.
	cursorMorph := aTxCursor.
	self addMorph: cursorMorph.
]

{ #category : #'event handling' }
TxTextEditorMorph >> cursorForPosition: aPoint [
	| pos |
	pos := layoutViewMorph textPositionAt: (aPoint - layoutViewMorph innerBounds origin).
	^ pos span attributeAt: TxMouseCursorAttribute.
	
]

{ #category : #editing }
TxTextEditorMorph >> cutToClipboard [
	
	controller selection isEmpty ifTrue: [ ^ self ].

	Clipboard clipboardText: controller selection asString.
	self handleDeleteKey.

]

{ #category : #initialization }
TxTextEditorMorph >> defaultCursor [
	^ TxCaretCursor new
]

{ #category : #updating }
TxTextEditorMorph >> doLayoutIn: layoutBounds [

	"force view morph to always cover layout bounds"
	layoutViewMorph bounds: layoutBounds.
	self updateCursor.
	super doLayoutIn:layoutBounds.
	
]

{ #category : #drawing }
TxTextEditorMorph >> drawCursorPositionOn: aCanvas [
	"debugging: draw the cursor position (line/col numbers)"
	| pathTransform pos |

	pos := controller cursorPosition asString.
	
	pathTransform := aCanvas pathTransform.
	pathTransform restoreAfter: [
		pathTransform translateX: 0 Y: self height - 20.
		aCanvas setFont: (LogicalFont familyName: 'Arial' pointSize: 16).
		aCanvas setPaint: (Color red alpha:0.5).
		aCanvas drawString: pos ]
	
	
]

{ #category : #drawing }
TxTextEditorMorph >> drawKeyboardFocusOn: aCanvas [ 
	"draw an outline, indicating that receiver has the input focus"
	| stroke |
	stroke := aCanvas setStrokePaint: Color yellow.
	stroke 
		width: self borderWidth;
		joinRound.
	aCanvas
		drawShape: (self innerBounds expandBy: self borderWidth/2.0) ;
		draw.
		
]

{ #category : #'drawing-not supported' }
TxTextEditorMorph >> drawOn: aCanvas [
	"I'm Athens only!"
]

{ #category : #drawing }
TxTextEditorMorph >> drawOnAthensCanvas: aCanvas [
	super drawOnAthensCanvas: aCanvas.
	self drawSelectionOn: aCanvas.
	self hasKeyboardFocus 
		ifTrue: [ self drawKeyboardFocusOn: aCanvas ]
]

{ #category : #drawing }
TxTextEditorMorph >> drawOverlaysOn: aCanvas [
	"draw an overlays (after all submorphs being drawn)"
	
	| pathTransform |
	pathTransform := aCanvas pathTransform.
	pathTransform restoreAfter: [
		pathTransform translateBy: self innerBounds topLeft.  
		
		self hasFocus ifTrue: [ 
			aCanvas setPaint: (Color yellow alpha:0.05).
			aCanvas drawShape: (0@0 extent: self innerBounds extent)
			 ]
		
	"	self drawCursorPositionOn: aCanvas."
	].

]

{ #category : #drawing }
TxTextEditorMorph >> drawSelectionOn: aCanvas [

	controller selection isEmpty ifTrue: [ ^ self ].
	aCanvas pathTransform restoreAfter: [ 
		aCanvas pathTransform translateBy: self innerBounds topLeft.  
		aCanvas 
			clipBy: (0@0 extent: self layoutView extent)  
			during: [ 
				self layoutView 
					renderHighlight: controller selection 
					with: self theme selectionColor 
					on: aCanvas ]]
]

{ #category : #'drawing-not supported' }
TxTextEditorMorph >> drawSubmorphsOn: aCanvas [
	"I'm Athens only!"
]

{ #category : #'navigation-selection' }
TxTextEditorMorph >> extendSelectionDown [
	self moveDown: true.
	
]

{ #category : #'navigation-selection' }
TxTextEditorMorph >> extendSelectionLeft [
	controller extendSelectionLeft.
	self updateCursor: true.
]

{ #category : #'navigation-selection' }
TxTextEditorMorph >> extendSelectionRight [
	controller extendSelectionRight.
	self updateCursor: true.
]

{ #category : #'navigation-selection' }
TxTextEditorMorph >> extendSelectionUp [
	self moveUp: true.
	
]

{ #category : #drawing }
TxTextEditorMorph >> fullDrawOnAthensCanvas: aCanvas [
	| clip |
	super fullDrawOnAthensCanvas: aCanvas.
	clip := self clippingBounds.

	aCanvas 
		clipBy: clip
		during: [ self drawOverlaysOn: aCanvas ]
]

{ #category : #editing }
TxTextEditorMorph >> handleBackspaceKey [
	(controller selection contains: self layoutView layout startPosition)
		ifTrue: [ 
			"The selected portion to delete contains layout starting position. We must
			take care resetting view to new position"
			self layoutView resetLayout: controller selection start ].
	controller backspace.
	self layoutView layout startPosition isValid
		ifFalse: [ self layoutView resetLayout: controller selection start ].
	self controllerChanged
]

{ #category : #editing }
TxTextEditorMorph >> handleDeleteKey [

	(controller selection contains: (self layoutView layout startPosition)) ifTrue: [ 
		"The selected portion to delete contains layout starting position. We must
		take care resetting view to new position"
		self layoutView resetLayout: controller selection start.
		 ].

	controller delete.
	self controllerChanged.
]

{ #category : #editing }
TxTextEditorMorph >> handleEnterKey [
	self insert: String cr.
	self controllerChanged.
]

{ #category : #'event handling' }
TxTextEditorMorph >> handleMouseMove: anEvent [
	"Reimplemented because we really want #mouseMove when a morph is dragged around"
	anEvent wasHandled ifTrue:[^self]. "not interested"
	(anEvent hand hasSubmorphs) ifTrue:[^self].
	anEvent wasHandled: true.
	self mouseMove: anEvent.
	(self handlesMouseStillDown: anEvent) ifTrue:[
		"Step at the new location"
		self startStepping: #handleMouseStillDown: 
			at: Time millisecondClockValue
			arguments: {anEvent copy resetHandlerFields}
			stepTime: 1].

]

{ #category : #'event handling' }
TxTextEditorMorph >> handlesKeyDown: event [
	^ true
]

{ #category : #'event handling' }
TxTextEditorMorph >> handlesKeyboard: evt [
	
	^true
]

{ #category : #'event handling' }
TxTextEditorMorph >> handlesMouseDown: event [
	^ true
]

{ #category : #'event handling' }
TxTextEditorMorph >> handlesMouseOver: evt [ 
	"Do I want to receive mouseEnter: and mouseLeave: when the button is up and the hand is empty?"
	^ true
]

{ #category : #'event handling' }
TxTextEditorMorph >> handlesMouseWheel: event [
	^ true
]

{ #category : #'focus management' }
TxTextEditorMorph >> hasFocus [
	^ self hasKeyboardFocus
]

{ #category : #updating }
TxTextEditorMorph >> initializeController [
	controller := TxTextEditor text: self text.
	self controllerChanged.
]

{ #category : #initialization }
TxTextEditorMorph >> initializeShortcuts: aKMDispatcher [
self halt.
	aKMDispatcher attachCategory: #TxTextEditorMorph 
]

{ #category : #initialization }
TxTextEditorMorph >> initializeText: aTxModel [ 
	cursorMorph := TxCaretCursor new.
	self addMorph: cursorMorph.

	layoutViewMorph := self newViewMorphOn: aTxModel.
	layoutViewMorph 
"		hResizing: #spaceFill;
		vResizing: #spaceFill".
	self addMorph: layoutViewMorph.

 	
	self initializeController.
	self color: Color white
]

{ #category : #editing }
TxTextEditorMorph >> insert: aString [ 	

	controller insert: aString.

	self controllerChanged.
]

{ #category : #editing }
TxTextEditorMorph >> insertObject: anObject [ 	

	controller insertObject: anObject.
	self controllerChanged.
]

{ #category : #'event handling' }
TxTextEditorMorph >> keyStroke: anEvent [ 

	self insert:  anEvent keyCharacter asString. 
	
	
]

{ #category : #'focus management' }
TxTextEditorMorph >> keyboardFocusChange: gotFocus [

	super keyboardFocusChange: gotFocus.
	
	cursorMorph visible: gotFocus; stopStepping.
]

{ #category : #accessing }
TxTextEditorMorph >> layoutStrategy: aStrategy [

	self layoutViewMorph layoutStrategy: aStrategy
]

{ #category : #accessing }
TxTextEditorMorph >> layoutView [
	^ layoutViewMorph layoutView
]

{ #category : #accessing }
TxTextEditorMorph >> layoutViewMorph [
	^ layoutViewMorph
]

{ #category : #'event handling' }
TxTextEditorMorph >> mouseDown: anEvent [
	| pos action point |
	self takeKeyboardFocus.
	
	point := anEvent position - layoutViewMorph innerBounds origin.
	pos := layoutViewMorph textPositionAt: point. 
	action := pos span attributeAt: TxActionAttribute.
	(action handleEvent: anEvent) ifTrue: [  ^ self ].
	
	anEvent redButtonPressed ifTrue: [
		anEvent shiftPressed
			ifTrue: [ self selectTo: point ]
			ifFalse: [ self moveTo: point ] ].

	anEvent yellowButtonPressed ifTrue: [
		
		self announcer announce: (TxContextMenuAnnouncement new
			event: anEvent;
			editorMorph: self;
			textPosition: pos;
			yourself
		).
	]
]

{ #category : #'event handling' }
TxTextEditorMorph >> mouseLeave: evt [
	"Handle a mouseLeave event, meaning the mouse just left my bounds with no button pressed."
	super mouseLeave: evt.
	self currentHand showTemporaryCursor: nil
	
]

{ #category : #'event handling' }
TxTextEditorMorph >> mouseMove: anEvent [

	anEvent hand showTemporaryCursor: (self cursorForPosition: anEvent position).

	anEvent redButtonPressed "left button" ifTrue: [ 
		(anEvent position y between: self top and: self bottom) ifFalse:[
			self startStepping: #autoScrollView:
			at: Time millisecondClockValue
			arguments: (Array with: anEvent)
			stepTime: 100. "fast enough" ]
		ifTrue: [ 		
			self stopSteppingSelector: #autoScrollView:.
			self selectTo: anEvent position - layoutViewMorph innerBounds origin.
		]
	 ]
]

{ #category : #'event handling' }
TxTextEditorMorph >> mouseUp: anEvent [
	self stopSteppingSelector: #autoScrollView:.
]

{ #category : #'event handling' }
TxTextEditorMorph >> mouseWheel: event [
	event isUp ifTrue: [
		layoutViewMorph scrollBy: 0@ (layoutViewMorph height/10) negated.
		  ].
	event isDown ifTrue: [ 
		layoutViewMorph scrollBy: 0@ (layoutViewMorph height/10).
	  ].
	
	self updateCursor: false.
]

{ #category : #navigation }
TxTextEditorMorph >> moveDown [
	"move down visually"
	| pos visualPos point |

	pos := controller cursorPosition.
	visualPos := layoutViewMorph layoutPositionAt:  pos ifOutside: [
		"outside of layout, lets move down via text"
		controller moveDown.
		^ self updateCursor: true.
		].
	
	"we are adding small constant to point just outside the bounds of current line where cursor is located"
	point := visualPos bottomPoint + (0@0.001).
	layoutViewMorph ensurePointWithinLayout: point.

	".. and if there's something more, let layout give us new position "
	controller moveCursorTo: (layoutViewMorph textPositionAt: point).		
	self updateCursor:true.
	
]

{ #category : #navigation }
TxTextEditorMorph >> moveDown: extendingSelection [
	"move down visually"
	| pos visualPos point |

	pos := controller cursorPosition.
	visualPos := layoutViewMorph layoutPositionAt:  pos ifOutside: [
		"outside of layout, lets move down via text"
		controller moveDown.
		^ self updateCursor: true.
		].
	
	"we are adding small constant to point just outside the bounds of current line where cursor is located"
	point := visualPos bottomPoint + (0@0.001).
	layoutViewMorph ensurePointWithinLayout: point.

	".. and if there's something more, let layout give us new position "
	point := layoutViewMorph textPositionAt: point.
	extendingSelection 
		ifTrue: [ controller moveSelectionEndTo: point ] 
		ifFalse: [ controller moveCursorTo: point ].

	self updateCursor:true.
	
]

{ #category : #navigation }
TxTextEditorMorph >> moveLeft [

	controller moveLeft.
	self updateCursor: true.
]

{ #category : #navigation }
TxTextEditorMorph >> movePageDown [
	"move down visually"
	| pos visualPos point |

	pos := controller cursorPosition.
	visualPos := layoutViewMorph layoutPositionAt:  pos ifOutside: [
		layoutViewMorph scrollIntoView: pos.
		visualPos := layoutViewMorph layoutPositionAt:  pos ifOutside: [ self error: 'that''s not damn possible' ].
	].
	
	
	"we are adding small constant to point just outside the bounds of current line where cursor is located"
	point := visualPos topPointInView.
	layoutViewMorph scrollBy: 0@visualPos layout view height.
 
 	controller moveCursorTo: (layoutViewMorph textPositionAt: point).		
	self updateCursor:true.
	
]

{ #category : #navigation }
TxTextEditorMorph >> movePageUp [
	"move up visually"
	| pos visualPos point |


	pos := controller cursorPosition.
	visualPos := layoutViewMorph layoutPositionAt:  pos ifOutside: [
		layoutViewMorph scrollIntoView: pos.
		visualPos := layoutViewMorph layoutPositionAt:  pos ifOutside: [ self error: 'that''s not damn possible' ].
		].
	
	
	"we are adding small constant to point just outside the bounds of current line where cursor is located"
	point := visualPos topPointInView.
	layoutViewMorph scrollBy: 0@visualPos layout view height negated.
 
 	controller moveCursorTo: (layoutViewMorph textPositionAt: point).		
	self updateCursor:true.
	
]

{ #category : #navigation }
TxTextEditorMorph >> moveRight [
	
	controller moveRight.
	self updateCursor: true.
]

{ #category : #navigation }
TxTextEditorMorph >> moveTo: aPoint [
	"when user clicks on text, move a text cursor close to hand position"
	| textPosition |
	textPosition := layoutViewMorph textPositionAt: aPoint.
	controller moveCursorTo: textPosition.
	self updateCursor: true.
	
]

{ #category : #navigation }
TxTextEditorMorph >> moveToLineEnd [

	controller moveToLineEnd.
	self updateCursor: true.
]

{ #category : #navigation }
TxTextEditorMorph >> moveToLineStart [

	controller moveToLineStart.
	self updateCursor: true.
]

{ #category : #navigation }
TxTextEditorMorph >> moveUp [
	"move cursor up"

	^ self moveUp: false
]

{ #category : #navigation }
TxTextEditorMorph >> moveUp: extendingSelection [
	"move up visually"
	| pos visualPos point |
	pos := controller cursorPosition.
	visualPos := layoutViewMorph layoutPositionAt:  pos ifOutside: [
		"outside of layout, lets move down via text"
		controller moveUp.

		^ self updateCursor: true.
		].
	"we are subtracting small constant to point just outside the bounds at the top of current line"

	point := visualPos topPointInView - (0@0.0001).
	layoutViewMorph ensurePointWithinLayout: point.

	pos := layoutViewMorph textPositionAt: point.

	extendingSelection 
		ifTrue: [ controller moveSelectionEndTo:pos ] 
		ifFalse: [ controller moveCursorTo: pos ].
	self updateCursor: true.
]

{ #category : #initialization }
TxTextEditorMorph >> newViewMorphOn: aTxModel [ 
	^ TxLayoutViewMorph text: aTxModel .

]

{ #category : #updating }
TxTextEditorMorph >> ownerChanged [

	self updateCursor .
	
]

{ #category : #editing }
TxTextEditorMorph >> pasteClipboard [
	| stuff |
	
	stuff := Clipboard clipboardText asString.
	
	self insert: stuff.
]

{ #category : #scrolling }
TxTextEditorMorph >> resetViewTo: startPosition [

	layoutViewMorph resetViewTo: startPosition.
	self updateCursor: false.

]

{ #category : #scrolling }
TxTextEditorMorph >> scrollBy: aPoint [ 
	layoutViewMorph scrollBy: aPoint.
	self changed.
]

{ #category : #navigation }
TxTextEditorMorph >> scrollIntoView: aTextPosition [

	layoutViewMorph scrollIntoView: aTextPosition.
	self updateCursor: false.
]

{ #category : #'navigation-selection' }
TxTextEditorMorph >> selectAll [
	controller selectAll.
	self updateCursor: false.
	self changed.
]

{ #category : #'navigation-selection' }
TxTextEditorMorph >> selectTo: aPoint [ 
	"when user clicks on text, shift key select close to hand position"
	| textPosition |
	textPosition := layoutViewMorph textPositionAt: aPoint.
	controller moveSelectionEndTo: textPosition.
	self updateCursor: true.
	
]

{ #category : #navigation }
TxTextEditorMorph >> selectToLineEnd [

	controller extendSelectionToLineEnd.
	self updateCursor: true.
]

{ #category : #navigation }
TxTextEditorMorph >> selectToLineStart [

	controller extendSelectionToLineStart.
	self updateCursor: true.
]

{ #category : #testing }
TxTextEditorMorph >> selectionIsEmpty [
	^ controller selection isEmpty
]

{ #category : #'focus management' }
TxTextEditorMorph >> takesKeyboardFocus [
	^ true
]

{ #category : #accessing }
TxTextEditorMorph >> text [
	^ layoutViewMorph text 
]

{ #category : #editing }
TxTextEditorMorph >> undo [ 	
	controller undo.
	self controllerChanged.
]

{ #category : #updating }
TxTextEditorMorph >> updateCursor [
	self updateCursor: false.
]

{ #category : #updating }
TxTextEditorMorph >> updateCursor: scrollViewToCursorPos [

	| position textPosition |

	scrollViewToCursorPos ifTrue: [  
		layoutViewMorph 
			scrollIntoView: controller cursorPosition
			margin: CursorEdgeMargin
		 ].

	textPosition := controller cursorPosition.
	position := layoutViewMorph layoutPositionAt: textPosition ifOutside: [  
		^ cursorMorph visible: false.
		].
	cursorMorph visible: self hasFocus.
	cursorMorph layoutPosition: position.

]
