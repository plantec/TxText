Class {
	#name : #TxAthensTextTest,
	#superclass : #TestCase,
	#category : #'TxText-AthensTests'
}

{ #category : #private }
TxAthensTextTest >> defaultStrategy [
	^ TxAthensNoWrapStrategy new
]

{ #category : #private }
TxAthensTextTest >> newText: aString [
	| text |
	text := TxModel new.
	text endPosition insert: aString.
	^ text
]

{ #category : #private }
TxAthensTextTest >> newViewOn: aText [ 
	| layoutView |
	layoutView :=  TxAthensLayoutView on: aText extent: self defaultLayoutViewExtent.
	layoutView layoutStrategy: self defaultStrategy.
	^ layoutView
]
