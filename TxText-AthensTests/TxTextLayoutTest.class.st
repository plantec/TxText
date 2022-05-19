Class {
	#name : #TxTextLayoutTest,
	#superclass : #TxAthensTextTest,
	#instVars : [
		'view1',
		'view2'
	],
	#category : #'TxText-AthensTests'
}

{ #category : #private }
TxTextLayoutTest >> defaultLayoutViewExtent [
	^ self subclassResponsibility 
]

{ #category : #running }
TxTextLayoutTest >> setUp [
	| text |
	text := self newText: self textForView1.
	view1 := self newViewOn:  text .
	
	text := self newText: self textForView2.
	view2 := self newViewOn:  text .

]

{ #category : #private }
TxTextLayoutTest >> textForView1 [
	^ self subclassResponsibility 
]

{ #category : #private }
TxTextLayoutTest >> textForView2 [
	^ self subclassResponsibility 
]
