"
(TxTextStyler new
	styleMethod: (TxTextStyler >> #initializeStylesFor:))
	editInWindow


- supports some ast-based navigation:
 	- cmd-click on message selection to show implementors of it
	- shift-cmd-click to show senders of it
	- cmd-click on class name to browse it
"
Class {
	#name : #TxTextStyler,
	#superclass : #Object,
	#instVars : [
		'styles',
		'text'
	],
	#category : #'TxText-Styler'
}

{ #category : #examples }
TxTextStyler class >> highlightIncompleteCode [
	| styler text code |
	
	
	code := 'thisIsIncompleteMethod: argument
		| dork zork |
		Wo
	
	'.
	
	styler := self new.
	text := styler styleCode: code inContext: self "class" isMethod: true.

	^ text editInWindow.
]

{ #category : #examples }
TxTextStyler class >> useCase [

	| styler text |
	
	styler := self new.
	text := styler styleMethod: (self >> #initializeStylesFor:).
	^ text editInWindow.
]

{ #category : #attributes }
TxTextStyler >> addAttribute: attr forNode: node [
	| start selection startIndex nodeSize |
	startIndex := node start - 1.
	nodeSize := node stop - startIndex.
	start := text startPosition + startIndex.
	selection := start selectTo: start + nodeSize.
	selection applyAttribute: attr.
]

{ #category : #attributes }
TxTextStyler >> addAttribute: attr startPosition: startPosition stopPosition: stopPosition [
	| start selection startIndex nodeSize |
	startIndex := startPosition - 1.
	nodeSize := stopPosition - startIndex.
	start := text startPosition + startIndex.
	selection := start selectTo: start + nodeSize.
	selection applyAttribute: attr
]

{ #category : #attributes }
TxTextStyler >> addAttributes: style forNode: node [
	| start selection |
	start := text startPosition moveRight: node start - 1 .
	selection := start selectTo: (start moveRight: (node stop - node start + 1)).
	style attributes valuesDo: [ :each |	selection applyAttribute:  each ].
]

{ #category : #attributes }
TxTextStyler >> addAttributes: style startPosition: startPosition stopPosition: stopPosition [
	| start selection |
	start := text startPosition moveRight: startPosition - 1.
	selection := start selectTo: (start moveRight: stopPosition - startPosition + 1).
	style attributes valuesDo: [ :each | selection applyAttribute: each ]
]

{ #category : #styling }
TxTextStyler >> addStyle: styleName forNode: node [  
	self addAttributes: (self attributesFor: styleName) forNode: node.
]

{ #category : #styling }
TxTextStyler >> addStyle: styleName startPosition: startPosition stopPosition: stopPosition [
	self addAttributes: (self attributesFor: styleName) startPosition: startPosition stopPosition: stopPosition
]

{ #category : #styling }
TxTextStyler >> attributesFor: aName [ 
	^ styles at: aName 
]

{ #category : #initialization }
TxTextStyler >> initialize [

	self initializeStylesFor: Smalltalk ui theme shStyleTable
]

{ #category : #private }
TxTextStyler >> initializeStylesFor: styleTable [

	styles := IdentityDictionary new.
	
	styleTable
		do: [:each |   | stream styleName style temp |
			
			
			stream := each readStream.
			style := TxStyle new.
			
			"style name"
			styleName := stream next.
		
			"color"
			temp := stream next.
			temp ifNotNil: [
				style add: (TxForeColorAttribute with: (Color colorFrom: temp)).
			].
			
			"emphasis"	
			temp := stream next.
			temp ifNotNil: [
				style add: (TxFontAttribute with: (self pickFontWithEmphasis: temp)).
			 ].	
				
			"text style name, ignored"
			stream next.
			
			"pixel height"
			temp := stream next.
			temp ifNotNil: [ 
				"ignored by now"
				 ].
			
			styles at: styleName put: style.
		]
]

{ #category : #styling }
TxTextStyler >> literalStyleSymbol: aValue [
	aValue isSymbol
		ifTrue: [ ^ #symbol ].
	aValue isString
		ifTrue: [ ^ #string ].
	aValue isNumber
		ifTrue: [ ^ #number ].
	aValue == true
		ifTrue: [ ^ #true ].
	aValue == false
		ifTrue: [ ^ #false ].
	aValue isNil
		ifTrue: [ ^ #nil ].
	^ #default
]

{ #category : #private }
TxTextStyler >> pickFontWithEmphasis: emphasisName [
	| emphasis |
	emphasis := TextEmphasis perform: emphasisName.
	
	^ TxFontAttribute defaultValue emphasized: emphasis emphasisCode.


]

{ #category : #private }
TxTextStyler >> resolveStyleFor: aVariableNode [
	aVariableNode binding isUndeclared ifTrue: [
		| var |
		var := aVariableNode scope findVariable: [ :varS | varS name beginsWith: aVariableNode name ] ifNone: [ nil ].
		var ifNil: [ #default ] ifNotNil: [ #incompleteIdentifier ].
	].
	aVariableNode isArg ifTrue: [ ^#methodArg].
	aVariableNode isTemp ifTrue: [ ^#tempVar].
	aVariableNode isInstance ifTrue: [ ^#instVar]. 

	aVariableNode isUndeclared ifTrue: [ ^#invalid]. 
	aVariableNode isGlobal ifTrue: [ ^  #globalVar ].
	self flag: 'todo: see if its incompleteIdentifier'.
	^#invalid.
]

{ #category : #styling }
TxTextStyler >> restyle: aText inContext: aContext isMethod: isMethod [
	| ast code |
	
	code := aText asString.
	ast := isMethod 
		ifTrue: [
			[ RBParser parseFaultyMethod: code ] 
			on: Error 
			do: [ RBParser parseFaultyExpression: code ] ]
		ifFalse: [ RBParser parseFaultyExpression: code ].
	
	aContext ifNotNil: [  
		ast methodClass: aContext ].
	ast doSemanticAnalysis.
	text := aText.
	
	ast acceptVisitor: self.
	
	^ text

]

{ #category : #styling }
TxTextStyler >> styleCode: aCode inContext: aContext isMethod: isMethod [
	| ast |
	
	ast := isMethod 
		ifTrue: [
			[ RBParser parseFaultyMethod: aCode asString ] 
			on: Error 
			do: [ RBParser parseFaultyExpression: aCode asString] ]
		ifFalse: [ RBParser parseFaultyExpression: aCode asString ].
	
	aContext ifNotNil: [  
		ast methodClass: aContext ].
	ast doSemanticAnalysis.
	text := ast source asTxModel.
	
	ast acceptVisitor: self.
	
	^ text

]

{ #category : #styling }
TxTextStyler >> styleMethod: aMethod [
	| ast |
	
	ast := aMethod ast.
	text := ast source asTxModel.
	
	ast acceptVisitor: self.
	
	^ text

]

{ #category : #visiting }
TxTextStyler >> visitArgumentNode: node [ 
	self 
		addStyle: #argument
		forNode: node.
]

{ #category : #visiting }
TxTextStyler >> visitArrayNode: anArrayNode [
	anArrayNode children do: [:each | self visitNode: each]

]

{ #category : #visiting }
TxTextStyler >> visitAssignmentNode: anAssignmentNode [ 

	self visitNode: anAssignmentNode variable.
	self visitNode: anAssignmentNode value.
	
	anAssignmentNode variable binding isWritable ifFalse: [ 
		self addStyle: #invalid forNode: anAssignmentNode 
	]
]

{ #category : #visiting }
TxTextStyler >> visitBlockNode: aBlockNode [ 

	aBlockNode comments do: [ :comment | 
			self 
			addStyle: #comment
			forNode: comment ].

	aBlockNode arguments do: [ :argument|
		self 
			addStyle: #blockPatternArg
			forNode: argument ].
		
	"self styleOpenBracket: aBlockNode."	
	self visitNode: aBlockNode body.
	"self styleCloseBracket: aBlockNode"
]

{ #category : #visiting }
TxTextStyler >> visitCascadeNode: aCascadeNode [ 

	aCascadeNode messages do: [:each | self visitNode: each]
]

{ #category : #visiting }
TxTextStyler >> visitGlobalNode: aRBGlobalNode [
	^ self visitVariableNode: aRBGlobalNode
]

{ #category : #visiting }
TxTextStyler >> visitInstanceVariableNode: aSelfNode [
	^ self visitVariableNode: aSelfNode
]

{ #category : #visiting }
TxTextStyler >> visitLiteralArrayNode: aRBLiteralArrayNode [ 
	aRBLiteralArrayNode contents do: [:each | self visitNode: each]
]

{ #category : #visiting }
TxTextStyler >> visitLiteralNode: node [ 
	
	self 
		addStyle: (self literalStyleSymbol: node value)
		forNode: node
]

{ #category : #visiting }
TxTextStyler >> visitMessageNode: aMessageNode [
	| style link hand |
	style := #keyword.
	(Symbol findInterned: aMessageNode selector asString)
		ifNil: [ 
			style := (Symbol thatStartsCaseSensitive: aMessageNode selector asString skipping: nil) isNil
				ifTrue: [ #undefinedKeyword ]
				ifFalse: [ #incompleteKeyword ] ].
	aMessageNode keywordsPositions
		do: [ :token | self addStyle: style startPosition: token stopPosition: token + aMessageNode selector size - 1 ].
	link := TxActionAttribute new
		filter: [ :evt | evt commandKeyPressed and: [ evt isMouseDown ] ];
		value:
				[ :evt | 
					evt shiftPressed
						ifTrue: [ 
							SystemNavigation new
								browseSendersOf: aMessageNode selector
								name: 'Senders of ' , aMessageNode selector
								autoSelect: aMessageNode selector ]
						ifFalse: [ SystemNavigation new browseAllImplementorsOf: aMessageNode selector ] ] yourself.
	hand := TxMouseCursorAttribute with: Cursor webLink.
	aMessageNode keywordsPositions
		do: [ :token | 
			self addAttribute: link startPosition: token stopPosition: token + aMessageNode selector size - 1.
			self addAttribute: hand startPosition: token stopPosition: token + aMessageNode selector size - 1 ].
	(aMessageNode isCascaded not or: [ aMessageNode isFirstCascaded ])
		ifTrue: [ self visitNode: aMessageNode receiver ].
	aMessageNode arguments do: [ :each | self visitNode: each ]
]

{ #category : #visiting }
TxTextStyler >> visitMethodNode: aMethodNode [ 

	aMethodNode comments do: [ :comment |
		self 
			addStyle: #comment
			forNode: comment ].
		
	aMethodNode arguments do: [ :argument |
		self 
			addStyle: #patternArg
			forNode: argument ].
		
		aMethodNode selectorParts
		with: aMethodNode keywordsPositions
		do: [ :keyword :position | 
			self
				addStyle: #patternKeyword
				startPosition: position
				stopPosition: position + keyword size - 1 
		].
	
	aMethodNode pragmas do: [ :each | 
		self visitNode: each 
	].
		
	self visitNode: aMethodNode body
]

{ #category : #visiting }
TxTextStyler >> visitNode: node [
	"node comments do: [ :comment |
		self 
			addStyle: #comment
			from: comment first
			to: comment last ]."

	^node acceptVisitor: self 

]

{ #category : #visiting }
TxTextStyler >> visitParseErrorNode: errorNode [

	self 
		addStyle: #invalid
		forNode: errorNode.
	
]

{ #category : #visiting }
TxTextStyler >> visitPragmaNode: aPragmaNode [

	aPragmaNode selectorParts 
		with: aPragmaNode keywordsPositions
		do: [ :keyword :position |
			self 
				addStyle: #pragmaKeyword
				startPosition: position
				stopPosition: position + keyword size 
		].
	
	aPragmaNode arguments do: [ :each | self visitNode: each ]
]

{ #category : #visiting }
TxTextStyler >> visitReturnNode: aReturnNode [

	self addStyle: 	#return 
		startPosition: aReturnNode start 
		stopPosition: aReturnNode start. "the reason for start here is so not the whole return node is styled as bold"
	
	self visitNode: aReturnNode value
]

{ #category : #visiting }
TxTextStyler >> visitSelfNode: aSelfNode [
	| link methodClass |
	
	self 
		addStyle: #self
		forNode: aSelfNode.
	
	methodClass := aSelfNode methodNode methodClass.
		
	link := TxActionAttribute new 
		filter: [ :evt | evt commandKeyPressed and: [ evt  isMouseDown] ];
		value: [ methodClass browse ];
		yourself.

	self 
		addAttribute: link
		forNode: aSelfNode.
]

{ #category : #visiting }
TxTextStyler >> visitSequenceNode: node [
	
	node temporaries do: [ :temporary|
		self 
			addStyle: #patternTempVar
			forNode: temporary ].
	
	node statements do: [:each | self visitNode: each] 

]

{ #category : #visiting }
TxTextStyler >> visitSuperNode: aSuperNode [

	self addStyle: #super
		forNode: aSuperNode
]

{ #category : #visiting }
TxTextStyler >> visitTemporaryNode: aTemporaryNode [ 
	self 
		addStyle: #tempVar
		forNode: aTemporaryNode
]

{ #category : #visiting }
TxTextStyler >> visitThisContextNode: aThisContextNode [

	self 
		addStyle: #thisContext
		forNode: aThisContextNode
]

{ #category : #visiting }
TxTextStyler >> visitVariableNode: aVariableNode [ 
"	aVariableNode name first isUppercase 
		ifTrue: [environment ifNil: [ ^ self visitClassReferenceNode: aVariableNode ]].
"
	| link |
	
	self 
		addStyle: (self resolveStyleFor: aVariableNode) 
		forNode: aVariableNode.
	
	(aVariableNode binding notNil and: [  
	aVariableNode isGlobal ]) ifTrue: [  
		link := TxActionAttribute new 
			filter: [ :evt | evt commandKeyPressed and: [ evt  isMouseDown] ];
			value: [ aVariableNode binding value instanceSide browse ];
			yourself.

		self 
			addAttribute: link
			forNode: aVariableNode.
	]
]
