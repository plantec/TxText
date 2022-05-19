Class {
	#name : #TxWrappingElement,
	#superclass : #BlElement,
	#instVars : [
		'currentPosition'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #'instance creation' }
TxWrappingElement class >> for: aMorph [
	^ self new wrapAround: aMorph
]

{ #category : #accessing }
TxWrappingElement >> currentPosition: aPoint [
	self relocate: aPoint x @ (aPoint y - self height).

]

{ #category : #accessing }
TxWrappingElement >> isLocked [
	^ false
]

{ #category : #accessing }
TxWrappingElement >> layoutView [
	^ parent layoutView
]

{ #category : #accessing }
TxWrappingElement >> wrapAround: anElement [
	anElement detachFromParentWhile: [].
	anElement position: 0@0.
	self addChild: anElement.
	self size: anElement size.
]
