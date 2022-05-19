Class {
	#name : #TxCharacterWrappingStrategyTest,
	#superclass : #TxLayoutStrategyTest,
	#category : #'TxText-AthensTests'
}

{ #category : #private }
TxCharacterWrappingStrategyTest >> defaultStrategy [
	^ TxAthensCharacterWrappingStrategy new 
	


]

{ #category : #testing }
TxCharacterWrappingStrategyTest >> testLayoutShouldContainMultipleLines [
	self assert: (view layout numberOfLines >  1)
]
