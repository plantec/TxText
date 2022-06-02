Class {
	#name : #TxBlBlockCursor,
	#superclass : #TxBlCursor,
	#category : #'TxText-Athens-Editor'
}

{ #category : #accessing }
TxBlBlockCursor >> calculateNewBounds [
	|   position width font |

	"the top point in view is relative to view, 
	since morphic uses absolute coordinates we should add view position here"
	position := layoutPosition textPosition.
	font := (position span style at: TxFontAttribute) value.
	width := font widthOf: position nextPosition getCharacter.
	^ (parent layoutViewElement topLeft + layoutPosition topPointInView) floor extent: width ceiling @ layoutPosition line height ceiling.
]

{ #category : #drawing }
TxBlBlockCursor >> drawOnAthensCanvas: aCanvas [

	self flag: 'Most of this object is currently just copied from TxCaretCursor'.
	self isBlinkingVisibleNow ifTrue: [ 
		aCanvas 
			setShape: self calculateNewBounds;
			setPaint: self cursorColor;
			draw
		]
]

{ #category : #testing }
TxBlBlockCursor >> isBlinking [
	^ true 
]
