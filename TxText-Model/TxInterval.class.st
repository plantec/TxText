"
I am interval of text. I am immutable.
"
Class {
	#name : #TxInterval,
	#superclass : #Object,
	#instVars : [
		'start',
		'end'
	],
	#category : #'TxText-Model'
}

{ #category : #'instance creation' }
TxInterval class >> from: startPosition to: endPosition [

	^ self basicNew initStart: startPosition end: endPosition

]

{ #category : #'instance creation' }
TxInterval class >> on: aText [
	"Answer an interval, containing whole text"
	^ self from: aText startPosition to: aText endPosition
]

{ #category : #conversion }
TxInterval >> asString [ 
		
	^String streamContents: [ :s | 
		self normalized start printTextOn: s upTo: self normalized end.		
	]
]

{ #category : #testing }
TxInterval >> contains: aPosition [
	^ aPosition between: start and: end
]

{ #category : #conversion }
TxInterval >> copyText [
	"answer a new text, holding a copy of text enclosed by receiver"
	
	^ self text copy: self
]

{ #category : #enumeration }
TxInterval >> do: aBlock [

	| iterator |
	end < start ifTrue:[^self].
	
	iterator := start copy.
		
	[end = iterator] whileFalse: [ 
		aBlock value: iterator. 
		iterator moveRight] 
]

{ #category : #accessing }
TxInterval >> end [
	
	^ end
]

{ #category : #initialization }
TxInterval >> initStart: startPosition end: endPosition [

	start := startPosition asPosition.
	end := endPosition asPosition
]

{ #category : #testing }
TxInterval >> isEmpty [

	^ end hasSamePositionAs: start
]

{ #category : #enumeration }
TxInterval >> minMaxDo: minMaxBlock [

	^ start < end 
		ifTrue: [ minMaxBlock value: start value: end ]
		ifFalse: [ minMaxBlock value: end value: start ]
]

{ #category : #copying }
TxInterval >> normalized [

	| min max |
	min := self start min: self end.
	max := self start max: self end.
	^ self class from: min to: max
]

{ #category : #printing }
TxInterval >> printOn: aStream [

	super printOn: aStream.
	aStream 
		nextPut: $[;
		print: start.
		
	
		aStream 
			nextPutAll: ' .. ';
			print: end.
	
	
	aStream
		nextPut: $]
]

{ #category : #accessing }
TxInterval >> start [
	
	^ start
]

{ #category : #accessing }
TxInterval >> text [
	
	^ start text
]
