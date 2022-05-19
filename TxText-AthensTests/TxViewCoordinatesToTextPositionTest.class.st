Class {
	#name : #TxViewCoordinatesToTextPositionTest,
	#superclass : #TxAthensTextTransformsTest,
	#category : #'TxText-AthensTests'
}

{ #category : #tests }
TxViewCoordinatesToTextPositionTest >> testLayoutPositionShouldBeBeyondStartPosition [
	|  oneCharRight layoutPosition |
	
	oneCharRight := view layout startPosition copy moveRight.
	layoutPosition := view layoutPositionAt: oneCharRight ifOutside: [  self assert: false ].

	self assert: view text == oneCharRight text.
	
	self assert: layoutPosition baselinePoint x > 0.
]

{ #category : #tests }
TxViewCoordinatesToTextPositionTest >> testOriginMovedRightShouldIncreaseTextPosition [
	| position oneCharRight pt layoutPosition |
	
	oneCharRight := view layout startPosition moveRight.
	layoutPosition := view layoutPositionAt: oneCharRight ifOutside: [  self assert: false ].
	pt := layoutPosition baselinePointInView.
	
	position := view textPositionAt: pt + (1@0).

	self assert: position = oneCharRight
]

{ #category : #tests }
TxViewCoordinatesToTextPositionTest >> testOriginShouldTransformToStartPosition [
	| position |
	position := view textPositionAt: 0@0.
	self assert: position asTextIndex = view layout startPosition asTextIndex .
]
