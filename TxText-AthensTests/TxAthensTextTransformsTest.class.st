Class {
	#name : #TxAthensTextTransformsTest,
	#superclass : #TxAthensTextTest,
	#instVars : [
		'view'
	],
	#category : #'TxText-AthensTests'
}

{ #category : #private }
TxAthensTextTransformsTest >> defaultLayoutViewExtent [
	^ 100@500.
]

{ #category : #private }
TxAthensTextTransformsTest >> defaultStrategy [
	^ TxAthensCharacterWrappingStrategy new
]

{ #category : #private }
TxAthensTextTransformsTest >> defaultText [
	^ 'The view coordinates should be properly transformed into a text position to interact with a text being displayed'
]

{ #category : #running }
TxAthensTextTransformsTest >> setUp [
	| text |
	text := self newText: self defaultText.
	view := self newViewOn: text.
]
