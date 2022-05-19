Class {
	#name : #TxMultilineSmallTextLayoutTest,
	#superclass : #TxTextLayoutTest,
	#category : #'TxText-AthensTests'
}

{ #category : #private }
TxMultilineSmallTextLayoutTest >> defaultLayoutViewExtent [ 
	^ 100@10000.
	
]

{ #category : #tests }
TxMultilineSmallTextLayoutTest >> testAddingLineShouldIncreaseLayoutHeight [
 

	self assert: (view1 layout extent y < view2 layout extent y)
]

{ #category : #tests }
TxMultilineSmallTextLayoutTest >> testLayoutExtentHeightShouldNotBeZero [

	self assert: (view1 layout extent y ~= 0)
]

{ #category : #tests }
TxMultilineSmallTextLayoutTest >> testView1LayoutShouldHaveTwoLines [

	self assert: view1 layout lines size equals: 2.
	
]

{ #category : #tests }
TxMultilineSmallTextLayoutTest >> testView2LayoutShouldHaveThreeLines [

	self assert: view2 layout lines size equals: 3.
	
]

{ #category : #private }
TxMultilineSmallTextLayoutTest >> textForView1 [
^
'1: Line 1
2: Line2'.

]

{ #category : #private }
TxMultilineSmallTextLayoutTest >> textForView2 [
^
'1: Line 1
2: Line2
3: Line3'.

]
