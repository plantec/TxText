Class {
	#name : #TxDisplayCommand,
	#superclass : #Object,
	#instVars : [
		'next'
	],
	#category : #'TxText-Athens'
}

{ #category : #accessing }
TxDisplayCommand >> addLast: aCommand [
	self tail next: aCommand
]

{ #category : #testing }
TxDisplayCommand >> contains: aTextPosition [
	self subclassResponsibility
]

{ #category : #accessing }
TxDisplayCommand >> do: aBlock [
	| nn |
	nn := self.
	
	[ nn isNil ] whileFalse: [ 
		aBlock value: nn.
		nn := nn next. ]
]

{ #category : #geometry }
TxDisplayCommand >> horizontalAdvanceUpTo: textPosition layout: layout [

	self subclassResponsibility
]

{ #category : #accessing }
TxDisplayCommand >> insert: aCommands [

	| nn |
	nn := next.
	next := aCommands.
	next tail next: nn
]

{ #category : #accessing }
TxDisplayCommand >> next [

	^ next
]

{ #category : #accessing }
TxDisplayCommand >> next: anObject [
	
	next := anObject
]

{ #category : #'as yet unclassified' }
TxDisplayCommand >> notifyRemovedFrom: aTxAthensLayout [ 

]

{ #category : #copying }
TxDisplayCommand >> postCopy [
	"unlink the copy by default"
	next := nil
]

{ #category : #rendering }
TxDisplayCommand >> renderOn: renderer [
	self shouldBeImplemented 
]

{ #category : #accessing }
TxDisplayCommand >> startPosition [
	"answer the text position, matching the start of command"
	self subclassResponsibility
]

{ #category : #accessing }
TxDisplayCommand >> tail [
	| nn |
	nn := self.
	[ nn next notNil ] whileTrue: [ nn := nn next ].
	^ nn
]

{ #category : #geometry }
TxDisplayCommand >> textPositionForHorizontalOffset: anOffset layout: layout [

	self subclassResponsibility
]
