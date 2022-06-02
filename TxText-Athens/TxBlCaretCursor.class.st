Class {
	#name : #TxBlCaretCursor,
	#superclass : #TxBlCursor,
	#category : #'TxText-Athens-Editor'
}

{ #category : #accessing }
TxBlCaretCursor >> calculateNewBounds [
	| topLeft bottomRight |

	"the top point in view is relative to view, 
	since morphic uses absolute coordinates we should add view position here"
	topLeft := self parent layoutViewElement bounds topLeft + layoutPosition topPointInView.
	bottomRight := topLeft + (2@layoutPosition line height).
	
	"we round bounds here to avoid clipping artefacts"
	^ topLeft floor corner: bottomRight ceiling
]

{ #category : #drawing }
TxBlCaretCursor >> drawOnAthensCanvas: aCanvas [

	| cursorShape |

	cursorShape := self parent layoutViewElement topLeft + layoutPosition topPointInView extent: 2@ layoutPosition line height.
	
	self isBlinkingVisibleNow ifTrue: [ 
		aCanvas 
			setShape: cursorShape;
			setPaint: self cursorColor;
			draw
		]
]

{ #category : #testing }
TxBlCaretCursor >> isBlinking [
	^ true 
]
