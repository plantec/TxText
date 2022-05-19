"
i provide mapping from text position (TxTextPosition)
to position inside view's layout.


"
Class {
	#name : #TxAthensLayoutPosition,
	#superclass : #Object,
	#instVars : [
		'textPosition',
		'layout',
		'line',
		'lineTopOffset',
		'horizontalOffset',
		'command'
	],
	#category : #'TxText-Athens'
}

{ #category : #'as yet unclassified' }
TxAthensLayoutPosition class >> textPosition: textPosition layout: txLayout [

	^ self new textPosition: textPosition layout: txLayout

]

{ #category : #accessing }
TxAthensLayoutPosition >> baselinePoint [
	"answer the point at baseline matching with given layout position"
	
	^ horizontalOffset @ (lineTopOffset + line maxAscent )
]

{ #category : #accessing }
TxAthensLayoutPosition >> baselinePointInView [
	"answer the point at baseline matching with given layout position"
	
	^ self baselinePoint - layout view offset
]

{ #category : #accessing }
TxAthensLayoutPosition >> bottomPoint [
	"answer the point at baseline matching with given layout position"
	
	^ self topPoint + (0@line height)
]

{ #category : #accessing }
TxAthensLayoutPosition >> bottomPointInView [
	"answer the point at baseline matching with given layout position"
	
	^ self bottomPoint - layout view offset
]

{ #category : #accessing }
TxAthensLayoutPosition >> command [
	"Answer the display command which correspond to given layout position"
	^ command
]

{ #category : #accessing }
TxAthensLayoutPosition >> horizontalOffset [
	^ horizontalOffset
]

{ #category : #accessing }
TxAthensLayoutPosition >> layout [
	^ layout
]

{ #category : #accessing }
TxAthensLayoutPosition >> line [
	^ line 
]

{ #category : #accessing }
TxAthensLayoutPosition >> textPosition [
	^ textPosition
]

{ #category : #initializing }
TxAthensLayoutPosition >> textPosition: aTextPosition layout: txLayout [
	
	textPosition := aTextPosition.
	layout := txLayout.
	
	self updateInfo.
	
 
]

{ #category : #accessing }
TxAthensLayoutPosition >> topPoint [
	"answer the point at baseline matching with given layout position"
	
	^ horizontalOffset @ lineTopOffset 
]

{ #category : #accessing }
TxAthensLayoutPosition >> topPointInView [
	"answer the point at baseline matching with given layout position"
	
	^ self topPoint - layout view offset
]

{ #category : #calculating }
TxAthensLayoutPosition >> updateInfo [

 	lineTopOffset := 0.
	
	layout lines do: [:each |
		(each interval contains: textPosition) ifTrue: [ 
			"found the line"
			line := each.
			horizontalOffset := line horizontalOffsetFor: textPosition .
			command := line commandForPosition: textPosition ifOutside: nil.
			^ self
		].
		lineTopOffset := lineTopOffset + each height.
	].

	horizontalOffset isNil ifTrue:[ self error: 'should not get here!'].
]
