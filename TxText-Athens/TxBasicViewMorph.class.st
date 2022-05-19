Class {
	#name : #TxBasicViewMorph,
	#superclass : #Morph,
	#instVars : [
		'backgroundColor'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #examples }
TxBasicViewMorph class >> fontFamilyForExamples [

	^ 'Source Sans Pro'
]

{ #category : #examples }
TxBasicViewMorph class >> openInWindowWithString: aString [

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
TxBasicViewMorph class >> openInWindowWithText: aTxModel [
	"PLEASE NOTE!!! This method is not part of official API.
	used only for examples"
 
	| editorMorph wrapper |
	editorMorph := self text: aTxModel.
	editorMorph
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		layoutFrame: LayoutFrame identity;
		wrapText: true.
		
	wrapper := AthensWrapMorph new.
	wrapper
		layoutPolicy: ProportionalLayout new;
		addMorph: editorMorph.
	
	^ wrapper openInWindow
]

{ #category : #'instance creation' }
TxBasicViewMorph class >> text: aTxModel [ 
	^ self new
		initializeText: aTxModel asTxModel;
		yourself.
]

{ #category : #accessing }
TxBasicViewMorph >> backgroundColor [
	^ backgroundColor
]

{ #category : #accessing }
TxBasicViewMorph >> backgroundColor: anObject [
	backgroundColor := anObject
]

{ #category : #'text wrapping' }
TxBasicViewMorph >> characterWrappingStrategy [
	^ TxAthensCharacterWrappingStrategy new
]

{ #category : #accessing }
TxBasicViewMorph >> contents: aText [

	self subclassResponsibility.
]

{ #category : #drawing }
TxBasicViewMorph >> drawOnAthensCanvas: anAthensCanvas [ 
	| border |
	border := self borderStyle. 
	anAthensCanvas setPaint: self fillStyle.
	anAthensCanvas drawShape: self bounds.
	
	"Fill the given rectangle."
	anAthensCanvas drawShape: (self bounds insetBy: border width).

	(anAthensCanvas setStrokePaint: border color) width: border width.
	anAthensCanvas drawShape: (self bounds insetBy: (border width /2 asFloat)).

]

{ #category : #'visual properties' }
TxBasicViewMorph >> fillStyle [
	"Return the current fillStyle of the receiver."
	self assureExtension.
	^extension fillStyle ifNil: [
		backgroundColor
			ifNil: [self theme backgroundColor]]
]

{ #category : #drawing }
TxBasicViewMorph >> fullDrawOnAthensCanvas: anAthensCanvas [ 
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
TxBasicViewMorph >> initialize [
	super initialize.
	self initializeText: '' asTxModel 
]

{ #category : #initialization }
TxBasicViewMorph >> initializeText: aTxModel [ 
	self subclassResponsibility
]

{ #category : #accessing }
TxBasicViewMorph >> layoutStrategy: aStrategy [
	self subclassResponsibility 
]

{ #category : #'text wrapping' }
TxBasicViewMorph >> noWrapStrategy [
	^ TxAthensNoWrapStrategy new
]

{ #category : #scrolling }
TxBasicViewMorph >> resetViewTo: startPosition [

	self subclassResponsibility 
]

{ #category : #scrolling }
TxBasicViewMorph >> scrollBy: aPoint [ 
	self subclassResponsibility.
]

{ #category : #scrolling }
TxBasicViewMorph >> scrollIntoView: aTextPosition [
	self subclassResponsibility
]

{ #category : #'text wrapping' }
TxBasicViewMorph >> wrapText: aBoolean [
	"turn text wrapping on/off by switching layout strategy"

	| strategy |
	
	strategy := 
		aBoolean 
			ifTrue: [ self characterWrappingStrategy ] 
			ifFalse: [ self noWrapStrategy ].

	self layoutStrategy: strategy.
]
