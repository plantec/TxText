Class {
	#name : #TxVerticalSlider,
	#superclass : #TxSlider,
	#category : #'TxText-Athens-Widgets'
}

{ #category : #geometry }
TxVerticalSlider >> computeSliderBounds [
	| max |
	
	max := self height.
		
	mappedThickness := max * thickness max: self minimumThicknessInPixels.
	mappedPosition := (max * sliderPosition) min: max.
	
	mappedPosition + mappedThickness > max ifTrue: [ 
		mappedPosition := (max - mappedThickness).
	]
	 
]

{ #category : #initialize }
TxVerticalSlider >> defaultBounds [
	^ (0@0 corner: self defaultWidth @ 100)
]

{ #category : #drawing }
TxVerticalSlider >> drawOnAthensCanvas: aCanvas [
	"before rendering transform from a global coordinates (Morphic) to relative coordinates (Athens)"
	| top bottom |
	
	top := bounds top + 1.
	bottom := bounds bottom - 1.
	
	aCanvas 
		setPaint: self backgroundColor;
		drawShape: bounds.
		
		
	aCanvas 
		setPaint: (captured ifTrue: [ self sliderHighlightColor ] ifFalse: [ self sliderColor] ).
		
	 aCanvas drawShape: 
		(bounds left + 1 @ (bounds top + mappedPosition max: top ) 
		rectangle: bounds right -1 @ (bounds top + mappedPosition + mappedThickness min: bottom ))  
	 
]

{ #category : #geometry }
TxVerticalSlider >> extent: newExtent [
	
	^ super extent: self  defaultWidth @ newExtent y 
]

{ #category : #'event handling' }
TxVerticalSlider >> handleEventWhileDraggingSlider: event delta: delta [

	| deltaPos newPosition ann |
	event redButtonPressed ifFalse: [ ^ false ]. "finished"
	
	event isMove ifTrue: [ 
		"adjust slider position relative to dragged position"

		deltaPos :=  (event position y - bounds top) - delta.
		newPosition := deltaPos / bounds height.
		ann := (TxSliderDragged source: self) oldPosition: sliderPosition; newPosition: newPosition; yourself.
		self sliderPosition: newPosition.
		
		self announcer announce: ann.
	 ].
	

	^ true.
]

{ #category : #geometry }
TxVerticalSlider >> mapMouseRelativeToSlider: aPosition [

	"Map mouse (screen position) relative to slider position"

	^ (aPosition y - bounds top) min: bounds height max: 0
]

{ #category : #geometry }
TxVerticalSlider >> originForDragStart: point [


	^ point y - bounds top - mappedPosition
]
