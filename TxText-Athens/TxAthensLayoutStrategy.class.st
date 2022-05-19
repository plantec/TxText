Class {
	#name : #TxAthensLayoutStrategy,
	#superclass : #Object,
	#instVars : [
		'currentPosition',
		'currentLine',
		'metStopCondition',
		'layout'
	],
	#category : #'TxText-Athens'
}

{ #category : #'as yet unclassified' }
TxAthensLayoutStrategy >> alignTab: font [
	| tabWidth lineWidth |
	tabWidth := self layout tabWidthUsingFont: font.
	lineWidth := currentLine width.
	
	^ lineWidth // tabWidth + 1 * tabWidth - lineWidth @ 0
	
]

{ #category : #building }
TxAthensLayoutStrategy >> completeLine [

	currentLine endPosition: currentPosition.
	metStopCondition := true.
]

{ #category : #'as yet unclassified' }
TxAthensLayoutStrategy >> fontMetricsProviderFor: aFont [
	^ self view fontMetricsProviderFor: aFont
]

{ #category : #accessing }
TxAthensLayoutStrategy >> layout [
	^ layout
]

{ #category : #scanning }
TxAthensLayoutStrategy >> scanSingleVisualLineFor: aLayout startingAt: aPosition [
	"Scan a single visual line until meeting stop condition.
	Note, the incoming position can be in the middle of text line (because of wrapping)"
	
	layout := aLayout.
	currentPosition := aPosition.	
	self startNewLine.
	metStopCondition := false.
	
	[ currentPosition := currentPosition span accept: self. metStopCondition ] whileFalse.

	^ currentLine
]

{ #category : #building }
TxAthensLayoutStrategy >> startNewLine [

	currentLine := TxAthensLayoutLine new
		layout: self layout;
		startPosition: currentPosition;
		yourself.
	
]

{ #category : #accessing }
TxAthensLayoutStrategy >> view [
	^ layout view
]

{ #category : #visiting }
TxAthensLayoutStrategy >> visitEmbeddedObjectSpan: aSpan [

	| font fontMetricsProvider command |

	font := aSpan getAttribute: TxFontAttribute.  
	fontMetricsProvider := layout fontMetricsProviderFor: font.

	command := layout newEmbeddedObjectCommand: aSpan.
	
	"embedded object's height contributes to font ascent, as its bottom is aligned to baseline"
	currentLine accumulateAscent: command height.
	currentLine accumulateHeight: command height + (fontMetricsProvider fontHeight - fontMetricsProvider fontAscent).
	currentLine addWidth: command width.
	
	currentLine addCommand: command.

	^ aSpan next startPosition

]

{ #category : #visiting }
TxAthensLayoutStrategy >> visitEndSpan: aSpan [

	self completeLine.

]

{ #category : #visiting }
TxAthensLayoutStrategy >> visitLineSeparator: aSpan [

	"A line separator indicates new line
	if current span position = 0 then we finish scanning,
	else we treat it as beginning of a new line, and must continue"
	currentPosition isAtSpanStart ifTrue: [
		"end of line"
		self completeLine.
		^ currentPosition
	].

	^ currentPosition nextPosition
]

{ #category : #visiting }
TxAthensLayoutStrategy >> visitStartSpan: aSpan [

	"usually just skip over start span"
	^ aSpan next startPosition
]
