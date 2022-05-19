Class {
	#name : #TxLayoutViewElement,
	#superclass : #TxBasicViewElement,
	#instVars : [
		'layoutView'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #drawing }
TxLayoutViewElement >> drawOnSpartaCanvas: aCanvas [
	"Before rendering, transform from global coordinates (Morphic) to relative coordinates (Athens)"

	super drawOnSpartaCanvas: aCanvas.
	layoutView renderOn: aCanvas
]

{ #category : #geometry }
TxLayoutViewElement >> ensurePointWithinLayout: aLayoutPoint [
	^ layoutView ensurePointWithinLayout: aLayoutPoint
]

{ #category : #'view notifications' }
TxLayoutViewElement >> hideEmbeddedObject: anElement [
	anElement parent removeChild: anElement.
]

{ #category : #initialization }
TxLayoutViewElement >> initializeText: aTxModel [ 
	layoutView := TxAthensLayoutView new.
	layoutView container: self.
	layoutView initWithPosition: aTxModel startPosition extent: self extent. 
]

{ #category : #'view notifications' }
TxLayoutViewElement >> layoutIsAboutToResetIn: view [
	"ignored"
	self resetChildrenArray. 
]

{ #category : #geometry }
TxLayoutViewElement >> layoutPositionAt: aTextPosition ifOutside: aBlock [ 
	^ layoutView layoutPositionAt: aTextPosition ifOutside: aBlock
]

{ #category : #accessing }
TxLayoutViewElement >> layoutStrategy: aStrategy [

	layoutView layoutStrategy: aStrategy.
	self requestLayout.
]

{ #category : #accessing }
TxLayoutViewElement >> layoutView [
	^ layoutView
]

{ #category : #factory }
TxLayoutViewElement >> newEmbeddedObjectCommand: aTxEmbeddedObjectSpan [ 
	| morph |
	morph := TxWrappingMorph for: (aTxEmbeddedObjectSpan object asMorph).
	self registerEmbeddedMorph: morph.
	
	^ TxEmbeddedObjectCommand new 
		span: aTxEmbeddedObjectSpan;
		morph: morph;
		yourself
]

{ #category : #drawing }
TxLayoutViewElement >> onLayoutDone [ 
	
	self size ~= layoutView extent ifTrue: [ layoutView extent: self size ].
	super onLayoutDone 
]

{ #category : #'morphic geometry' }
TxLayoutViewElement >> privateFullMoveBy: delta [
	"Private! Relocate me and all of my subMorphs by recursion. Subclasses that implement different coordinate systems may override this method."
	self relocate: self position + delta 

]

{ #category : #'view notifications' }
TxLayoutViewElement >> registerEmbeddedElement: aTxWrappingElement [

	self addChild: aTxWrappingElement
]

{ #category : #updating }
TxLayoutViewElement >> resetLayout [
	layoutView resetLayout.
	self requestLayout 
]

{ #category : #updating }
TxLayoutViewElement >> resetViewTo: startPosition [

	layoutView resetLayout: startPosition.
	self invalidate.
]

{ #category : #updating }
TxLayoutViewElement >> scrollBy: aPoint [ 
	layoutView scrollBy: aPoint.
	self invalidate.
]

{ #category : #updating }
TxLayoutViewElement >> scrollIntoView: aTextPosition [
	^ self scrollIntoView: aTextPosition margin: 0
]

{ #category : #updating }
TxLayoutViewElement >> scrollIntoView: aTextPosition margin: visibleMargin [
	layoutView scrollIntoView: aTextPosition margin: visibleMargin.
	self invalidate.
]

{ #category : #accessing }
TxLayoutViewElement >> text [
	^ layoutView text 
]

{ #category : #geometry }
TxLayoutViewElement >> textPositionAt:  aPoint [  
	^ layoutView textPositionAt:  aPoint
]

{ #category : #'view notifications' }
TxLayoutViewElement >> viewChanged: aTxAthensLayoutView [ 
	self invalidate.
]
