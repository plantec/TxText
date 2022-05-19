Class {
	#name : #TxNoWrapStrategyTest,
	#superclass : #TxLayoutStrategyTest,
	#category : #'TxText-AthensTests'
}

{ #category : #private }
TxNoWrapStrategyTest >> defaultStrategy [
	^ TxAthensNoWrapStrategy new 
]

{ #category : #tests }
TxNoWrapStrategyTest >> testLayoutShouldContainASingleLine [
	self assert: (view layout numberOfLines =  1)
]
