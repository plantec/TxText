"
I represent a view for a portion of text, laid out using the specified layout 
strategy.

The view is defined using the following inputs:

- position in the text
- view extent (width and height)
- surface, which will be used to render the view.

I support rendering via #renderOn:, as well as translating between a view point 
and a text position (but only in the area of the view itself).

The surface is responsible for providing the font renderer, which is used to measure text metrics and lay it out properly using the specified strategy, and keep synchronized with what the renderer produces on the surface.

Please note, that the view's layout is computed only for the portion of text neccessary to display the area visible through the view (unless the text fully fits into it), which makes the view completely independent from the size of the text.

The text layout needs to be adjusted/reset when: 
 - view's text position changes
 - view is scrolled up/down (which indirectly changes view's text position)
 - text is modified
 - layout strategy is changed
 - drawing surface is changed 


"
Class {
	#name : #TxAthensLayoutView,
	#superclass : #Object,
	#instVars : [
		'announcer',
		'extent',
		'layoutStrategy',
		'layout',
		'offset',
		'container'
	],
	#category : #'TxText-Athens'
}

{ #category : #examples }
TxAthensLayoutView class >> example [
	"Open and then zoom in and out"
	
	| sceneView view |
	sceneView := AthensSceneView new.
	view := TxAthensLayoutView on: Morph comment asTxModel extent: 400 @ 400.

	sceneView scene: view.
	sceneView openInWindow
]

{ #category : #'instance creation' }
TxAthensLayoutView class >> on: aTxModel extent: aPoint [
	^ self new
		initWithPosition: aTxModel startPosition extent: aPoint

]

{ #category : #'instance creation' }
TxAthensLayoutView class >> on: aTxModel extent: aPoint container: aContainer [
	^ self new
		container: aContainer;
		initWithPosition: aTxModel startPosition extent: aPoint

]

{ #category : #announcements }
TxAthensLayoutView >> announceViewChanged [

	announcer announce: (TxLayoutViewChanged new view:self).
	container viewChanged: self.
]

{ #category : #accessing }
TxAthensLayoutView >> announcer [
	^ announcer
]

{ #category : #geometry }
TxAthensLayoutView >> compact [
	"remove lines which vent outside of view and no longer visible"
	offset := offset x @ layout compact.
]

{ #category : #accessing }
TxAthensLayoutView >> container [
	^ container
]

{ #category : #accessing }
TxAthensLayoutView >> container: anObject [
	container := anObject
]

{ #category : #'debug rendering' }
TxAthensLayoutView >> debugRenderOn: canvas [

	"
	set up clipping
	- draw line by line
	"
	| renderer |

	canvas
		setStrokePaint: Color green;
		drawShape: (0@0 corner: self extent).

	renderer := TxTextRenderer new.
	renderer renderLines: layout lines on: canvas.
	

]

{ #category : #defaults }
TxAthensLayoutView >> defaultStrategy [
	^  TxAthensNoWrapStrategy  new
]

{ #category : #geometry }
TxAthensLayoutView >> ensurePointWithinLayout: aLayoutPoint [
	"Note, the layout will not extend beyond the actual text"
	[ aLayoutPoint y > layout height ] whileTrue: [ 
		" try to extend layout until we cover given point"
		layout extendOneLineDown ifFalse: [  ^ self ]		
	].

	aLayoutPoint y < 0 ifTrue: [ | y h |
		y := aLayoutPoint y.
		h := layout height.
		layout extendOneLineUp ifFalse: [ ^ self ].
		y := y - (layout height - h).
	 ]
]

{ #category : #'private ' }
TxAthensLayoutView >> extendLayoutDown: delta [
	| y heightExtended |
	y := delta.
	heightExtended := 0.
	"Note, the layout will not extend beyond the actual text"
	[ layout height < (y + extent y) ] whileTrue: [ | h |
		" try to extend layout until we cover given point"
		h := layout height.
		layout extendOneLineDown ifFalse: [ ^ heightExtended ].
		heightExtended := heightExtended + (layout height - h)
	].
	^ heightExtended
	
]

{ #category : #accessing }
TxAthensLayoutView >> extent [
	^ extent
]

{ #category : #accessing }
TxAthensLayoutView >> extent: aPoint [ 
	extent := aPoint.
	self resetLayout.
]

{ #category : #geometry }
TxAthensLayoutView >> fontMetricsProviderFor: aFont [ 

"aFont glyphRendererOn: surface."

	^ CairoFontMetricsProvider new 
			font: aFont ;
			yourself 
]

{ #category : #accessing }
TxAthensLayoutView >> height [
	^ extent y
]

{ #category : #'view notifications' }
TxAthensLayoutView >> hideEmbeddedObject: morph [
	container hideEmbeddedObject: morph
]

{ #category : #initializing }
TxAthensLayoutView >> initWithPosition: aStartPosition extent: aPoint [
	
	
	^ self initWithStrategy: self defaultStrategy position: aStartPosition extent: aPoint
]

{ #category : #initializing }
TxAthensLayoutView >> initWithStrategy: aLayoutStrategy position: aStartPosition extent: aPoint [
	
	offset := 0@0.
	layoutStrategy := aLayoutStrategy.
	extent := aPoint.
	
	self resetLayout: aStartPosition
]

{ #category : #initializing }
TxAthensLayoutView >> initialize [

	offset := 0@0.
	announcer := Announcer new.
	container := TxAthensNullViewContainer new.
]

{ #category : #accessing }
TxAthensLayoutView >> layout [
	^ layout
]

{ #category : #initializing }
TxAthensLayoutView >> layoutIsAboutToReset [

	container layoutIsAboutToResetIn: self
]

{ #category : #geometry }
TxAthensLayoutView >> layoutPositionAt: aTextPosition ifOutside: aBlock [
	"calculate the point at given text position, might return an invalid position (outside the layout)"
	^ self layout positionAt: aTextPosition ifOutside: aBlock
]

{ #category : #accessing }
TxAthensLayoutView >> layoutStrategy [
	^ layoutStrategy
]

{ #category : #accessing }
TxAthensLayoutView >> layoutStrategy: anObject [
	layoutStrategy := anObject.
	self resetLayout.
]

{ #category : #'internal-masking' }
TxAthensLayoutView >> maskCharacters: characters [
	"This is a hook to possibly replace original characters , which _always_ coming from spans during scanning the text
	with something else. This method should answer a string with exactly same number of characters as in provided one.
	Default implementation just answers original characters."
	
	^ characters 
]

{ #category : #testing }
TxAthensLayoutView >> needsHorizontalScrolling [
	"Answer true, if text layout is wider than view , and therefore could use scrolling"
	^ (offset x > 0) or: [ self width < layout width ]
]

{ #category : #testing }
TxAthensLayoutView >> needsVerticalScrolling [
	"Answer true if, vertically, text are not fitting completely inside a view, and may use vertical scrolling.
	
	This is simple: if it fits completely, layout start = text start, layout end = text end
	"
	
	^ (layout startPosition isAtStart and: [ layout endPosition isAtEnd]) not
]

{ #category : #factory }
TxAthensLayoutView >> newEmbeddedObjectCommand: anEmbeddedObjectSpan [

	^ container newEmbeddedObjectCommand: anEmbeddedObjectSpan
]

{ #category : #accessing }
TxAthensLayoutView >> offset [
	^ offset
]

{ #category : #'private ' }
TxAthensLayoutView >> privSetVerticalOffset: y [

	offset := offset x @ y
]

{ #category : #rendering }
TxAthensLayoutView >> renderHighlight: anInterval with: paint on: canvas [

	| renderer |
	renderer := TxHighlightRenderer highlighting: anInterval in: self with: paint.
	renderer renderHighlightOn: canvas.
]

{ #category : #rendering }
TxAthensLayoutView >> renderOn: canvas [

	"
	set up clipping
	- draw line by line
	"
	| renderer |

	canvas pathTransform restoreAfter: [
		canvas pathTransform translateBy: offset negated.
			
		renderer := TxTextRenderer new.
		renderer renderLines: layout lines on: canvas.
	
	]
]

{ #category : #initializing }
TxAthensLayoutView >> resetLayout [

	^ self resetLayout: layout startPosition.
]

{ #category : #initializing }
TxAthensLayoutView >> resetLayout: startPosition [
	| pos |
	
	"Always align with line start"
	self layoutIsAboutToReset.
	
	pos := startPosition asPosition moveToLineStart.	
	pos span prev isAtStart ifTrue: [ pos := pos moveLeft ].

	layout := TxAthensLayout new view: self.
	layout initializePosition: pos strategy: layoutStrategy.
	
	"Keep scanning until it's enough to fill the view"
	[  		
		extent y + offset y > layout height
	] whileTrue: [ 
		"or nothing more to scan"

		layout extendOneLineDown ifFalse: [ ^ self announceViewChanged ] .	
	].

	self announceViewChanged
]

{ #category : #scrolling }
TxAthensLayoutView >> scrollBy: aPoint [
	"Scroll receiver by some offset"
	| x y  |
	
	x := offset x + aPoint x.
	y := offset y + aPoint y.


	[y < 0] whileTrue: [ | h |
		h := layout height.
		y := layout extendOneLineUp 
			ifFalse: [ 0 ]
			ifTrue: [ y + (layout height - h) ].
	 ].

	aPoint y > 0 ifTrue: [
		self extendLayoutDown: y ].

	"Don't scroll beyond layout"
	x := (x min: layout width - extent x) max: 0. 
	y := (y min: layout height - extent y) max: 0.

	offset := x@y.	
	self compact.
	self announceViewChanged.
]

{ #category : #scrolling }
TxAthensLayoutView >> scrollIntoView: aTextPosition margin: visibleMargin [

	"Scroll the view so, that given position is fully visible inside a view.
	The margin controls the minimal offset from view border and given position.
	"
	
	"Simple case first: position is inside a layout"
	| margin |
	
	margin := visibleMargin asMargin.
	
	(layout interval contains: aTextPosition) ifTrue: [ 
		
		| layoutPos deltaX newXOffset deltaY newYOffset |
	
		layoutPos := self layoutPositionAt: aTextPosition ifOutside: [  self error: 'should not happen' ].
		
		deltaX := layoutPos horizontalOffset - offset x. 
		
		newXOffset := offset x.
		"position to the left from current view"
		deltaX < margin left 
			ifTrue: [ 
				 newXOffset := layoutPos horizontalOffset - margin left ].

		"position to the right from current view"
		deltaX > (self width - margin right)
			ifTrue: [ newXOffset := layoutPos horizontalOffset - self width + margin right  ].
		
		"Just to be sure, check side constraints"
		newXOffset + self width > (layout extent x + margin right) ifTrue: [ 
			newXOffset := layout extent x + margin right - self width ].
		newXOffset < 0 ifTrue: [  newXOffset := 0 ].

		"now check vertical offset(s)"
		newYOffset := offset y.
		deltaY := layoutPos bottomPointInView y + margin bottom - self height. 
		deltaY > 0 ifTrue: [ 
			newYOffset := layoutPos bottomPoint y + margin bottom - self height.
			 ].
		
		deltaY := layoutPos topPoint y.
		deltaY < newYOffset ifTrue: [ newYOffset := deltaY ].
		
		offset := newXOffset @ newYOffset.	
		"make sure layout fully covers the view after scrolling"
		self ensurePointWithinLayout: (0@(offset y + self height)).
		self ensurePointWithinLayout: (0@offset y).
		"compact the layout"
		self compact. 
			
	] ifFalse: [  | repeat |
		repeat := true.
		"position is outside of current layout"
		aTextPosition > layout endPosition ifTrue: [ 
			[repeat and: [aTextPosition > layout endPosition] ] 
				whileTrue: [ repeat := layout extendOneLineDown ]
		] ifFalse: [ 
			[repeat and: [aTextPosition < layout startPosition]] 
				whileTrue: [ repeat := layout extendOneLineUp ]
		 ].
		"repeat"
		repeat ifTrue: [ ^ self scrollIntoView: aTextPosition margin: visibleMargin ]
	].

	self announceViewChanged.

]

{ #category : #accessing }
TxAthensLayoutView >> text [
	^ layout text
]

{ #category : #geometry }
TxAthensLayoutView >> textPositionAt: aPoint [
	"Answer the text position closest to given point in view"
	^ self layout textPositionAt: aPoint + offset 
]

{ #category : #accessing }
TxAthensLayoutView >> visibleArea [
	"Answer the approximate x@y portion of text currently visible in the view in terms of fraction 0..1"
	

	| x y |
	x := layout width / self width.
	y := self text numberOfLines / (layout endPosition lineNumber - layout startPosition lineNumber).
	
	^ x@y
]

{ #category : #accessing }
TxAthensLayoutView >> width [
	^ extent x
]
