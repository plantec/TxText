"
Most of this object is currently just copied from TxCaretCursor. Possibly it would be better to have one Cursor class with a pluggable drawing strategy...
"
Class {
	#name : #TxBlockCursor,
	#superclass : #TxAthensCursor,
	#category : #'TxText-Athens-Editor'
}

{ #category : #accessing }
TxBlockCursor >> calculateNewBounds [
	|   position width font |

	"the top point in view is relative to view, 
	since morphic uses absolute coordinates we should add view position here"
	position := layoutPosition textPosition.
	font := (position span style at: TxFontAttribute) value.
	width := font widthOf: position nextPosition getCharacter.
	^ (owner layoutViewMorph topLeft + layoutPosition topPointInView) floor extent: width ceiling @ layoutPosition line height ceiling.
]

{ #category : #drawing }
TxBlockCursor >> drawOnAthensCanvas: aCanvas [

	self flag: 'Most of this object is currently just copied from TxCaretCursor'.
	self isBlinkingVisibleNow ifTrue: [ 
		aCanvas 
			setShape: self calculateNewBounds;
			setPaint: self cursorColor;
			draw
		]
]

{ #category : #testing }
TxBlockCursor >> isBlinking [
	^ true 
]
