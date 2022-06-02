Class {
	#name : #TxBlCursor,
	#superclass : #BlElement,
	#instVars : [
		'paint',
		'layoutPosition',
		'lastChangeTick'
	],
	#category : #'TxText-Athens-Editor'
}

{ #category : #'blinking support' }
TxBlCursor >> blinkIntervalMs [
	^ 500
]

{ #category : #accessing }
TxBlCursor >> calculateNewBounds [
	self subclassResponsibility
]

{ #category : #accessing }
TxBlCursor >> cursorColor [
	^ Color red " self theme selectionColor alpha: 0.5"
]

{ #category : #'drawing-not supported' }
TxBlCursor >> drawOn: aCanvas [ 
	self subclassResponsibility 
]

{ #category : #'initialize-release' }
TxBlCursor >> initialize [ 
	super initialize.
	self constraintsDo: [ :c |
			c horizontal exact: 2.
			c vertical exact: 20. ].
	self background: Color white.
]

{ #category : #testing }
TxBlCursor >> isBlinking [
	^ false 
]

{ #category : #'blinking support' }
TxBlCursor >> isBlinkingVisibleNow [
	| tick |
	
	tick := Time millisecondClockValue - lastChangeTick.
	
	tick < 0 ifTrue: [ 
		"rare case when tick counter wrapped"
		lastChangeTick := Time millisecondClockValue.
		tick := 0 ].
	
	^ (tick // self blinkIntervalMs) even
	
]

{ #category : #accessing }
TxBlCursor >> layoutPosition: aPosition [
	| rect |
	lastChangeTick := Time millisecondClockValue.
	layoutPosition := aPosition.

	"update bounds according to new layout position"
	rect := self calculateNewBounds.
	self relocate: rect origin.
	self size: rect extent.
	
"	self startStepping"
]

{ #category : #geometry }
TxBlCursor >> position [
	"^ layoutPosition topPointInView "
	^ super position
]

{ #category : #'blinking support' }
TxBlCursor >> startBlinking [
	"self startStepping"
]

{ #category : #'blinking support' }
TxBlCursor >> step [
	
	self visible 
		ifFalse: [ self stopStepping ]
		ifTrue: [ self changed ]
]

{ #category : #'blinking support' }
TxBlCursor >> stepTime [
	^ self blinkIntervalMs
]

{ #category : #'blinking support' }
TxBlCursor >> wantsSteps [
	^ false
]
