"
I have the following semantics:
- when a UI event attempts to interact with my text, I run it through my filter, and trigger the action if it passes.

Instance Variables:
#value - an action block, with an optional argument to receive the event
"
Class {
	#name : #TxActionAttribute,
	#superclass : #TxAttribute,
	#instVars : [
		'filter'
	],
	#classVars : [
		'Default'
	],
	#category : #'TxText-Model'
}

{ #category : #defaults }
TxActionAttribute class >> defaultValue [
	^ Default ifNil: [  Default := self new ]
]

{ #category : #comparing }
TxActionAttribute >> = anObject [
	^ super = anObject and: [ filter = anObject filter ]
]

{ #category : #accessing }
TxActionAttribute >> filter [
	^ filter
]

{ #category : #accessing }
TxActionAttribute >> filter: aBlock [
	filter := aBlock
]

{ #category : #'event handling' }
TxActionAttribute >> filterEvent: anEvent [
	"Answer true if event passes the filter, false otherwise"
	
	filter ifNil: [ ^ false ].
	^ filter value: anEvent
]

{ #category : #'event handling' }
TxActionAttribute >> handleEvent: anEvent [
	"Answer true if event passes the filter, false otherwise"
	
	(self filterEvent: anEvent) ifTrue: [ 
		value cull: anEvent.
		^ true
		 ].
	^ false

]

{ #category : #accessing }
TxActionAttribute >> value [
	^ self
]
