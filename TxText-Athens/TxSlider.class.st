"
position:  0..1
thickness: 0..1
"
Class {
	#name : #TxSlider,
	#superclass : #Morph,
	#instVars : [
		'thickness',
		'mappedThickness',
		'mappedPosition',
		'captured',
		'sliderPosition'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #factory }
TxSlider class >> horizontal [
	^ TxHorizontalSlider 
]

{ #category : #tests }
TxSlider class >> test [
"self test"
	| m w |
	
	m := self new.
	m announcer when: TxSliderScrollForward send: #advance to: m.
	m announcer when: TxSliderScrollBackward send: #retreat to: m.
	
	w := AthensWrapMorph new.
	
	w addMorph: m.
	w openInWindow.
]

{ #category : #factory }
TxSlider class >> vertical [
" e.g. 

TxSlider vertical new

instead of

TxVerticalSlider new

"

	^ TxVerticalSlider 
]

{ #category : #'for testing' }
TxSlider >> advance [

	self sliderPosition: sliderPosition + 0.1
]

{ #category : #stepping }
TxSlider >> animateScrollingBackward: downPos [

	"stop scrolling if slider reached cursor position"
	(downPos < mappedPosition) 
		ifTrue: [ self announcer announce: (TxSliderScrollBackward source: self) ]
		ifFalse: [ self stopStepping  ] 


]

{ #category : #stepping }
TxSlider >> animateScrollingForward: downPos [

	"stop scrolling if slider reached cursor position"
	(downPos > (mappedPosition+ mappedThickness)) 
		ifTrue: [ self announcer announce: (TxSliderScrollForward source: self) ]
		ifFalse: [ self stopStepping  ] 


]

{ #category : #protocol }
TxSlider >> backgroundColor [
	^ Color darkGray 
]

{ #category : #'column drawing' }
TxSlider >> defaultWidth [
	"answer the default width of slider (column width for vertical, row height for horizontal one"
	^ 10
]

{ #category : #'event handling' }
TxSlider >> handleMouseDownAfterSlider: evt  mappedPosition: downPos [

	self announcer announce: (TxSliderScrollForward source: self).

	self world 
		startStepping: self 
		at: Time millisecondClockValue
		selector: #animateScrollingForward: arguments: { downPos } stepTime: self scrollingDelay.
	
]

{ #category : #'event handling' }
TxSlider >> handleMouseDownAheadOfSlider: evt mappedPosition: downPos [

	self announcer announce: (TxSliderScrollBackward source: self).

	self world 
		startStepping: self 
		at: Time millisecondClockValue
		selector: #animateScrollingBackward: arguments: { downPos } stepTime: self scrollingDelay.
	
]

{ #category : #'event handling' }
TxSlider >> handleMouseDownOnSlider: evt mappedPosition: aNumber [ 
	| originalPos |
	
	originalPos := self originForDragStart: evt position.
	captured := true. 
	self changed.
	
	[ 
		evt hand captureEventsWhile: [ :event |
			event isMouse not or: [ self handleEventWhileDraggingSlider: event delta: originalPos ]
		].
	] ensure: [  
		captured := false. 
		self changed.
		self currentHand releaseMouseFocus
	 ]
]

{ #category : #'event handling' }
TxSlider >> handlesMouseDown: evt [
	^ evt redButtonPressed
]

{ #category : #initialization }
TxSlider >> initialize [
	super initialize.
	sliderPosition := 0.
	thickness  := 0.1.
	captured := false.
	
	self computeSliderBounds 
]

{ #category : #layout }
TxSlider >> layoutChanged [
	super layoutChanged.
	self computeSliderBounds 
]

{ #category : #settings }
TxSlider >> minimumThicknessInPixels [
	"answer the minimum slider thickness (in pixels), so that slider is large enough on screen to operate with, even if model reports smaller area"
	^ 16
]

{ #category : #'event handling' }
TxSlider >> mouseDown: evt [

	| downPos |
	
	downPos := self mapMouseRelativeToSlider: evt position.
	
	downPos < mappedPosition ifTrue: [ ^ self handleMouseDownAheadOfSlider: evt mappedPosition: downPos ].
	downPos > (mappedPosition + mappedThickness) ifTrue: [ ^ self handleMouseDownAfterSlider: evt  mappedPosition: downPos].
	
	self handleMouseDownOnSlider: evt  mappedPosition: downPos
]

{ #category : #'event handling' }
TxSlider >> mouseUp: evt [

	self stopStepping 
]

{ #category : #'for testing' }
TxSlider >> retreat [

	self sliderPosition: sliderPosition - 0.1
]

{ #category : #settings }
TxSlider >> scrollingDelay [
	"Number of milliseconds between steps while scrolling the slider when user holds the button"
	^ 100
]

{ #category : #protocol }
TxSlider >> sliderColor [
	^ Color lightGray 
]

{ #category : #protocol }
TxSlider >> sliderHighlightColor [
	^ Color lightGray muchLighter  
]

{ #category : #accessing }
TxSlider >> sliderPosition: newValue [

	sliderPosition := newValue min: 1.0 max: 0.0.
	
	self computeSliderBounds.
	self changed
]

{ #category : #accessing }
TxSlider >> thickness: newValue [

	thickness := newValue min: 1.0 max: 0.0.
	
	self computeSliderBounds.
	self changed
]
