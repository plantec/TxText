"
This is not a decorator pattern.

"
Class {
	#name : #TxViewDecoratorMorph,
	#superclass : #Morph,
	#instVars : [
		'placement',
		'viewContainer'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #'as yet unclassified' }
TxViewDecoratorMorph >> computeBoundsIn: layoutBounds [
	| rest oldBounds |

	self visible ifFalse: [ ^ layoutBounds ].
	
	oldBounds := bounds.
	rest := placement value: layoutBounds.
	
	oldBounds ~= bounds ifTrue: [ 
		self invalidRect: (oldBounds quickMerge: bounds)
		 ].
	^ rest
]

{ #category : #initialization }
TxViewDecoratorMorph >> initialize [
	super initialize.
	self hResizing: #spaceFill; vResizing: #spaceFill.
	self placeDefault.
]

{ #category : #placement }
TxViewDecoratorMorph >> placeBottom [

	placement := [ :layoutBounds | 
		self bounds: (layoutBounds left @ (layoutBounds bottom - self height) corner: layoutBounds corner).
		
		layoutBounds origin corner: layoutBounds right @ bounds top.
	].

]

{ #category : #placement }
TxViewDecoratorMorph >> placeDefault [
	^ self placeTop
]

{ #category : #placement }
TxViewDecoratorMorph >> placeLeft [

	placement := [ :layoutBounds | 
		self bounds: (layoutBounds origin extent: self width @ layoutBounds height).
		
		layoutBounds origin x+self width @ layoutBounds origin y corner: layoutBounds corner
	].

]

{ #category : #placement }
TxViewDecoratorMorph >> placeRight [

	placement := [ :layoutBounds | 
		self bounds: (layoutBounds right - self width @ layoutBounds top corner: layoutBounds corner).
		layoutBounds origin corner: bounds origin x@layoutBounds bottom 
		].

]

{ #category : #placement }
TxViewDecoratorMorph >> placeTop [

	placement := [ :layoutBounds | 
		self bounds: (layoutBounds topLeft extent: layoutBounds width @ self height).
		layoutBounds origin x@ (layoutBounds origin y + self height) corner: layoutBounds corner
		].
	 
]

{ #category : #accessing }
TxViewDecoratorMorph >> setContainer: anObject [
	
	viewContainer := anObject
]

{ #category : #'setting up' }
TxViewDecoratorMorph >> setupView: viewMorph [
	"view morph has changed.. rewire the events if necessary"
]

{ #category : #accessing }
TxViewDecoratorMorph >> viewContainer [
	
	^ viewContainer
]
