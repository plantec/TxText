"
I manage styles for a text, providing at least a default.

Implementation note: except for my default style, I hold the style list weakly, so they will be automatically removed if unused.
"
Class {
	#name : #TxTextStyles,
	#superclass : #Object,
	#instVars : [
		'text',
		'defaultStyle',
		'styles'
	],
	#category : #'TxText-Model'
}

{ #category : #'instance creation' }
TxTextStyles class >> on: aTxModel [
	^ self new initWithText: aTxModel
]

{ #category : #operations }
TxTextStyles >> addStyle: aStyle [
	"Register a new style, but only if none of my existing styles match the argument; answer the registered style"
	
	aStyle = defaultStyle ifTrue: [ ^ defaultStyle ].
	
	^ styles like: aStyle ifAbsent: [ styles add: aStyle ]
	
	
]

{ #category : #accessing }
TxTextStyles >> defaultStyle [
	^ defaultStyle
]

{ #category : #operations }
TxTextStyles >> extend: style with: aNewAttribute [
	"Answer a style, which is the same as the first argument, but with a new/different attribute value."
	| newStyle |
	(style includes: aNewAttribute) ifTrue: [ ^ style ].
	newStyle := style copy add: aNewAttribute.
	^ self addStyle: newStyle
]

{ #category : #initialize }
TxTextStyles >> initWithText: aTxModel [
	text := aTxModel
]

{ #category : #initialize }
TxTextStyles >> initialize [

	self initializeDefaultStyle.
	
	styles := WeakSet new.
]

{ #category : #initialize }
TxTextStyles >> initializeDefaultStyle [

	defaultStyle := TxStyle new.
	
]

{ #category : #copying }
TxTextStyles >> postCopy [
	defaultStyle := defaultStyle copy.
	styles := styles collect: [ :each | each copy ].
]

{ #category : #accessing }
TxTextStyles >> text [
	^ text
]
