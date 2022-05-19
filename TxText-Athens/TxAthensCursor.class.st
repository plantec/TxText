"
i am a base class to display a cursor in text
"
Class {
	#name : #TxAthensCursor,
	#superclass : #Morph,
	#instVars : [
		'paint',
		'layoutPosition',
		'lastChangeTick'
	],
	#category : #'TxText-Athens-Editor'
}

{ #category : #'blinking support' }
TxAthensCursor >> blinkIntervalMs [
	^ 500
]

{ #category : #accessing }
TxAthensCursor >> calculateNewBounds [
	self subclassResponsibility
]

{ #category : #accessing }
TxAthensCursor >> cursorColor [
	^ Color red " self theme selectionColor alpha: 0.5"
]

{ #category : #'drawing-not supported' }
TxAthensCursor >> drawOn: aCanvas [ 
	self subclassResponsibility 
]

{ #category : #'initialize-release' }
TxAthensCursor >> initialize [ 
	super initialize.
	bounds := 0@0 extent: 1 @10. 
	paint := Color blue.
]

{ #category : #testing }
TxAthensCursor >> isBlinking [
	^ false 
]

{ #category : #'blinking support' }
TxAthensCursor >> isBlinkingVisibleNow [
	| tick |
	
	tick := Time millisecondClockValue - lastChangeTick.
	
	tick < 0 ifTrue: [ 
		"rare case when tick counter wrapped"
		lastChangeTick := Time millisecondClockValue.
		tick := 0 ].
	
	^ (tick // self blinkIntervalMs) even
	
]

{ #category : #accessing }
TxAthensCursor >> layoutPosition: aPosition [
	
	lastChangeTick := Time millisecondClockValue.
	layoutPosition := aPosition.

	"update bounds according to new layout position"
	self bounds: self calculateNewBounds.
	
"	self startStepping"
]

{ #category : #geometry }
TxAthensCursor >> position [
	^ layoutPosition topPointInView 
]

{ #category : #'blinking support' }
TxAthensCursor >> startBlinking [
	self startStepping
]

{ #category : #'blinking support' }
TxAthensCursor >> step [
	
	self visible 
		ifFalse: [ self stopStepping ]
		ifTrue: [ self changed ]
]

{ #category : #'blinking support' }
TxAthensCursor >> stepTime [
	^ self blinkIntervalMs
]

{ #category : #accessing }
TxAthensCursor >> visible: aBoolean [

	super visible: aBoolean.
	aBoolean ifTrue: [  self startStepping ].

]

{ #category : #'blinking support' }
TxAthensCursor >> wantsSteps [
	^ false
]
