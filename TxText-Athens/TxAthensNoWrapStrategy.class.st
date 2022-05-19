"
I'm a layout strategy that computes the layout of each text line from the starting position to the end of the line.

Therefore, I compute the line as it is,  and its up to the view to clip all the characters outside of the layout view's extent.


"
Class {
	#name : #TxAthensNoWrapStrategy,
	#superclass : #TxAthensLayoutStrategy,
	#instVars : [
		'finished'
	],
	#category : #'TxText-Athens'
}

{ #category : #visiting }
TxAthensNoWrapStrategy >> visitCharacterSpan: aSpan [
	
	| chars startPos font w  fontMetricsProvider |
	
	chars := aSpan characters.
	
	startPos := currentPosition spanPosition.
	startPos = 0 ifTrue: [  startPos := 1 ].
	
	font := aSpan getAttribute: TxFontAttribute.  
	
	fontMetricsProvider := self fontMetricsProviderFor: font.
	currentLine accumulateHeight: fontMetricsProvider fontHeight.
	currentLine accumulateAscent: fontMetricsProvider fontAscent.
	
	w := 0.
	startPos to: chars size do: [ :i | | char tabAdvance |
		char := chars at: i.
		char == Character tab 
			ifTrue: [ 
				i > startPos ifTrue: [ 
					currentLine addWidth: w.

					currentLine addCommand: (fontMetricsProvider 
						newCharacterSpanDisplayCommand: aSpan
						start: startPos
						stop: i-1
						advance: w@0).
					].
					tabAdvance := (self alignTab: font).
					currentLine addCommand: (fontMetricsProvider 
						newTabDisplayCommand: aSpan
						start: i-1
						stop: i
						advance: tabAdvance).
						
					currentLine addWidth: tabAdvance x.
					
					^ aSpan positionAt: i+1.
			 ]	
			ifFalse: [ w := w + (fontMetricsProvider getGlyphWidth: (chars at:i)) ]
			
	].
	currentLine addWidth: w.

	currentLine addCommand: (fontMetricsProvider 
		newCharacterSpanDisplayCommand: aSpan
		start: startPos
		stop: aSpan size
		advance: w@0).
		
	^ aSpan next startPosition
]
