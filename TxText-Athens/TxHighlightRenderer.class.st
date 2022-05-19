"
I highlight text backgroung e.g. to show a selection. I require a layout view, paint, and text interval.
"
Class {
	#name : #TxHighlightRenderer,
	#superclass : #Object,
	#instVars : [
		'layoutView',
		'paint',
		'shapes',
		'extendEnd',
		'interval'
	],
	#category : #'TxText-Athens'
}

{ #category : #'instance creation' }
TxHighlightRenderer class >> highlighting: aTxInterval in: layoutView with: paint [

	^ self new
		layoutView: layoutView;
		interval: aTxInterval;
		paint: paint;
		yourself.
]

{ #category : #'private-accessing' }
TxHighlightRenderer >> interval: aTxInterval [
	interval := aTxInterval.
	shapes := nil.
]

{ #category : #'private-accessing' }
TxHighlightRenderer >> layout [

	^ layoutView layout.
]

{ #category : #'private-accessing' }
TxHighlightRenderer >> layoutView: anObject [
	layoutView := anObject
]

{ #category : #'private-accessing' }
TxHighlightRenderer >> paint: anObject [
	paint := anObject
]

{ #category : #rendering }
TxHighlightRenderer >> renderHighlightOn: canvas [
	
	canvas pathTransform restoreAfter: [
		canvas pathTransform translateBy: layoutView offset negated.
		canvas setPaint: paint.
		self shapes do: [ :e | canvas drawShape: e ]
	].
]

{ #category : #'private-accessing' }
TxHighlightRenderer >> shapes [

	| lineStream currentLine startPoint endPoint height highlightStartPosition highlightEndPosition |
	shapes ifNotNil: [ ^ shapes ].
	
	shapes := OrderedCollection new.
	self trimIntervalToLayout.
	interval isEmpty ifTrue: [ ^ shapes ].

	highlightStartPosition := self layout positionAt: interval start ifOutside: [ self shouldNotHappen ].
	highlightEndPosition := self layout positionAt: interval end ifOutside: [ self shouldNotHappen ]. 
	
	height := 0.
	lineStream := self layout lines readStream.

	"Skip to line where highlight starts, caching the accumulated y offset for later"	
	[ (currentLine := lineStream next) = highlightStartPosition line ] whileFalse: [ height := height + currentLine height ].

	"The highlight of the first line of the interval will always start at... the start of the interval, duh"
	startPoint := highlightStartPosition topPoint.
	
	"The highlight of each line except the last ends at the right side of the view"
	[ currentLine == highlightEndPosition line ] whileFalse: [  
		endPoint := (layoutView width + layoutView offset x) @ (height + currentLine height).
		shapes add: (startPoint rectangle: endPoint).
		
		height := height + currentLine height.
		currentLine := lineStream next.
		startPoint := 0@height.
	].

	"We're at the last line, end the highlight at the end of the interval"
	endPoint := extendEnd 
		ifTrue: [ (layoutView width + layoutView offset x) @ (height + currentLine height) ]
		ifFalse: [ highlightEndPosition bottomPoint ].
	
	shapes add: (startPoint rectangle: endPoint).

	^ shapes.
]

{ #category : #private }
TxHighlightRenderer >> trimIntervalToLayout [
	| start end |

	interval minMaxDo: [ :min :max |
		start := (self layout startPosition max: min) min: self layout endPosition.
		extendEnd := self layout endPosition < max.
		end := (self layout startPosition max: max) min: self layout endPosition ].

	interval := start to: end.
]
