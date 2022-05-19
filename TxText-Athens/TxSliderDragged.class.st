Class {
	#name : #TxSliderDragged,
	#superclass : #TxSliderAnnouncement,
	#instVars : [
		'oldPosition',
		'newPosition'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #accessing }
TxSliderDragged >> newPosition [
	
	^ newPosition
]

{ #category : #accessing }
TxSliderDragged >> newPosition: anObject [
	
	newPosition := anObject
]

{ #category : #accessing }
TxSliderDragged >> oldPosition [
	
	^ oldPosition
]

{ #category : #accessing }
TxSliderDragged >> oldPosition: anObject [
	
	oldPosition := anObject
]
