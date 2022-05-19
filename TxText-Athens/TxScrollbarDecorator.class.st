Class {
	#name : #TxScrollbarDecorator,
	#superclass : #TxViewDecoratorMorph,
	#instVars : [
		'vertical',
		'scrollbar',
		'autohide'
	],
	#category : #'TxText-Athens-Widgets'
}

{ #category : #accessing }
TxScrollbarDecorator >> autohide [
	^ autohide
]

{ #category : #accessing }
TxScrollbarDecorator >> autohide: anBoolean [
	autohide := anBoolean
]

{ #category : #misc }
TxScrollbarDecorator >> computeBoundsIn: layoutBounds [
	| result |
	result := super computeBoundsIn: layoutBounds.
	
	scrollbar bounds: self bounds.
	^ result

]

{ #category : #initialize }
TxScrollbarDecorator >> defaultBounds [

"answer the default bounds for the receiver"
	^ 0 @ 0 corner: self theme scrollbarThickness @ self theme scrollbarThickness.
]

{ #category : #misc }
TxScrollbarDecorator >> disconnectFromContainer [
	"unregister from all boring stuff.. one day"
	scrollbar ifNotNil: [
		 scrollbar announcer unsubscribe: self ]. 
]

{ #category : #geometry }
TxScrollbarDecorator >> height [
	^ vertical
		ifFalse: [ scrollbar height ]
		ifTrue: [ super height ]
]

{ #category : #initialize }
TxScrollbarDecorator >> initScrollbar [
	| ann |
	self removeAllMorphs.
	scrollbar ifNotNil: [  scrollbar announcer unsubscribe: self ].

	scrollbar := (vertical ifTrue: [ TxSlider vertical ] ifFalse: [ TxSlider horizontal  ]) new.
	
	self addMorph: scrollbar.

	ann := scrollbar announcer weak.
	
	ann 
		when: TxSliderDragged send: #sliderDragged: to: self;
		when: TxSliderScrollBackward send: #sliderScrollBackward to: self;
		when: TxSliderScrollForward send: #sliderScrollForward to: self
	
]

{ #category : #initialization }
TxScrollbarDecorator >> initialize [

	super initialize.
	self placeRight.
	autohide := true.
]

{ #category : #layout }
TxScrollbarDecorator >> layoutChanged [
	^ super layoutChanged
]

{ #category : #placement }
TxScrollbarDecorator >> placeBottom [

	vertical := false.
	self initScrollbar.
	super placeBottom
]

{ #category : #placement }
TxScrollbarDecorator >> placeLeft [

	vertical := true.
	self initScrollbar.

	super placeLeft
]

{ #category : #placement }
TxScrollbarDecorator >> placeRight [

	vertical := true.
	self initScrollbar.

	super placeRight
]

{ #category : #placement }
TxScrollbarDecorator >> placeTop [

	vertical := false.
	self initScrollbar.

	super placeTop
]

{ #category : #accessing }
TxScrollbarDecorator >> setContainer: anObject [

	viewContainer := anObject.
	
	viewContainer layoutView announcer weak when: TxLayoutViewChanged send: #viewChanged: to: self
]

{ #category : #initialization }
TxScrollbarDecorator >> setupView: viewMorph [
	"view morph has changed.. rewire the events if necessary"
	

	viewMorph layoutView announcer weak when: TxLayoutViewChanged send: #viewChanged: to: self
]

{ #category : #accessing }
TxScrollbarDecorator >> sliderDragged: aTxSliderDragged [

	| view viewMorph |
	
	viewMorph := viewContainer viewMorph.
	view :=  viewMorph layoutView.
	
	vertical ifFalse: [ 
		| totalSize delta |
		delta := aTxSliderDragged newPosition - aTxSliderDragged oldPosition.
		totalSize := view layout extent x.
		viewMorph scrollBy: (delta * totalSize) @ 0.
		
	 ] ifTrue: [ 
	"vertical one"
		| totalLines approxNewLine clampedPos |
		totalLines := view text endPosition lineNumber.
		clampedPos := aTxSliderDragged newPosition min: 1 max: 0.
		approxNewLine := (totalLines * clampedPos) rounded.

		approxNewLine = 0 ifTrue: [  
			view scrollBy: 0 @ view offset y negated.
			viewMorph resetViewTo: view text startPosition.
			^ self.
			].
	
		view text spansAndLineNumbersDo: [ :span :lineNumber | 
			lineNumber >= approxNewLine ifTrue: [ 
				viewMorph resetViewTo: span startPosition.
				"scrolling up, if layout height is smaller than view height" 
				view height > view layout height ifTrue: [ 
					viewMorph scrollBy: 0 @ (view height - view layout height) negated
					 ].
				^ self.
				].
		].
		self error: 'not reachable.. else it is buggy'.
		view resetLayout: view text endPosition.
		viewMorph scrollBy: (0 @ view extent y negated).
	 ]
]

{ #category : #accessing }
TxScrollbarDecorator >> sliderScrollBackward [

	vertical ifTrue: [ 
		viewContainer viewMorph scrollBy: 0@viewContainer viewMorph height negated
		]
	ifFalse: [ 
		viewContainer viewMorph scrollBy: viewContainer viewMorph width negated @0
		
		 ]
]

{ #category : #accessing }
TxScrollbarDecorator >> sliderScrollForward [

	vertical ifTrue: [ 
		viewContainer viewMorph scrollBy: 0@viewContainer viewMorph height
		]
	ifFalse: [ 
		viewContainer viewMorph scrollBy: viewContainer viewMorph width@0
		
		 ]
]

{ #category : #accessing }
TxScrollbarDecorator >> viewChanged: aTxLayoutViewChanged [
	| view |
	
	view := aTxLayoutViewChanged view.
	
	vertical ifFalse: [ 
		| totalSize |
		
		autohide ifTrue: [ 
			"automatically hide if we can"
			view needsHorizontalScrolling ifFalse: [ self hide. ^ self ]].
		
		self visible: true.
		
		totalSize := view layout extent x.
		
		totalSize isZero 
			ifTrue: [ scrollbar sliderPosition: 0; thickness: 1 ]
			ifFalse: [ 
				scrollbar 
					sliderPosition: view offset x / totalSize;
					thickness: (view width/ totalSize min: 1.0)].
	] ifTrue: [ 
		"vertical one"
		| numberOfLines |

		autohide ifTrue: [ 
			"automatically hide if we can"
			view needsVerticalScrolling ifFalse: [ self hide. ^ self ]].

		self visible: true.
		numberOfLines := view text endPosition lineNumber.
		
		scrollbar thickness: (view layout numberOfLines / numberOfLines).
		scrollbar sliderPosition: (view layout startPosition lineNumber - 1) / numberOfLines. 
	
	 ]
]

{ #category : #geometry }
TxScrollbarDecorator >> width [
	^ vertical
		ifTrue: [ scrollbar width ]
		ifFalse: [ super width ]
]
