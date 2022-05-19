Class {
	#name : #TxOneLineTextLayoutTest,
	#superclass : #TxTextLayoutTest,
	#category : #'TxText-AthensTests'
}

{ #category : #private }
TxOneLineTextLayoutTest >> defaultLayoutViewExtent [ 
	^ 1000@10000
]

{ #category : #tests }
TxOneLineTextLayoutTest >> testLayoutShouldHaveOneLine [

	self assert: view1 layout lines size equals: 1.
	self assert: view2 layout lines size equals: 1.
	
]

{ #category : #tests }
TxOneLineTextLayoutTest >> testLineSizeIncreasesLayoutExtent [
 

	self assert: (view1 layout extent x< view2 layout extent x)
]

{ #category : #private }
TxOneLineTextLayoutTest >> textForView1 [
	^ '1'
]

{ #category : #private }
TxOneLineTextLayoutTest >> textForView2 [
	^ '12'
]
