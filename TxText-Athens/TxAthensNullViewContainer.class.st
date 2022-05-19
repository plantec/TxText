"
A view container is responsible is responsible for taking care about platform-specific duties like connecting view with outer world (like Morphic) in order to handle events etc.
A null container simply ignores all notifications from view.
"
Class {
	#name : #TxAthensNullViewContainer,
	#superclass : #Object,
	#category : #'TxText-Athens'
}

{ #category : #'as yet unclassified' }
TxAthensNullViewContainer >> layoutIsAboutToResetIn: view [
	"ignored"
]

{ #category : #'as yet unclassified' }
TxAthensNullViewContainer >> newEmbeddedObjectCommand: aTxEmbeddedObjectSpan [ 

	self error: 'This container does not supports embedded objects in text'.
]

{ #category : #'as yet unclassified' }
TxAthensNullViewContainer >> viewChanged: layoutView [
	"Received when view is changed, including scrolling or full reset of it.
	Ignored"
]
