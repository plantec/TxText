"
In most command-line interfaces or text editors, the text cursor or caret navigation, is an underscore, a solid rectangle, or a vertical line, which may be flashing or steady, indicating where text will be placed when entered (the insertion point).
"
Class {
	#name : #TxCaretCursor,
	#superclass : #TxAthensCursor,
	#category : #'TxText-Athens-Editor'
}

{ #category : #accessing }
TxCaretCursor >> calculateNewBounds [
	| topLeft bottomRight |

	"the top point in view is relative to view, 
	since morphic uses absolute coordinates we should add view position here"
	topLeft := owner layoutViewMorph topLeft + layoutPosition topPointInView.
	bottomRight := topLeft + (2@layoutPosition line height).
	
	"we round bounds here to avoid clipping artefacts"
	^ topLeft floor corner: bottomRight ceiling
]

{ #category : #drawing }
TxCaretCursor >> drawOnAthensCanvas: aCanvas [

	| cursorShape |

	cursorShape := owner layoutViewMorph topLeft + layoutPosition topPointInView extent: 2@ layoutPosition line height.
	
	self isBlinkingVisibleNow ifTrue: [ 
		aCanvas 
			setShape: cursorShape;
			setPaint: self cursorColor;
			draw
		]
]

{ #category : #testing }
TxCaretCursor >> isBlinking [
	^ true 
]
