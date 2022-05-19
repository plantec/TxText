"
This layout strategy wraps text, so it never overflows the view horizontally.
If the line is too long to be shown fully as a single text line in view,
it is automatically wrapped to the next line.

Therefore, the layout is calculated based on the view's extent.
The 'rightMargin' can be used to wrap the text before it gets wider than view width, e.g:

maxLineWidth := view width - rightMargin.

By default, right margin is Zero, meaning the max line width is same as view width.

Note, if you use this strategy, the view must never use horizontal scrolling,
and its offset x must be always Zero (since it makes little sense to have otherwise with such a strategy).
"
Class {
	#name : #TxAthensCharacterWrappingStrategy,
	#superclass : #TxAthensLayoutStrategy,
	#instVars : [
		'rightMargin'
	],
	#category : #'TxText-Athens'
}

{ #category : #initialization }
TxAthensCharacterWrappingStrategy >> initialize [
	super initialize.
	rightMargin := 0.
]

{ #category : #accessing }
TxAthensCharacterWrappingStrategy >> rightMargin [
	^ rightMargin
]

{ #category : #accessing }
TxAthensCharacterWrappingStrategy >> rightMargin: aNumber [
	rightMargin := aNumber
]

{ #category : #visitor }
TxAthensCharacterWrappingStrategy >> visitCharacterSpan: aSpan [
	
	| chars pos startPos font w fontMetricsProvider viewWidth  glyphWidth |
	
	chars := aSpan characters.
	
	startPos := pos := currentPosition spanPosition.

	font := aSpan getAttribute: TxFontAttribute.  
	
	fontMetricsProvider := self fontMetricsProviderFor: font.
	currentLine accumulateHeight: fontMetricsProvider fontHeight.
	currentLine accumulateAscent: fontMetricsProvider fontAscent.
	
	viewWidth := self view extent x.
	glyphWidth := w := 0.
	startPos := pos+1.
	
	[ pos < chars size ] whileTrue: [ | char |
	
		char := chars at: pos + 1.
		char == Character tab ifTrue: [ | ta | 
			ta := self alignTab: font.
			((currentLine width + ta x > (viewWidth - rightMargin)) and: [ currentLine width >0 ]) ifTrue: [ 
				"Need to wrap"
				
				currentLine addCommand: (
					fontMetricsProvider 
						newCharacterSpanDisplayCommand: aSpan 
						start: startPos 
						stop: pos 
						advance: w@0).

				currentPosition := aSpan positionAt: pos.
				self completeLine.
				^ currentPosition
				].
				
			currentLine addCommand: (
				fontMetricsProvider 
					newCharacterSpanDisplayCommand: aSpan 
					start: startPos 
					stop: pos
					advance: w@0).

			
			currentLine addWidth: ta x.
			currentLine addCommand: (fontMetricsProvider 
						newTabDisplayCommand: aSpan
						start: pos-1
						stop: pos
						advance: ta).
				currentPosition := aSpan positionAt: pos+1.
				^ currentPosition
			].
		
		
		glyphWidth := (fontMetricsProvider getGlyphWidth: char).
		"Do not wrap unless we put at least one character into current line"
		((currentLine width + glyphWidth > (viewWidth - rightMargin)) and: [ currentLine width >0 ]) ifTrue: [ 
				"wrap to new line"
				currentLine addCommand: (
					fontMetricsProvider 
						newCharacterSpanDisplayCommand: aSpan 
						start: startPos 
						stop: pos 
						advance: w@0).

				currentPosition := aSpan positionAt: pos.
				self completeLine.
				^ currentPosition
			] 
		ifFalse: [ 
			currentLine addWidth: glyphWidth.
			w := w + glyphWidth.
			pos := pos +1
		]
	].

	currentLine addCommand: (
		fontMetricsProvider 
			newCharacterSpanDisplayCommand: aSpan 
			start: startPos 
			stop: chars size
			advance: w@0).
			
	^ aSpan next startPosition

]
