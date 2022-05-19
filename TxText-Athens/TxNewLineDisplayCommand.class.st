Class {
	#name : #TxNewLineDisplayCommand,
	#superclass : #TxDisplayCommand,
	#instVars : [
		'span'
	],
	#category : #'TxText-Athens'
}

{ #category : #accessing }
TxNewLineDisplayCommand >> advance [
	^ 10@0
]

{ #category : #testing }
TxNewLineDisplayCommand >> contains: aTextPosition [
	^ false
	
	"^ aTextPosition span == span"
]

{ #category : #accessing }
TxNewLineDisplayCommand >> horizontalAdvanceUpTo: textPosition layout: layout [

	^ 10
]

{ #category : #rendering }
TxNewLineDisplayCommand >> renderOn: renderer [

	renderer renderEndOfLineMark.
	
	
]

{ #category : #accessing }
TxNewLineDisplayCommand >> span: aTxLineSeparator [ 
	span := aTxLineSeparator
]

{ #category : #accessing }
TxNewLineDisplayCommand >> startPosition [
	^ span startPosition
]

{ #category : #accessing }
TxNewLineDisplayCommand >> textPositionForHorizontalOffset: anOffset layout: layout [

	^ span startPosition
]
