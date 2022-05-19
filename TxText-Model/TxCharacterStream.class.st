"
I am a specialized read-only stream for extracting  characters out of text. Text may hold any objects, not just characters. I will filter out those that can not be represented by characters.

Please note: modifying the text while using gives undefined results, since any modification of text invalidates all external positions. Thus, special care must be taken to reinitialize my position to a valid  position. Handling the position updates is, of course, not the responsibility of this classs, since it cannot know, nor predict, what kind of modification it may be and where it will occur and how it will affect the position it holds.

The only responsibility of this class is to provide a convenient stream for reading character data from text.
"
Class {
	#name : #TxCharacterStream,
	#superclass : #Stream,
	#instVars : [
		'position'
	],
	#category : #'TxText-Model'
}

{ #category : #'instance creation' }
TxCharacterStream class >> on: txModel [
	^ self onPosition: txModel startPosition 
]

{ #category : #'instance creation' }
TxCharacterStream class >> onPosition: aTxPosition [
	^ self basicNew position: aTxPosition
]

{ #category : #accesing }
TxCharacterStream >> isAtEnd [

	^ position isAtEnd 
]

{ #category : #accesing }
TxCharacterStream >> next [
	| char |
	
	[ 
		position := position nextPosition.
		char := position getCharacter.
		char ifNotNil: [ ^ char ].
		position isAtEnd ifTrue: [ ^ nil ].
	] repeat.
]

{ #category : #accesing }
TxCharacterStream >> position [
	^ position
]

{ #category : #accesing }
TxCharacterStream >> position: aTxPosition [
	position := aTxPosition asPosition
]

{ #category : #accesing }
TxCharacterStream >> text [
	^ position text
]
