"
I represent a single text line, which belongs to specific layout.

I carry various geometrical information, such as maximum ascent, line height and width.
My commands are TxDisplayCommand-s which contain enough information to render
the line correctly on canvas , as well as for measuring font metrics.

I am certainly not the top level API and my implementation is considered private
(in contrast to LayoutView).
"
Class {
	#name : #TxAthensLayoutLine,
	#superclass : #Object,
	#instVars : [
		'interval',
		'commands',
		'width',
		'height',
		'baselineOffset',
		'maxAscent',
		'layout'
	],
	#category : #'TxText-Athens'
}

{ #category : #accessing }
TxAthensLayoutLine >> accumulateAscent: asc [
	maxAscent := maxAscent max: asc
]

{ #category : #accessing }
TxAthensLayoutLine >> accumulateHeight: h [
	height := height max: h
]

{ #category : #accessing }
TxAthensLayoutLine >> accumulateSpanFontMetrics: span [
	"accumulate max font height and ascent for given span"
	| font fontMetricsProvider |

	font := interval start span getAttribute: TxFontAttribute.  
	fontMetricsProvider := layout fontMetricsProviderFor: font.
	self accumulateHeight: fontMetricsProvider fontHeight.
	self accumulateAscent: fontMetricsProvider fontAscent.		
	
]

{ #category : #accessing }
TxAthensLayoutLine >> addCommand: cmd [

	commands add: cmd
	
]

{ #category : #scanning }
TxAthensLayoutLine >> addWidth: aNumber [ 
	width := width + aNumber
]

{ #category : #accessing }
TxAthensLayoutLine >> baselineOffset [
	^ baselineOffset
]

{ #category : #accessing }
TxAthensLayoutLine >> commandForPosition: aTextPosition ifOutside: aBlock [
	"Answer the display command which correspond to given text position in line,
	or evaluate block if receiver does not contains given position"
	
	(interval contains: aTextPosition) ifTrue: [ 
			commands
				detect: [ :each | each contains: aTextPosition ]
				ifFound: [ :each | ^ each ] ].

	^ aBlock value
]

{ #category : #accessing }
TxAthensLayoutLine >> commands [
	
	^ commands
]

{ #category : #rendering }
TxAthensLayoutLine >> debugRenderOn: aTxTextRenderer [ 
	
	aTxTextRenderer canvas 
		setPaint: Color red;
		drawShape: (0@ maxAscent negated corner: width@(maxAscent negated+height)).
	
	commands do: [:cmd | cmd renderOn: aTxTextRenderer ]
]

{ #category : #accessing }
TxAthensLayoutLine >> endPosition [
	^ interval end 
]

{ #category : #accessing }
TxAthensLayoutLine >> endPosition: aTxTextPosition [ 
	interval := interval 
		ifNil: [ aTxTextPosition to: aTxTextPosition ]
		ifNotNil: [ interval start to: aTxTextPosition ]
]

{ #category : #geometry }
TxAthensLayoutLine >> height [
	^ height
]

{ #category : #geometry }
TxAthensLayoutLine >> horizontalOffsetFor: textPosition [ 
	
	| totalAdvance |
	
	totalAdvance := 0. 
	
	"special case, when line starting position don't matching the first command position"
	commands isEmpty ifTrue: [ "empty line" ^ 0 ].
	commands first startPosition > textPosition ifTrue: [  ^ 0 ]. 
		
	commands do: [:cmd |
		(cmd contains: textPosition) ifTrue: [
			^ totalAdvance + (cmd horizontalAdvanceUpTo: textPosition layout: layout)
			  ]
		ifFalse: [ totalAdvance := totalAdvance + cmd advance x]
	].

	"if we reach here, just answert he accumulated total advance"
	^ totalAdvance
]

{ #category : #'initalize-release' }
TxAthensLayoutLine >> initialize [
	super initialize.
	maxAscent := height := baselineOffset := width := 0.
	commands := OrderedCollection new
]

{ #category : #accessing }
TxAthensLayoutLine >> interval [
	
	^ interval
]

{ #category : #accessing }
TxAthensLayoutLine >> layout [
	^ layout
]

{ #category : #'initalize-release' }
TxAthensLayoutLine >> layout: aLayout [
	layout := aLayout 
]

{ #category : #accessing }
TxAthensLayoutLine >> maxAscent [
	^ maxAscent
]

{ #category : #'as yet unclassified' }
TxAthensLayoutLine >> notifyRemovedFrom: aTxAthensLayout [ 
	""
	commands do: [ :ea | ea notifyRemovedFrom: aTxAthensLayout ]
]

{ #category : #printing }
TxAthensLayoutLine >> printOn: aStream [

	super printOn: aStream.
	aStream space; print: interval.
]

{ #category : #rendering }
TxAthensLayoutLine >> renderOn: aTxTextRenderer [ 
	
	"aTxTextRenderer canvas 
		setPaint: (Color red alpha:0.5);
		drawShape: (0@ maxAscent negated corner: width@(maxAscent negated+height)).
"	
	commands do: [:cmd | cmd renderOn: aTxTextRenderer ]
]

{ #category : #accessing }
TxAthensLayoutLine >> startPosition [
	^ interval start
]

{ #category : #accessing }
TxAthensLayoutLine >> startPosition: aTxTextPosition [ 
	
	interval ifNotNil: [  self error: 'start position can be set only once' ].

	interval := (aTxTextPosition to: aTxTextPosition).
	"set initial height and ascent"
	self accumulateSpanFontMetrics: aTxTextPosition span.
			

]

{ #category : #geometry }
TxAthensLayoutLine >> textPositionAtHorizontalOffset: anOffset [ 
	| advance |
	anOffset < 0 ifTrue:[ ^ self startPosition ].
	advance := 0.
	commands do: [:cmd | 
		(cmd advance x + advance > anOffset)
			ifTrue:[ ^ cmd textPositionForHorizontalOffset: anOffset - advance layout: layout].
		advance := advance + cmd advance x ].
	^ self endPosition
]

{ #category : #geometry }
TxAthensLayoutLine >> width [
	^ width
]

{ #category : #geometry }
TxAthensLayoutLine >> width: anObject [
	width := anObject
]
