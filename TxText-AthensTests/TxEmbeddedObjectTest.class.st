Class {
	#name : #TxEmbeddedObjectTest,
	#superclass : #TxAthensLayoutTest,
	#category : #'TxText-AthensTests'
}

{ #category : #'as yet unclassified' }
TxEmbeddedObjectTest >> testBuildingLayoutWithObject [
	(text startPosition moveRight: 5) insertObject: Object new.

	"null containers don't allow embedded objects"
	self should: [ view resetLayout ] raise: Error.

	
]

{ #category : #'as yet unclassified' }
TxEmbeddedObjectTest >> testInsertingObject [
	| theObject  newPosition |
	theObject := Object new.
	newPosition := (text startPosition moveRight:5) insertObject: theObject.
	
	self assert: (newPosition moveLeft: 5) isAtStart not.
	self assert: (newPosition moveLeft: 6) isAtStart.
	

	
]
