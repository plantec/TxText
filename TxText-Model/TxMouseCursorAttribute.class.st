"
I control the mouse cursor appearance when the user holds the mouse over it.
"
Class {
	#name : #TxMouseCursorAttribute,
	#superclass : #TxAttribute,
	#category : #'TxText-Model'
}

{ #category : #defaults }
TxMouseCursorAttribute class >> defaultValue [
	^ Cursor overEditableText
]
