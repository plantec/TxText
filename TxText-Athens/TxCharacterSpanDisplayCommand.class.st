Class {
	#name : #TxCharacterSpanDisplayCommand,
	#superclass : #TxDisplayCommand,
	#instVars : [
		'span',
		'start',
		'stop',
		'advance'
	],
	#category : #'TxText-Athens'
}

{ #category : #accessing }
TxCharacterSpanDisplayCommand >> advance [
	
	^ advance
]

{ #category : #accessing }
TxCharacterSpanDisplayCommand >> advance: anObject [
	
	advance := anObject
]

{ #category : #testing }
TxCharacterSpanDisplayCommand >> contains: aTextPosition [

	"this one is tricky and should be covered by tests, because
	start and stop here is start charater index and stop character index, but not positions
	 "
	
	self flag: #coverByTest.
	
	^ aTextPosition span == span and: [ | spanPos |  
			spanPos := aTextPosition spanPosition.
			spanPos between: start-1 and: stop ]
]

{ #category : #geometry }
TxCharacterSpanDisplayCommand >> fontMetricsProvider: aTextLayout [
	| font |
	font := self span getAttribute: TxFontAttribute.  
	^ aTextLayout  fontMetricsProviderFor: font.

]

{ #category : #geometry }
TxCharacterSpanDisplayCommand >> horizontalAdvanceUpTo: aTextPosition layout: aTextLayout [
"	<compilerOptions: #(- optionInlineToDo )>"
	| horizontalAdvance fontMetricsProvider   characters spanPosition |

	fontMetricsProvider := self  fontMetricsProvider: aTextLayout. 
	horizontalAdvance := 0.
	characters := self span characters.
	spanPosition := aTextPosition spanPosition.
	
	start to: stop do: [ :index |
		| glyphWidth |
		index > spanPosition  ifTrue: [  ^ horizontalAdvance ].
		glyphWidth := fontMetricsProvider getGlyphWidth: (characters at: index).
		horizontalAdvance := horizontalAdvance + glyphWidth.
	].
	"we should never reach here"
	^ horizontalAdvance
]

{ #category : #rendering }
TxCharacterSpanDisplayCommand >> renderOn: renderer [

	renderer setFont: (span getAttribute: TxFontAttribute).
	renderer setColor: (span getAttribute: TxForeColorAttribute).
	
	renderer renderCharacters: span characters from: start to: stop.
	renderer advance:advance.
]

{ #category : #accessing }
TxCharacterSpanDisplayCommand >> span [
	^ span
]

{ #category : #accessing }
TxCharacterSpanDisplayCommand >> span: anObject [
	span := anObject
]

{ #category : #'setting up' }
TxCharacterSpanDisplayCommand >> span: aSpan start: startPos stop: stopPos [

	span := aSpan.
	start := startPos.
	stop := stopPos.

]

{ #category : #accessing }
TxCharacterSpanDisplayCommand >> start [
	^ start
]

{ #category : #accessing }
TxCharacterSpanDisplayCommand >> start: anObject [
	start := anObject
]

{ #category : #accessing }
TxCharacterSpanDisplayCommand >> startPosition [
	"answer the text position, matching the start of command"
	^ TxTextPosition span: span spanPosition: start -1
]

{ #category : #accessing }
TxCharacterSpanDisplayCommand >> stop [
	^ stop
]

{ #category : #accessing }
TxCharacterSpanDisplayCommand >> stop: anObject [
	stop := anObject
]

{ #category : #geometry }
TxCharacterSpanDisplayCommand >> textPositionForHorizontalOffset: anOffset layout: layout [
	| x fontMetricsProvider  |

	fontMetricsProvider := self fontMetricsProvider: layout.
	x := anOffset.

	start to: stop do: [ :index |
		| glyphWidth |	
		glyphWidth := fontMetricsProvider getGlyphWidth: (span characters at: index).
		x <= glyphWidth ifTrue: [ 
			"if offset closer to left side of glyph, we answer the position prior to it,
			otherwise after it"
			x < (glyphWidth/2) 
				ifTrue: [ ^ span positionAt: index - 1 ]
				ifFalse: [ ^ span positionAt: index ]
			].
		x := x - glyphWidth].
	^ span positionAt: stop
]
