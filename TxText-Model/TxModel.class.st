"
I am the central class, representing the text.

Internally my instances are organized as a double-linked list of spans (TxBasicSpan subclasses). There are multiple kinds of spans, like: CharacterSpan and LineSeparator.

The list is terminated at both ends with special TxStartSpan and TxEndSpan instances (which means even empty text consists of at least two such spans). 

Spans carry the actual text content, like characters and attributes. 
The model is designed in a way that it should be fairly easy to extend it by introducing new kinds of spans later. 

I don't provide a direct interface for mutating/editing my data (and this is a very important point). Instead I am modified using position(s) (TxTextPosition) and/or selection(s) (TxInterval/TxSelection), providing a rich protocol for various operations over text. 


"
Class {
	#name : #TxModel,
	#superclass : #Object,
	#instVars : [
		'startSpan',
		'endSpan',
		'styles'
	],
	#category : #'TxText-Model'
}

{ #category : #'instance creation' }
TxModel class >> fromString: aString [
	| text |
	text := self new.
	text endPosition insert: aString.
	^ text
]

{ #category : #'private-styles' }
TxModel >> addStyle: aTxStyle [

	^ styles addStyle: aTxStyle 
]

{ #category : #private }
TxModel >> applyAttribute: anAttribute onSelection: selection [
	"Preserve the selection interval while modifying the text"
	
	| currentSpan normalizedSelection |
	selection isEmpty ifTrue: [ ^ self ].
	normalizedSelection := selection normalized.
	currentSpan := normalizedSelection start span.
	[ 
		currentSpan
			applyAttribute: anAttribute
			from: normalizedSelection start
			to: normalizedSelection end.
		currentSpan == normalizedSelection end span ifTrue: [ ^ self normalize: selection. "done" ].
		currentSpan := currentSpan next.
	] repeat.
	
	
]

{ #category : #conversion }
TxModel >> asString [ 
	^ String streamContents: [ :str | self asStringOn: str ]
	
]

{ #category : #conversion }
TxModel >> asStringOn: aStream [
	self spansDo: [ :span | span asStringOn: aStream ].
]

{ #category : #conversion }
TxModel >> asTxModel [
	^ self
]

{ #category : #operations }
TxModel >> at: aTxPosition insert: aString [ 

	^ aTxPosition span at: aTxPosition insert: aString
]

{ #category : #'factory methods' }
TxModel >> characterStream [
	^ TxCharacterStream on: self
]

{ #category : #copying }
TxModel >> copy: interval [
	"Answer a new text, holding a copy of text enclosed by receiver"

	| copyStartSpan copyEndSpan  newText |
	 
	newText := self class new. 

	interval isEmpty ifTrue: [ ^ newText ].
	
	interval minMaxDo: [ :min :max |
		| span |
		
		span := min span.
		
		[ | copy | 
			copy := span appendCopyTo: newText.
			span == min span ifTrue: [ copyStartSpan := copy ].
			span == max span ifTrue: [ copyEndSpan := copy  ].
			span ~= max span ] whileTrue: [ span := span next ].
		 
		"we cut the end first, to not invalidate the start position"
		((copyEndSpan positionAt: max spanPosition) selectTo: newText endPosition) cut.
		(newText startPosition selectTo: (copyStartSpan positionAt: min spanPosition)) cut.
	 ].

	^ newText


]

{ #category : #accessing }
TxModel >> defaultStyle [
	^ styles defaultStyle
]

{ #category : #operations }
TxModel >> delete: anInterval [
	"Delete portion of text enclosed by interval.
	Answer the insertion position pointing to the text where
	interval was residing"
	
	^ anInterval minMaxDo: [ :min :max | min deleteUpTo: max ]
]

{ #category : #positioning }
TxModel >> endPosition [
	^ TxTextPosition span: endSpan spanPosition: 0
]

{ #category : #'accessing-spans' }
TxModel >> endSpan [
	^ endSpan 
]

{ #category : #testing }
TxModel >> includesSpan: span [

	self spansDo: [ :each | each == span ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #'initialize-release' }
TxModel >> initialize [
	super initialize.
	styles := TxTextStyles on: self.
	self initializeContents.
	
]

{ #category : #'initialize-release' }
TxModel >> initializeContents [
	startSpan := TxStartSpan text: self.
	endSpan := TxEndSpan text: self.
	startSpan next: endSpan
]

{ #category : #testing }
TxModel >> isEmpty [
	^ startSpan next == endSpan 
]

{ #category : #'private-factory methods' }
TxModel >> newCharacterSpan [
	^ TxCharacterSpan text: self
]

{ #category : #'private-factory methods' }
TxModel >> newCharacterSpan: aString [
	^ self newCharacterSpan
		characters: aString;
		yourself
]

{ #category : #'factory methods' }
TxModel >> newCursor [
	^ self startPosition asCursor
]

{ #category : #'private-factory methods' }
TxModel >> newLineSeparator [ 
	^ TxLineSeparator text: self
]

{ #category : #'factory methods' }
TxModel >> newSelection [
	^ TxSelection on: self
]

{ #category : #private }
TxModel >> normalize: selection [
	"Merge adjacent spans if they have the same style"

	| span normalizedSelection |
	normalizedSelection := selection normalized.
	span := normalizedSelection start span prev.
	
	[ span tryMergeWithNextPreserving: selection.
	  span == normalizedSelection end span ] whileFalse: [ span := span next ].


]

{ #category : #positioning }
TxModel >> positionAtTextIndex: textIndex [
	"Answer the position, which corresponds to given text index. This method is symmetrical to TxBasicTextPosition>>#textIndex. 
	
	Please note that converting text index<->position does not take constant time, because it requires linear scan from the beginning of text.

	Also note that text index does not correspond to some character index in the text, but to the index of a unique insertion point in the text, with the exception that endpoints of adjacent spans are considered as the same (single) insertion point, not two separate ones."

	^ self startPosition moveRight: textIndex
]

{ #category : #printing }
TxModel >> printOn: aStream [
	super printOn: aStream.
	aStream space; print: self spans
]

{ #category : #operations }
TxModel >> replaceAllWith: anotherTextModel [	
	"Insert a copy of the argument at my start"

	| copy |
	copy := anotherTextModel veryDeepCopy.
	copy spansDo: [ :each | each text: self ].
	startSpan := copy startSpan.
	endSpan := startSpan last
]

{ #category : #'accessing-spans' }
TxModel >> spans [
	^ Array streamContents: [ :stream |
		self spansDo: [ :span | stream nextPut: span ] ]
]

{ #category : #enumerating }
TxModel >> spansAndLineNumbersDo: aBlock [
	"This is an optimized way to search for a line. The alternative, querying each span for #lineNumber, could be very expensive because each time we must search the entire text up to that span"
	| lineNumber |
	lineNumber := 1.
	
	self startSpan do: [ :span |
		aBlock value: span value: lineNumber.
		span isLineSeparator ifTrue: [ lineNumber := lineNumber + 1 ] ].
]

{ #category : #enumerating }
TxModel >> spansDo: aBlock [
	self startSpan do: aBlock
]

{ #category : #positioning }
TxModel >> startPosition [
	^ TxTextPosition span: startSpan spanPosition: 0
]

{ #category : #'accessing-spans' }
TxModel >> startSpan [
	^ startSpan 
]

{ #category : #'private-styles' }
TxModel >> styles [
	^ styles
]
