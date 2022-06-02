Class {
	#name : #TxBasicViewElement,
	#superclass : #BlElement,
	#category : #'TxText-Athens-Widgets'
}

{ #category : #examples }
TxBasicViewElement class >> fontFamilyForExamples [

	^ 'Source Sans Pro'
]

{ #category : #examples }
TxBasicViewElement class >> openInWindowWithString: aString [

	| text font |
	
	text := TxModel new.
	font := LogicalFont familyName: self fontFamilyForExamples pointSize: 16.
	text defaultStyle
		add: TxFontAttribute with: font;
		add: TxForeColorAttribute with: Color blue.
	
	text endPosition insert: aString.
	
	^ self openInWindowWithText: text
]

{ #category : #examples }
TxBasicViewElement class >> openInWindowWithText: aTxModel [
	"PLEASE NOTE!!! This method is not part of official API.
	used only for examples"
 
	| editorElement wrapper |
	editorElement := self text: aTxModel.
	editorElement constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical matchParent ]; 
		wrapText: true.
	editorElement openInOblSpace.
	^ editorElement
]

{ #category : #'instance creation' }
TxBasicViewElement class >> text: aTxModel [ 
	^ self new
		initializeText: aTxModel asTxModel;
		yourself.
]

{ #category : #'text wrapping' }
TxBasicViewElement >> characterWrappingStrategy [
	^ TxAthensCharacterWrappingStrategy new
]

{ #category : #accessing }
TxBasicViewElement >> contents: aText [

	self subclassResponsibility.
]

{ #category : #drawing }
TxBasicViewElement >> drawChildrenOnSpartaCanvas: aCanvas [
	super drawChildrenOnSpartaCanvas: aCanvas
]

{ #category : #drawing }
TxBasicViewElement >> drawOnAthensCanvas: anAthensCanvas [ 
	| border |
	border := self borderStyle. 
	anAthensCanvas setPaint: self fillStyle.
	anAthensCanvas drawShape: self bounds.
	
	"Fill the given rectangle."
	anAthensCanvas drawShape: (self bounds insetBy: border width).

	(anAthensCanvas setStrokePaint: border color) width: border width.
	anAthensCanvas drawShape: (self bounds insetBy: (border width /2 asFloat)).

]

{ #category : #drawing }
TxBasicViewElement >> drawOnSpartaCanvas: aCanvas [ 
	super drawOnSpartaCanvas: aCanvas 
]

{ #category : #drawing }
TxBasicViewElement >> fullDrawOnAthensCanvas: anAthensCanvas [ 
	"Draw the full Morphic structure on the given Canvas"

	self visible ifFalse: [^ self].
	(anAthensCanvas isVisible: self fullBounds) ifFalse: [^self].
	(self hasProperty: #errorOnDraw) ifTrue: [^self "drawErrorOn: aCanvas" ].

	(anAthensCanvas isVisible: self bounds) ifTrue: [ anAthensCanvas draw: self ].
	
	submorphs isEmpty ifTrue: [^self].

	self clipSubmorphs 
		ifTrue: [
			anAthensCanvas 
				clipBy: self clippingBounds
				during: [ submorphs reverseDo: [ :m | anAthensCanvas fullDrawMorph: m ] ] ] 
		ifFalse: [ submorphs reverseDo: [ :m | anAthensCanvas fullDrawMorph: m ] ]

]

{ #category : #initialization }
TxBasicViewElement >> initialize [
	super initialize.
	self background: Color white.
	self initializeText: '' asTxModel 
]

{ #category : #initialization }
TxBasicViewElement >> initializeText: aTxModel [ 
	self subclassResponsibility
]

{ #category : #accessing }
TxBasicViewElement >> layoutStrategy: aStrategy [
	self subclassResponsibility 
]

{ #category : #'text wrapping' }
TxBasicViewElement >> noWrapStrategy [
	^ TxAthensNoWrapStrategy new
]

{ #category : #scrolling }
TxBasicViewElement >> resetViewTo: startPosition [

	self subclassResponsibility 
]

{ #category : #scrolling }
TxBasicViewElement >> scrollBy: aPoint [ 
	self subclassResponsibility.
]

{ #category : #scrolling }
TxBasicViewElement >> scrollIntoView: aTextPosition [
	self subclassResponsibility
]

{ #category : #'text wrapping' }
TxBasicViewElement >> wrapText: aBoolean [
	"turn text wrapping on/off by switching layout strategy"

	| strategy |
	
	strategy := 
		aBoolean 
			ifTrue: [ self characterWrappingStrategy ] 
			ifFalse: [ self noWrapStrategy ].

	self layoutStrategy: strategy.
]
