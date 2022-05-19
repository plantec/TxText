Class {
	#name : #TxLayoutViewMorph,
	#superclass : #TxBasicViewMorph,
	#instVars : [
		'layoutView'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #'morphic geometry' }
TxLayoutViewMorph >> containsPoint: aPoint [
	^ bounds containsPoint: aPoint
]

{ #category : #drawing }
TxLayoutViewMorph >> drawOn: aCanvas [
	"do nothing"
]

{ #category : #drawing }
TxLayoutViewMorph >> drawOnAthensCanvas: aCanvas [
	"Before rendering, transform from global coordinates (Morphic) to relative coordinates (Athens)"

	aCanvas pathTransform restoreAfter: [ 
		aCanvas pathTransform translateBy: self innerBounds origin.
		layoutView renderOn: aCanvas ].
]

{ #category : #geometry }
TxLayoutViewMorph >> ensurePointWithinLayout: aLayoutPoint [
	^ layoutView ensurePointWithinLayout: aLayoutPoint
]

{ #category : #'view notifications' }
TxLayoutViewMorph >> hideEmbeddedObject: morph [
	morph delete.
]

{ #category : #initialization }
TxLayoutViewMorph >> initializeText: aTxModel [ 
	layoutView := TxAthensLayoutView new.
	layoutView container: self.
	layoutView initWithPosition: aTxModel startPosition extent: self extent. 
]

{ #category : #'morphic geometry' }
TxLayoutViewMorph >> invalidRect: damageRect from: aMorph [
	"Translate damage reports from submorphs by the scrollOffset."
	aMorph == self
		ifTrue: [super invalidRect: damageRect from: self]
		ifFalse: [ | globalDamageRect myDamageRect |
			globalDamageRect := self transform localBoundsToGlobal: damageRect.
			myDamageRect := globalDamageRect intersect: bounds ifNone: [ ^ self ].
			super invalidRect: (myDamageRect expandBy: 1) from: self]

]

{ #category : #drawing }
TxLayoutViewMorph >> layoutChanged [
	
	self extent ~= layoutView extent ifTrue: [ layoutView extent: self extent ].
	super layoutChanged
]

{ #category : #'view notifications' }
TxLayoutViewMorph >> layoutIsAboutToResetIn: view [
	"ignored"
	submorphs := #().
]

{ #category : #geometry }
TxLayoutViewMorph >> layoutPositionAt: aTextPosition ifOutside: aBlock [ 
	^ layoutView layoutPositionAt: aTextPosition ifOutside: aBlock
]

{ #category : #accessing }
TxLayoutViewMorph >> layoutStrategy: aStrategy [

	layoutView layoutStrategy: aStrategy.
	self layoutChanged.
]

{ #category : #accessing }
TxLayoutViewMorph >> layoutView [
	^ layoutView
]

{ #category : #factory }
TxLayoutViewMorph >> newEmbeddedObjectCommand: aTxEmbeddedObjectSpan [ 
	| morph |
	morph := TxWrappingMorph for: (aTxEmbeddedObjectSpan object asMorph).
	self registerEmbeddedMorph: morph.
	
	^ TxEmbeddedObjectCommand new 
		span: aTxEmbeddedObjectSpan;
		morph: morph;
		yourself
]

{ #category : #'morphic geometry' }
TxLayoutViewMorph >> privateFullMoveBy: delta [
	"Private! Relocate me and all of my subMorphs by recursion. Subclasses that implement different coordinate systems may override this method."
	self privateMoveBy: delta.

]

{ #category : #'view notifications' }
TxLayoutViewMorph >> registerEmbeddedMorph: aTxWrappingMorph [ 

	self addMorph: aTxWrappingMorph
]

{ #category : #updating }
TxLayoutViewMorph >> resetLayout [
	layoutView resetLayout.
	self changed.
]

{ #category : #updating }
TxLayoutViewMorph >> resetViewTo: startPosition [

	layoutView resetLayout: startPosition.
	self changed.
]

{ #category : #updating }
TxLayoutViewMorph >> scrollBy: aPoint [ 
	layoutView scrollBy: aPoint.
	self changed.
]

{ #category : #updating }
TxLayoutViewMorph >> scrollIntoView: aTextPosition [
	^ self scrollIntoView: aTextPosition margin: 0
]

{ #category : #updating }
TxLayoutViewMorph >> scrollIntoView: aTextPosition margin: visibleMargin [
	layoutView scrollIntoView: aTextPosition margin: visibleMargin.
	self changed.
]

{ #category : #accessing }
TxLayoutViewMorph >> text [
	^ layoutView text 
]

{ #category : #geometry }
TxLayoutViewMorph >> textPositionAt:  aPoint [  
	^ layoutView textPositionAt:  aPoint
]

{ #category : #'morphic geometry' }
TxLayoutViewMorph >> transform [
	
	^ MorphicTransform offset: bounds topLeft negated + layoutView offset
]

{ #category : #'morphic geometry' }
TxLayoutViewMorph >> transformFrom: uberMorph [
	"my local coordinate system is in sync with text layout"
	
	(owner isNil or: [self == uberMorph]) ifTrue: [^self transform].
	^(owner transformFrom: uberMorph) composedWithLocal: self transform
]

{ #category : #updating }
TxLayoutViewMorph >> updateMorph [
	layoutView resetLayout.
	self changed.
	
]

{ #category : #'view notifications' }
TxLayoutViewMorph >> viewChanged: aTxAthensLayoutView [ 
	self changed.
]
