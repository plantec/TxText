Extension { #name : #CairoFontMetricsProvider }

{ #category : #'*TxText-Athens' }
CairoFontMetricsProvider >> newCharacterSpanDisplayCommand: span start: startPos stop: stopPos advance: aPoint [

	^ TxCairoCharacterSpanDisplayCommand new 
			span: span start: startPos stop: stopPos;
			advance: aPoint;
			yourself
]

{ #category : #'*TxText-Athens' }
CairoFontMetricsProvider >> newEmbeddedObjectCommand: anEmbeddedObjectSpan [ 

	^ TxEmbeddedObjectCommand new 
		span: anEmbeddedObjectSpan;
		yourself
]

{ #category : #'*TxText-Athens' }
CairoFontMetricsProvider >> newTabDisplayCommand: span start: startPos stop: stopPos advance: aPoint [ 

	^ TxTabDisplayCommand new 
		span: span start: startPos stop: stopPos;
		advance: aPoint;
		yourself
]
