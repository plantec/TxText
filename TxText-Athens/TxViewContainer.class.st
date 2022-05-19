"
I hold the view (or editor) morph and all decorators together (scollbars/line numbers etc).

The model serves as an application-level object, that is a final client for text updates/changes/context menu etc.
"
Class {
	#name : #TxViewContainer,
	#superclass : #Morph,
	#instVars : [
		'view',
		'decorators',
		'model'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #convenience }
TxViewContainer class >> editText: aText [
	| view wrapper |

	view := self new.

	view addDecorator: (TxScrollbarDecorator new placeRight color: Color blue;yourself).
	view addDecorator: (TxScrollbarDecorator new placeBottom color: Color green;yourself).
	view editText: aText.
	view wrapText: false.
	view hResizing: #spaceFill ; vResizing: #spaceFill .
	view layoutFrame: LayoutFrame identity.
	
	wrapper := AthensWrapMorph new.
	wrapper layoutPolicy: ProportionalLayout new.
	wrapper addMorph: view.
	
	^ wrapper openInWindow extent: 400@400.



]

{ #category : #examples }
TxViewContainer class >> example1 [

	| view |

	view := TxViewContainer new.

	view addDecorator: (TxViewDecoratorMorph new placeTop color: Color red;yourself).
	view addDecorator: (TxViewDecoratorMorph new placeRight color: Color yellow;yourself).
	view addDecorator: (TxViewDecoratorMorph new placeLeft  color: Color blue;yourself).
	view addDecorator: (TxViewDecoratorMorph new placeBottom color: Color green;yourself).

	view  openInWindow



]

{ #category : #examples }
TxViewContainer class >> example2 [

	| view wrapper |

	view := TxViewContainer new.

	view addDecorator: (TxViewDecoratorMorph new placeTop color: Color red;yourself).
	view addDecorator: (TxViewDecoratorMorph new placeLeft  color: Color blue;yourself).
	view addDecorator: (TxViewDecoratorMorph new placeBottom color: Color green;yourself).
	view addDecorator: (TxScrollbarDecorator new placeRight color: Color blue;yourself).
	view addDecorator: (TxScrollbarDecorator new placeBottom color: Color green;yourself).
	view useEditor.
	view wrapText: false.
	view hResizing: #spaceFill ; vResizing: #spaceFill .
	view layoutFrame: LayoutFrame identity.
	
	wrapper := AthensWrapMorph new.
	wrapper layoutPolicy: ProportionalLayout new.
	wrapper addMorph: view.
	
	wrapper openInWindow extent: 400@400.



]

{ #category : #examples }
TxViewContainer class >> exampleEditorExistingTextWithEmbeddedObjects [
"self exampleEditorExistingTextWithEmbeddedObjects
"
	| view wrapper text |

	text := String loremIpsum  asTxModel.

	1 to: 1000 do: [:i | 
	text endPosition insert: i asString, ' empty bottles on the bar'.
	text endPosition insertObject:  ((SimpleButtonMorph newWithLabel: 'DEADBEEF' ) color: Color random ) .
	text endPosition insert: 'uwe hfiuweh fiue', String cr.
	(text endPosition moveLeft selectTo: (text endPosition moveLeft: 5)) applyAttribute: (TxForeColorAttribute with: Color random).
	text endPosition insert: '-------', String cr.
	].

	view := TxViewContainer new.

"	view addDecorator: (TxViewDecoratorMorph new placeTop color: Color red;yourself).
	view addDecorator: (TxViewDecoratorMorph new placeLeft  color: Color blue;yourself).
	view addDecorator: (TxViewDecoratorMorph new placeBottom color: Color green;yourself)."
	view addDecorator: (TxScrollbarDecorator new placeRight color: Color blue;yourself).
	view addDecorator: (TxScrollbarDecorator new placeBottom color: Color green;yourself).
	view editText: text.
	view wrapText: false.
	view hResizing: #spaceFill ; vResizing: #spaceFill .
	view layoutFrame: LayoutFrame identity.
	
	wrapper := AthensWrapMorph new.
	wrapper layoutPolicy: ProportionalLayout new.
	wrapper addMorph: view.
	
	wrapper openInWindow extent: 400@400.



]

{ #category : #examples }
TxViewContainer class >> exampleOneLineEditor [

	| view wrapper |

	view := TxViewContainer new.

"	view addDecorator: (TxViewDecoratorMorph new placeTop color: Color red;yourself).
	view addDecorator: (TxViewDecoratorMorph new placeLeft  color: Color blue;yourself).
	view addDecorator: (TxViewDecoratorMorph new placeBottom color: Color green;yourself)."
	view addDecorator: (TxScrollbarDecorator new placeBottom color: Color green;yourself).
	view useEditor.
	view wrapText: false.
	view hResizing: #spaceFill ; vResizing: #spaceFill .
	view layoutFrame: LayoutFrame identity.
	
	wrapper := AthensWrapMorph new.
	wrapper layoutPolicy: ProportionalLayout new.
	wrapper addMorph: view.
	
	wrapper openInWindow extent: 400@400.



]

{ #category : #accessing }
TxViewContainer >> addDecorator: morph [
	decorators add: morph.
	self addMorph: morph.
	morph setContainer: self.
]

{ #category : #layout }
TxViewContainer >> doLayoutIn: layoutBounds [
	| box priorBounds processedBounds |
	priorBounds := self outerBounds.
	processedBounds := layoutBounds.
	decorators do: [:morph |
		processedBounds := morph computeBoundsIn: processedBounds ].
	
	
	view bounds: processedBounds.
	
	fullBounds := bounds.
	
	box := self outerBounds.
	box = priorBounds 
		ifFalse: [self invalidRect: (priorBounds quickMerge: box)]
]

{ #category : #initialization }
TxViewContainer >> editText: aText [
	self setView: (self newEditor: aText)
]

{ #category : #initialization }
TxViewContainer >> initialize [
	super initialize.
	self layoutPolicy: ProportionalLayout new.
	self layoutInset: 0.
	decorators := OrderedCollection new.
	view := self newView.
	view 
		layoutFrame: LayoutFrame identity;
		hResizing: #spaceFill;
		vResizing: #spaceFill.

	self addMorph: view.
	

]

{ #category : #accessing }
TxViewContainer >> layoutView [
	^ view layoutView
]

{ #category : #accessing }
TxViewContainer >> model [
	^ model
]

{ #category : #accessing }
TxViewContainer >> model: aModel [
	model := aModel
]

{ #category : #'instance creation' }
TxViewContainer >> newEditor [

	^ self newEditor: ''
]

{ #category : #'instance creation' }
TxViewContainer >> newEditor: aText [

	^ TxTextEditorMorph text: aText
]

{ #category : #'instance creation' }
TxViewContainer >> newView [

	^ TxLayoutViewMorph new
]

{ #category : #initialization }
TxViewContainer >> setView: newView [

	view == newView ifTrue:  [ ^ self ].
	view delete.
	view := newView.
	self addMorph: view.

	decorators do: [ :each | each setupView: newView ]
]

{ #category : #initialization }
TxViewContainer >> useEditor [
	self setView: self newEditor
]

{ #category : #accessing }
TxViewContainer >> view [
	^ view
]

{ #category : #accessing }
TxViewContainer >> viewMorph [
	^ view
]

{ #category : #accessing }
TxViewContainer >> wrapText: aBoolean [
	"turn text wrapping on/off by switching layout strategy"

	self viewMorph wrapText: aBoolean
]
