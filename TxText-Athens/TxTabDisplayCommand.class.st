Class {
	#name : #TxTabDisplayCommand,
	#superclass : #TxCharacterSpanDisplayCommand,
	#category : #'TxText-Athens'
}

{ #category : #geometry }
TxTabDisplayCommand >> horizontalAdvanceUpTo: aTextPosition layout: aTextLayout [

	^ stop > aTextPosition spanPosition
		ifTrue: [ 0 ] 
		ifFalse: [ advance x ]

]

{ #category : #rendering }
TxTabDisplayCommand >> renderOn: renderer [

	renderer advance:advance.
]

{ #category : #geometry }
TxTabDisplayCommand >> textPositionForHorizontalOffset: anOffset layout: layout [

	"Tab is a single unbreakable space, return start if offset closer to tab starting position, or end otherwise"
	^ anOffset < (advance x/2) 
		ifTrue: [ span positionAt: start ]
		ifFalse: [ span positionAt: stop ]

]
