Class {
	#name : #TxHighlightRendererTest,
	#superclass : #TxAthensLayoutTest,
	#instVars : [
		'isPaintSet',
		'drawnShapes',
		'interval',
		'renderer'
	],
	#category : #'TxText-AthensTests'
}

{ #category : #asserting }
TxHighlightRendererTest >> assertRectangle: rectangleNumber coversFullViewWidthOfLine: lineNumber [
	"When a highlighted line is not the first or the last, highlight from view left to view right"

	| line rectangle expectedStart expectedEndPoint lineEndPosition |
	line := view layout lines at: lineNumber.
	rectangle := drawnShapes at: rectangleNumber.
	expectedStart := view layout positionAt: line startPosition ifOutside: [ self fail ].
	self assert: rectangle topLeft equals: expectedStart topPoint.
	lineEndPosition := view layout positionAt: line endPosition ifOutside: [ self fail ].
	expectedEndPoint := view width @ lineEndPosition bottomPoint y.
	self assert: rectangle bottomRight equals: expectedEndPoint.
]

{ #category : #asserting }
TxHighlightRendererTest >> assertRectangle: rectangleNumber coversLeftPartOfLine: lineNumber [
	"For the last line of a multi-line highlight, cover from the start of the line to the end of the selection"

	| line rectangle expectedStart expectedEnd |
	line := view layout lines at: lineNumber.
	rectangle := drawnShapes at: rectangleNumber.
	expectedStart := view layout positionAt: line startPosition ifOutside: [ self fail ].
	self assert: rectangle topLeft equals: expectedStart topPoint.
	expectedEnd := view layout positionAt: interval end ifOutside: [ self fail ].
	self assert: rectangle bottomRight equals: expectedEnd bottomPoint.
]

{ #category : #asserting }
TxHighlightRendererTest >> assertRectangle: rectangleNumber coversRightPartOfLine: lineNumber [ 
	"For the first line of a multi-line highlight, cover from the start of the selection to the right side of the view"

	| line rectangle expectedStart expectedEndPoint lineEndPosition |
	line := view layout lines at: lineNumber.
	rectangle := drawnShapes at: rectangleNumber.
	expectedStart := view layout positionAt: interval start ifOutside: [ self fail ].
	self assert: rectangle topLeft equals: expectedStart topPoint.
	lineEndPosition := view layout positionAt: line endPosition ifOutside: [ self fail ].
	expectedEndPoint := view width @ lineEndPosition bottomPoint y.
	self assert: rectangle bottomRight equals: expectedEndPoint.
]

{ #category : #asserting }
TxHighlightRendererTest >> assertRectangleCoversMiddleOfLine: aNumber [
	"For a single line selection, simply from the start to end of the selection should be highlighted"

	| expectedStart expectedEnd |
	expectedStart := view layout positionAt: interval start ifOutside: [ self fail ].
	self assert: drawnShapes first topLeft equals: expectedStart topPoint.
	
	expectedEnd := view layout positionAt: interval end ifOutside: [ self fail ].
	self assert: drawnShapes first bottomRight equals: expectedEnd bottomPoint.
]

{ #category : #canvas }
TxHighlightRendererTest >> drawShape: aRectangle [ 

	drawnShapes add: aRectangle.
]

{ #category : #helpers }
TxHighlightRendererTest >> initializeRendererWithIntervalFrom: startTextPosition to: endTextPosition [
	
	interval := startTextPosition to: endTextPosition.
	renderer := TxHighlightRenderer highlighting: interval in: view with: nil.
]

{ #category : #canvas }
TxHighlightRendererTest >> pathTransform [

]

{ #category : #canvas }
TxHighlightRendererTest >> restoreAfter: aBlock [

	aBlock value.
]

{ #category : #canvas }
TxHighlightRendererTest >> setPaint: anObject [

	isPaintSet := true.
]

{ #category : #running }
TxHighlightRendererTest >> setUp [

	super setUp.
	drawnShapes := OrderedCollection new.
	isPaintSet := false.
]

{ #category : #tests }
TxHighlightRendererTest >> testHighlightMoreThanTwoLines [
	"Where the selection is totally inside the layout"
	
	self 
		initializeRendererWithIntervalFrom: view text startPosition + 1
		to: view text startPosition moveDown moveDown + 5.
		
	renderer renderHighlightOn: self.

	self assert: drawnShapes size equals: 3.
	self assertRectangle: 1 coversRightPartOfLine: 1.
	self assertRectangle: 2 coversFullViewWidthOfLine: 2.
	self assertRectangle: 3 coversLeftPartOfLine: 3.
]

{ #category : #tests }
TxHighlightRendererTest >> testHighlightPartialLine [
	"Where the selection is totally inside the layout"

	self 
		initializeRendererWithIntervalFrom: view text startPosition + 1
		to: view text startPosition + 5.
		
	renderer renderHighlightOn: self.

	self assert: drawnShapes size equals: 1.
	self assertRectangleCoversMiddleOfLine: 1.
]

{ #category : #tests }
TxHighlightRendererTest >> testHighlightTwoLines [
	"For a sample interval which is on two lines, which are totally inside the layout, the following should be highlighted:
		- first line from interval start to view width
		- second line from line start to interval end"
		
	self 
		initializeRendererWithIntervalFrom: view text startPosition + 1
		to: view text startPosition moveDown + 5.
		
	renderer renderHighlightOn: self.

	self assert: drawnShapes size equals: 2.	
	self assertRectangle: 1 coversRightPartOfLine: 1.
	self assertRectangle: 2 coversLeftPartOfLine: 2.
]

{ #category : #tests }
TxHighlightRendererTest >> testHighlightsOnlyFromLayoutStartPosition [
	"For a sample interval whose start is before the layout start, the highlight should start from the layout start"
		
	self 
		initializeRendererWithIntervalFrom: view text startPosition + 1
		to: view text startPosition moveDown + 5.
		
	view scrollBy: 0 @ self layout lines first height + 1.
		
	renderer renderHighlightOn: self.

	"Assert first line, which is out of view, is not highlighted"
	self assert: drawnShapes size equals: 1.
	self assertRectangle: 1 coversLeftPartOfLine: 1. "From the layout's perspective, 1 is the first one visible e.g. the second line in our selection"
]

{ #category : #tests }
TxHighlightRendererTest >> testHighlightsOnlyToLayoutEndPosition [
	"For a sample interval whose end is after the layout end, the highlight should end at the layout end"
	
	| lastVisibleLine lastVisibleLineIndex |
	lastVisibleLine := self layout lines last.
	lastVisibleLineIndex := self layout lines size.
	self 
		initializeRendererWithIntervalFrom: lastVisibleLine startPosition + 1
		to: lastVisibleLine endPosition moveDown moveToLineEnd.

	renderer renderHighlightOn: self.

	"Assert second line, which is out of view, is not highlighted"
	self assert: drawnShapes size equals: 1.
	self assertRectangle: 1 coversRightPartOfLine: lastVisibleLineIndex.
]

{ #category : #tests }
TxHighlightRendererTest >> testNoHighlightIfOutOfView [
	
	| lastVisibleLine lastVisibleLineIndex |
	lastVisibleLine := self layout lines last.
	lastVisibleLineIndex := self layout lines size.
	self 
		initializeRendererWithIntervalFrom: lastVisibleLine startPosition moveDown + 1
		to: lastVisibleLine endPosition moveDown moveDown moveToLineEnd.

	renderer renderHighlightOn: self.

	self assert: drawnShapes isEmpty.
]

{ #category : #canvas }
TxHighlightRendererTest >> translateBy: aPoint [ 

]
