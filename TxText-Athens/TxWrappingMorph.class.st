"
Any morphs embedded in the text should use me as a wrapper.

This class is private (you are not supposed to create 
its instances by yourself).

This morph wraps a user morph, embedded in a text,
and provides some helpers for the morph's positioning etc.

An example of using an embedded object can be found in #exampleWithEmbeddedObject

To insert sanembedded object send #insertObject: 
to a text position, for example:
text endPosition insertObject: 123.
"
Class {
	#name : #TxWrappingMorph,
	#superclass : #Morph,
	#instVars : [
		'currentPosition'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #'instance creation' }
TxWrappingMorph class >> for: aMorph [
	^ self new wrapAround: aMorph
]

{ #category : #'events-processing' }
TxWrappingMorph >> containsPoint: aPoint event: anEvent [
	Transcript show: 'contans ..';cr.
	^ super containsPoint: aPoint event: anEvent
	
]

{ #category : #accessing }
TxWrappingMorph >> currentPosition: aPoint [
	self position: aPoint x @ (aPoint y - self height).

]

{ #category : #drawing }
TxWrappingMorph >> drawOnAthensCanvas: aCanvas [
	"nothing"
	
"	aCanvas setPaint: (Color red alpha: 0.4).
	aCanvas pathTransform restoreAfter: [ 

		aCanvas drawShape: (bounds expandBy: 3) .
	].

"
]

{ #category : #drawing }
TxWrappingMorph >> fullDrawOnAthensCanvas: aCanvas [
	"nothing"
	
	aCanvas pathTransform restoreAfter: [ 
		aCanvas pathTransform translateBy: owner innerBounds origin.
		super fullDrawOnAthensCanvas: aCanvas.
	].


]

{ #category : #'events-processing' }
TxWrappingMorph >> handleMouseOver: anEvent [

"	Transcript show: 'mouse over'; show: anEvent;cr."
	
	super handleMouseOver: anEvent.
]

{ #category : #initialization }
TxWrappingMorph >> initialize [
	super initialize.
	
]

{ #category : #accessing }
TxWrappingMorph >> isLocked [
	^ false
]

{ #category : #accessing }
TxWrappingMorph >> layoutView [
	^ owner layoutView
]

{ #category : #'events-processing' }
TxWrappingMorph >> processEvent: anEvent using: defaultDispatcher [
"	| evt |
	evt := anEvent transformedBy: owner transform.

	Transcript show: 'event pos: '; show: anEvent position;cr."
"	Transcript show: bounds;cr."
	
	"evt := anEvent transformedBy: self transform."
	
	"^ #rejected."
	^ super processEvent: anEvent using: defaultDispatcher
]

{ #category : #accessing }
TxWrappingMorph >> wrapAround: aMorph [
	aMorph delete.
	aMorph position: 0@0.
	self addMorph: aMorph.
	
	self extent: aMorph extent.
]
