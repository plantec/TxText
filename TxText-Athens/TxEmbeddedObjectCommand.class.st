Class {
	#name : #TxEmbeddedObjectCommand,
	#superclass : #TxDisplayCommand,
	#instVars : [
		'span',
		'morph'
	],
	#category : #'TxText-Athens'
}

{ #category : #accessing }
TxEmbeddedObjectCommand >> advance [
	^ self width @ 0
]

{ #category : #testing }
TxEmbeddedObjectCommand >> contains: aTextPosition [

	^ aTextPosition span == span 
]

{ #category : #accessing }
TxEmbeddedObjectCommand >> height [
	^ self morph height
]

{ #category : #geometry }
TxEmbeddedObjectCommand >> horizontalAdvanceUpTo: aTextPosition layout: aTextLayout [

	^ aTextPosition spanPosition = 0 
		ifTrue:[ 0 ]
		ifFalse: [ self morph width ]
]

{ #category : #accessing }
TxEmbeddedObjectCommand >> morph [
	^ morph
]

{ #category : #accessing }
TxEmbeddedObjectCommand >> morph: aMorph [
	morph := aMorph
]

{ #category : #notification }
TxEmbeddedObjectCommand >> notifyRemovedFrom: layout [ 
	^ layout hideEmbeddedObject: morph
]

{ #category : #rendering }
TxEmbeddedObjectCommand >> renderOn: renderer [

	renderer 
		renderMorph: self morph;
		advance: self advance.
]

{ #category : #accessing }
TxEmbeddedObjectCommand >> span [
	^ span
]

{ #category : #accessing }
TxEmbeddedObjectCommand >> span: anObject [
	span := anObject
]

{ #category : #accessing }
TxEmbeddedObjectCommand >> startPosition [
	^ span startPosition
]

{ #category : #geometry }
TxEmbeddedObjectCommand >> textPositionForHorizontalOffset: anOffset layout: layout [

	^ anOffset < (self advance x/2) 
		ifTrue: [ span startPosition ]
		ifFalse: [ span endPosition ]
	
]

{ #category : #accessing }
TxEmbeddedObjectCommand >> width [
	^ self morph width
]
