"
i represent the cached visual layout of given text.

Note, that layout is considered a private information maintained by concerete view, and not accessible (userful) without having a view.


"
Class {
	#name : #TxAthensLayout,
	#superclass : #Object,
	#instVars : [
		'extent',
		'lines',
		'view',
		'strategy',
		'tabWidth'
	],
	#category : #'TxText-Athens'
}

{ #category : #scanning }
TxAthensLayout >> addLine: newLine [

	lines add: newLine.
	extent := (extent x max: newLine width) @ (extent y + newLine height)
]

{ #category : #accessing }
TxAthensLayout >> commandForPosition: aTextPosition ifOutside: aBlock [
	"Answer the display command which correspond to given text position in layout,
	or evaluate block if layout does not contains given position"
	
	lines do: [:line |
		(line interval contains: aTextPosition) ifTrue: [ 
			^ line commandForPosition: aTextPosition ifOutside: aBlock ]
	].

	^ aBlock value
]

{ #category : #private }
TxAthensLayout >> compact [
	"Remove lines outside of view, answer updated view's vertical offset"
	| viewOffsetY line height linesToKeep oldLines |
	viewOffsetY := view offset y.
	
	[ line := lines first. viewOffsetY > line height ] whileTrue: [ 
		lines removeFirst notifyRemovedFrom: self. 
		viewOffsetY := viewOffsetY - line height.
	].
	
	height := 0.
	linesToKeep := lines count: [ :each |
		height := height + each height.
		height - viewOffsetY < view extent y
		 ].
	linesToKeep := (linesToKeep +1) min: lines size.
	oldLines := lines allButFirst: linesToKeep.
	lines := lines first: linesToKeep.
	oldLines do: [ :each | each notifyRemovedFrom: self ].

	self updateExtent.

	^ viewOffsetY

]

{ #category : #accessing }
TxAthensLayout >> endPosition [
	^ lines last endPosition
]

{ #category : #scanning }
TxAthensLayout >> extendOneLineDown [
	
	"Extend layout to the bottom, by scanning one more visual line.
	Answer true if new line was added due to scanning..
	or false, if there's nothing left to scan (end of text) "
	| pos newLine |
	
	pos := self endPosition.
	pos isAtEnd ifTrue: [ ^ false ].

	"if end position is at line separator, advance to next line"
	(pos span isLineSeparator and: [ pos isAtSpanStart ]) ifTrue: [  pos := pos nextPosition ].
	
	newLine := strategy scanSingleVisualLineFor: self startingAt: pos.
	lines add: newLine.
	extent := (extent x max: newLine width) @ (extent y + newLine height).
	
	^ true.
]

{ #category : #scanning }
TxAthensLayout >> extendOneLineUp [
	
	| pos newLine extraLines h |
	
	pos := self startPosition.
	
	pos isAtStart ifTrue: [ ^ false ].
		
	pos := self startPosition moveUp moveToLineStart.
	
	extraLines := OrderedCollection new.
	
	[ 
		newLine := strategy scanSingleVisualLineFor: self startingAt: pos.	
		extraLines add: newLine.
		
		"if end position is at line separator, advance to next line"
		pos := newLine endPosition.
		(pos span isLineSeparator and: [ pos isAtSpanStart ]) ifTrue: [  pos := pos nextPosition ].
		pos = self startPosition
	] whileFalse.

	h := extent y.
	extraLines reverseDo: [ :line |
		lines addFirst: line.
		extent := (extent x max: line width) @ (extent y + line height).
	].
	
	view privSetVerticalOffset: view offset y + (extent y - h).
	
	^ true.
]

{ #category : #geometry }
TxAthensLayout >> extent [
	^ extent
]

{ #category : #geometry }
TxAthensLayout >> fontMetricsProviderFor: aFont [ 
	^ view fontMetricsProviderFor: aFont 
]

{ #category : #accessing }
TxAthensLayout >> height [
	^ extent y 
]

{ #category : #'view notifications' }
TxAthensLayout >> hideEmbeddedObject: morph [
	^ view hideEmbeddedObject: morph
]

{ #category : #'initialize-release' }
TxAthensLayout >> initialize [
	lines := OrderedCollection new.
	extent := 0@0.
]

{ #category : #'initialize-release' }
TxAthensLayout >> initializePosition: pos strategy: layoutStrategy [
	"initialize layout and scan a single line using given strategy"
	| line |
	
	lines := OrderedCollection new.
	strategy := layoutStrategy.

	line := strategy scanSingleVisualLineFor: self startingAt: pos.
	
	self setLines: { line }
]

{ #category : #accessing }
TxAthensLayout >> interval [
	^ lines first startPosition to: lines last endPosition
]

{ #category : #testing }
TxAthensLayout >> isWellFormed [
	"check that every position within the receiver interval corresponds to some line "

	| pos end |

	pos := self startPosition.
	end := self endPosition.
	
	[ pos <= end ] whileTrue: [ 
		self positionAt: pos ifOutside: [ ^ false ].
		pos := pos nextPosition.
	 ].
	^ true.
]

{ #category : #accessing }
TxAthensLayout >> lines [
	^ lines
]

{ #category : #factory }
TxAthensLayout >> newEmbeddedObjectCommand: anEmbeddedObjectSpan [

	^ self view newEmbeddedObjectCommand: anEmbeddedObjectSpan
]

{ #category : #accessing }
TxAthensLayout >> numberOfLines [
	^ lines size
]

{ #category : #geometry }
TxAthensLayout >> positionAt: aTextPosition ifOutside: aBlock [
	(self interval contains: aTextPosition)
		ifTrue:[ ^ TxAthensLayoutPosition textPosition: aTextPosition layout: self ] 
		ifFalse: [  ^ aBlock value ].
		 

]

{ #category : #accessing }
TxAthensLayout >> setLines: newLines [

	lines := newLines asOrderedCollection.
	self updateExtent.
]

{ #category : #accessing }
TxAthensLayout >> startPosition [
	^ lines first startPosition
]

{ #category : #accessing }
TxAthensLayout >> tabWidthUsingFont: aFont [
	"Initialize tab width based on first attempt to use it in text (therefore it will use font metrics of font used in character span, where tab has occured).
	The tab width is then considered same for whole layout, regardless of font size/font metrics used by any other tabs.
	"
	| metricsProvider |

	tabWidth ifNotNil: [ ^ tabWidth ].

	metricsProvider := self fontMetricsProviderFor: aFont.
	"Take arbitrary number and multiply it by 8.. this is how you get the tab width! "
	^ tabWidth := (metricsProvider getGlyphWidth: Character space) * 8.

]

{ #category : #accessing }
TxAthensLayout >> text [
	^ self startPosition text
]

{ #category : #geometry }
TxAthensLayout >> textPositionAt: aPoint [
	| line height index |
	self numberOfLines = 0
		ifTrue: [ ^ 0 ].	"find the line under the aPoint y by: accumulating the heights starting from the first line of the layout,  till we reach the Y of the point"
	aPoint y <= 0
		ifTrue: [ ^ lines first textPositionAtHorizontalOffset: aPoint x ].
	height := 0.
	index := 1.
	[ index <= lines size and: [ height < aPoint y ] ]
		whileTrue: [ 
			line := lines at: index.
			height := height + line height.
			index := index + 1 ].
	index > lines size
		ifTrue: [ ^ lines last textPositionAtHorizontalOffset: aPoint x ].
	^ line textPositionAtHorizontalOffset: aPoint x
]

{ #category : #private }
TxAthensLayout >> updateExtent [
	"Recalculate the current extent, based on lines width"
	| x y |
	
	x := y := 0.
	lines do: [:each |
		x := x max: each width.
		y := y + each height.
	].

	extent := x@y
]

{ #category : #accessing }
TxAthensLayout >> view [
	^ view
]

{ #category : #accessing }
TxAthensLayout >> view: aLayoutView [
	view := aLayoutView
]

{ #category : #accessing }
TxAthensLayout >> width [
	^ extent x
]
