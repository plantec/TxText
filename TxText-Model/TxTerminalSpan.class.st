"
I represent either the start or end of text.

My size is always ZERO and i have only a single valid position (spanPosition = 0)
"
Class {
	#name : #TxTerminalSpan,
	#superclass : #TxBasicSpan,
	#category : #'TxText-Model'
}

{ #category : #attributes }
TxTerminalSpan >> applyAttribute: anAttribute from: startPosition to: endPosition [
	^ self
]

{ #category : #converting }
TxTerminalSpan >> asStringOn: aStream startingAt: index [
	"i am empty"
	^ self
]

{ #category : #converting }
TxTerminalSpan >> asStringOn: aStream startingAt: startIndex upTo: endIndex [
	"i am empty"
	^ self
]

{ #category : #'accessing-text position' }
TxTerminalSpan >> endPosition [
	^ self positionAt: 0
]

{ #category : #testing }
TxTerminalSpan >> isLastPosition: aNumber [
	^ aNumber = 0
]

{ #category : #operations }
TxTerminalSpan >> mergeUpTo: aTxEndSpan [ 
	^ self
]

{ #category : #'accessing-text position' }
TxTerminalSpan >> positionAt: index [
	index ~= 0 ifTrue:  [self error: 'invalid position' ].
	
	^ super positionAt: 0
]

{ #category : #'accessing-text position' }
TxTerminalSpan >> replaceAttributes: newAttributes [
	"replace receiver's attributes by copying from given one"
	^ self
]

{ #category : #accessing }
TxTerminalSpan >> size [
	^ 0
]

{ #category : #'accessing-text position' }
TxTerminalSpan >> startPosition [
	^ self positionAt: 0
]

{ #category : #operation }
TxTerminalSpan >> tryMergeAndUpdatePosition: position [
	^ position
]
