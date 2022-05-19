"
I represent a selection interval of a text.
"
Class {
	#name : #TxSelection,
	#superclass : #TxInterval,
	#category : #'TxText-Model'
}

{ #category : #operations }
TxSelection >> all [
	self beSelection.
	start moveToStart.
	end moveToEnd.
]

{ #category : #operations }
TxSelection >> applyAttribute: anAttribute [

	self text applyAttribute: anAttribute onSelection: self.
]

{ #category : #operations }
TxSelection >> backspaceKey [
	"behave as if user pressed the Backspace key"
	
	self isEmpty ifTrue: [ 
		self beSelection. 
		start moveLeft ].
	self cut
]

{ #category : #operations }
TxSelection >> beCursor [

	self collapse
]

{ #category : #operations }
TxSelection >> beSelection [
	"make sure that start and end are distinct objects,
	so when you start moving one, you don't move the other one"
	end == start ifTrue: [ end := start copy ]
]

{ #category : #operations }
TxSelection >> collapse [

	"collapse the selection (making start == end)"
	
	start position: end position.
]

{ #category : #operations }
TxSelection >> cut [
	
	"Delete the portion of text selected by receiver.
	Note, the receiver is in collapsed state afterwards!"
	| position |
	
	position := self text delete: self.
	self 
		start: position;
		end:  position.
]

{ #category : #operations }
TxSelection >> delete [
	self cut
]

{ #category : #operations }
TxSelection >> deleteKey [
	"behave as if user pressed the Delete key"
	
	self isEmpty ifTrue: [ 
		self beSelection. 
		end moveRight ].
	self cut
]

{ #category : #accessing }
TxSelection >> end: aPosition [
	end position: aPosition asPosition
]

{ #category : #initialization }
TxSelection >> initStart: startPosition end: endPosition [

	start := startPosition asCursor.
	end := endPosition asCursor 
]

{ #category : #testing }
TxSelection >> isCursor [

	^ end == start
]

{ #category : #debugging }
TxSelection >> isValid [
	^ start isValid and: [ end isValid ]
]

{ #category : #operations }
TxSelection >> none [
	self collapse.
]

{ #category : #copying }
TxSelection >> postCopy [
	start := start copy.
	end := end copy.

]

{ #category : #helpers }
TxSelection >> preservePositionsDuring: aBlock [
	"Restore start and end after evaluating a block, using slow text index calculation"
	
	| startPos endPos |
	
	startPos := start asTextIndex.
	endPos := end asTextIndex.
	
	aBlock ensure: [
		start position: (self text positionAtTextIndex: startPos).
		end position: (self text positionAtTextIndex: endPos).
	]. 
]

{ #category : #operations }
TxSelection >> replaceWith: aString [

	self cut.
	self end insert: aString.
	start moveTo: end
]

{ #category : #accessing }
TxSelection >> start: aPosition [
	start position: aPosition asPosition
]
