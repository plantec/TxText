Class {
	#name : #TxHorizontalSlider,
	#superclass : #TxSlider,
	#category : #'TxText-Athens-Widgets'
}

{ #category : #geometry }
TxHorizontalSlider >> computeSliderBounds [
	| max |
	
	max := self width.
		
	mappedThickness := max * thickness max: self minimumThicknessInPixels.
	mappedPosition := max * sliderPosition min: max.
	
	mappedPosition + mappedThickness > max ifTrue: [ 
		mappedPosition := max - mappedThickness.
		 ]
	 
]

{ #category : #initialize }
TxHorizontalSlider >> defaultBounds [
	^ (0@0 corner: 100 @ self defaultWidth)
]

{ #category : #drawing }
TxHorizontalSlider >> drawOnAthensCanvas: aCanvas [
	"before rendering transform from a global coordinates (Morphic) to relative coordinates (Athens)"
	| left right |
	left := bounds left + 1.
	right := bounds right - 1.
	aCanvas 
		setPaint: self backgroundColor;
		drawShape: bounds.
		
	aCanvas 
		setPaint: (captured ifTrue: [ self sliderHighlightColor ] ifFalse: [ self sliderColor] ).
		
	aCanvas drawShape: 
		((bounds left + mappedPosition max: left) @ (bounds top+1)
		rectangle: (bounds left + mappedPosition + mappedThickness min: right ) @ (bounds bottom-1)).

]

{ #category : #geometry }
TxHorizontalSlider >> extent: newExtent [
	
	^ super extent: newExtent x @ self  defaultWidth.
]

{ #category : #'as yet unclassified ' }
TxHorizontalSlider >> handleEventWhileDraggingSlider: event delta: delta [

	| deltaPos newPosition ann |
	event redButtonPressed ifFalse: [ ^ false ]. "finished"
	
	event isMove ifTrue: [ 
		"adjust slider position relative to dragged position"

		deltaPos :=  (event position x - bounds left) - delta.
		newPosition := deltaPos / bounds width.
		ann := (TxSliderDragged source: self) oldPosition: sliderPosition; newPosition: newPosition; yourself.
		self sliderPosition: newPosition.
		
		self announcer announce: ann.
	 ].
	

	^ true.
]

{ #category : #geometry }
TxHorizontalSlider >> mapMouseRelativeToSlider: aPosition [

	"Map mouse (screen position) relative to slider position"

	^ (aPosition x - bounds left) min: bounds width max: 0

]

{ #category : #geometry }
TxHorizontalSlider >> originForDragStart: point [


	^ point x - bounds left - mappedPosition
]
