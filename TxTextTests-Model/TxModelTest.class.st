Class {
	#name : #TxModelTest,
	#superclass : #TestCase,
	#instVars : [
		'text',
		'selection',
		'cursor'
	],
	#category : #'TxTextTests-Model'
}

{ #category : #convenience }
TxModelTest >> newText: aString [
	
	text := TxModel new.
	
	text endPosition insert: aString.
	selection := text endPosition asSelection.
	cursor := selection end.
]

{ #category : #running }
TxModelTest >> setUp [
	super setUp.
	
	text := TxModel new.
	selection  := text newSelection.
	cursor := selection end
]

{ #category : #'test-attribute' }
TxModelTest >> testApplyAttributeAndMerge [
	"When you apply an TxAttribute on a span and is neighboor have the same collection of attribute you have to merge them"
	|color |
	self newText: 'AAACCC'.
	color := TxBackColorAttribute with: #something.
	
	selection all. 
	selection end moveToStart moveRight:3.
	
	selection applyAttribute:  color.  " <<  AAA CCC  >>"
	self assert: text spans size = 4.

	selection start moveToEnd.
	selection applyAttribute: color.  "CCC is now colored"
	
	"text spans second attributes = text spans third attributes"
	self assert: text spans size = 3. " <<  AAACCC  >>"
	cursor moveToStart.
	self assert: ((cursor  span  style) get: TxBackColorAttribute) equals: #something.
]

{ #category : #'test-attribute' }
TxModelTest >> testApplyAttributeAndMerge2 [
	| color |
	self newText: 'AABBCC'.
	color := TxBackColorAttribute with: #something.
	selection beSelection end moveLeft: 2.
	selection start moveLeft: 4.
	
	selection applyAttribute:  color.
	self assert: text spans size = 5.  "<<  'AA' 'BB' 'CC'  >>"
	selection all.
	
	selection applyAttribute:  color.
	
	self assert: selection isValid.
	
	self assert: text spans size = 3. "<<  'AABBCC'  >>"
	cursor moveToStart.
	self assert: ((cursor  span style) get: TxBackColorAttribute) equals: #something.
]

{ #category : #'test-attribute' }
TxModelTest >> testApplyColor [
	| color |
	self newText: 'AAACCC'.
	color := TxBackColorAttribute with: Color red.
	
	selection all.
	
	selection applyAttribute:  color.
	"use start position because there are one span "
	self assert: (text startSpan next getAttribute: TxBackColorAttribute) equals: Color red.
	
]

{ #category : #'test-attribute' }
TxModelTest >> testApplyFontMultipleLine [
	"When applying same attribute over whole text, all spans should have it"
	
	| font |
	self newText: String cr,'AAA',String cr,'CCC',String cr,'ttt',String cr.
	font := TxFontAttribute new.
	selection all.
	selection applyAttribute: font.

	text spans do: [:span |
		self assert: (span style includes: font) ]

]

{ #category : #'test-attribute' }
TxModelTest >> testApplyFontOnDifferentSpan [
	"We can have only one or two split apply on a TextModel "
	|color font |
	self newText: 'AAACCC'.
	self assert: text spans size = 3.
	color := TxBackColorAttribute with: Color red.
	font := TxFontAttribute with: #something.
	selection end moveLeft: 2.
	selection start moveLeft: 4.
	selection applyAttribute:  color.
	selection all.
	selection applyAttribute: font.
	cursor moveToStart.
	self assert: text spans size = 5.
	self assert: ((cursor  span  style) get: TxFontAttribute) equals: #something.
	cursor moveRight:3.
	self assert: ((cursor  span  style) get: TxFontAttribute) equals: #something.
	cursor moveRight:3.
	self assert: ((cursor  span  style) get: TxFontAttribute) equals: #something.
]

{ #category : #'test-attribute' }
TxModelTest >> testApplyFontOnDifferentSpanOffsetBeforeTheFirstSpan [
	"We can have only one or two split apply on a TextModel "
	|color font  |
	self newText: 'AAA','CCC'.
	self assert: text spans size = 3.
	color := TxBackColorAttribute new.
	font := TxFontAttribute with: #something.
	selection end moveLeft: 2.
	selection start moveLeft: 4.
	selection applyAttribute:  color.
	selection all.
	selection start moveRight.
	selection applyAttribute: font.
	cursor moveToStart.
	self assert: text spans size = 6.
	self assert: ((cursor  span  style) get: TxFontAttribute) equals: (TxFontAttribute defaultValue).
	cursor moveRight:2.
	self assert: ((cursor  span  style) get: TxFontAttribute) equals:  #something.
	cursor moveRight.
	self assert: ((cursor  span  style) get: TxFontAttribute) equals:  #something.
	cursor moveRight: 3.
	self assert: ((cursor  span  style) get: TxFontAttribute) equals:  #something.
]

{ #category : #'test-attribute' }
TxModelTest >> testApplyFontOnOneSpan [
	|font|
	self newText: 'AAACCC'.
	font := TxFontAttribute with: #fakeFont.
	
	selection all.
	
	selection applyAttribute:  font.
	"use start position because there are one span "
	self assert: (selection start span getAttribute: TxFontAttribute) equals: #fakeFont.
	
]

{ #category : #'test-attribute' }
TxModelTest >> testApplyFontWithOneSplit [
	"We can have only one or two split apply on a TextModel "
	|color |
	self newText: 'AAACCC'.
	self assert: text spans size = 3. "<< AAACCC >>"
	color := TxBackColorAttribute with: #foo.

	selection start moveToStart.
	selection end moveToStart moveRight: 3.

	selection applyAttribute: color.
	self assert: text spans size equals: 4.
	cursor moveToStart.
	self assert: (cursor span style get: TxBackColorAttribute) equals: #foo.
	cursor moveToEnd.
	self assert: (cursor span style get: TxBackColorAttribute) equals: (TxBackColorAttribute defaultValue).
]

{ #category : #'test-attribute' }
TxModelTest >> testApplyFontWithOneSplitAtEnd [
	"We can have only one or two split apply on a TextModel "
	| color originalColor |
	self newText: 'AAACCC'.
	originalColor := text defaultStyle get: TxBackColorAttribute.
	color := TxBackColorAttribute with: #foo.
	selection := text newSelection.
	selection start moveRight: 3.

	selection applyAttribute: color.
	
	self assert: text spans size equals: 4.
	
	cursor moveToEnd.
	self assert: (cursor span style get: TxBackColorAttribute) equals: #foo.

	cursor moveToStart.
	self assert: (cursor span style get: TxBackColorAttribute) equals: originalColor.
]

{ #category : #'test-attribute' }
TxModelTest >> testApplyFontWithOneSplitAtStart [
	"We can have only one or two split apply on a TextModel "
	| color originalColor |
	self newText: 'AAACCC'.
	originalColor := text defaultStyle get: TxBackColorAttribute.
	self assert: text spans size equals: 3.
	color := TxBackColorAttribute with: #foo.
	
	selection := text newSelection.
	selection end moveLeft: 3.
	
	selection applyAttribute:  color.

	self assert: text spans size equals: 4.
	
	cursor moveToStart.	
	self assert: (cursor span style get: TxBackColorAttribute) equals: #foo.

	cursor moveToEnd.
	self assert: (cursor span style get: TxBackColorAttribute) equals: originalColor.
]

{ #category : #'test-attribute' }
TxModelTest >> testApplyFontWithTwoSplit [
	"We can have only one or two split apply on a TextModel "
	| color default |
	self newText: 'AAACCC'.
	self assert: text spans size equals: 3.
	color := TxBackColorAttribute with: #foo.
	default := text defaultStyle get: TxBackColorAttribute.
	
	selection beSelection end moveLeft: 2.
	selection start moveLeft: 4.

	selection applyAttribute: color.

	self assert: text spans size equals: 5.

	cursor moveToStart.
	self assert: (cursor span style get: TxBackColorAttribute) equals: default.

	cursor moveRight: 3.
	self assert: (cursor span style get: TxBackColorAttribute) equals: #foo.

	cursor moveRight: 3.
	self assert: (cursor span style get: TxBackColorAttribute) equals: default.
]

{ #category : #'test-attribute' }
TxModelTest >> testApplySameFont [
	"I made this test because for other attribute like bold if you apply this attribute when it already on the span the attribute is removed "
	| font |
	self newText: 'AAACCC'.
	font := TxFontAttribute with: #fakeFont.
	
	selection all.
	
	selection applyAttribute: font.
	"use start position because there are one span "
	self assert: (selection start span style get: TxFontAttribute) equals: #fakeFont.
	
	selection applyAttribute:  font.
	
	self assert: (selection start span style get: TxFontAttribute) equals: #fakeFont.
]

{ #category : #'test-attribute' }
TxModelTest >> testApplyingAttributeShouldNotChangeSelection [
	| pos1 pos2 |
	self newText: '123456'.
	selection all.
	selection start moveRight: 2.
	selection end moveLeft.
	
	
	pos1 := selection start asTextIndex.
	pos2 := selection end asTextIndex.
	
	selection applyAttribute:  TxFontAttribute new.
	
	self assert: selection start asTextIndex = pos1.
	self assert: selection end asTextIndex = pos2.
	

]

{ #category : #'test-attribute' }
TxModelTest >> testApplyingAttributeTwiceShouldNotChangeSameSelectionPositions [
	| pos1 pos2 |
	self newText: '123456'.
	selection all.
	selection start moveRight: 2.
	selection end moveLeft.
	
	
	pos1 := selection start asTextIndex.
	pos2 := selection end asTextIndex.
	
	selection applyAttribute:  TxFontAttribute new.
	selection applyAttribute:  TxFontAttribute new.
	
	self assert: selection start asTextIndex = pos1.
	self assert: selection end asTextIndex = pos2.
	

]

{ #category : #'tests-navigation' }
TxModelTest >> testBackspaceKey [
	
	self newText: 'ABC',String cr,'DEF'.
	
	"place cursor to the start of second line"

	selection := text startPosition moveDown asSelection.
	
	selection backspaceKey.
	
	self assert: text asString equals: 'ABCDEF'.
	
	selection backspaceKey.

	self assert: text asString equals: 'ABDEF'.

	selection start moveToEnd.
	selection end moveToEnd.
	selection backspaceKey.

	self assert: text asString equals: 'ABDE'.

]

{ #category : #'tests-selection' }
TxModelTest >> testCopyText [
	| newText |	
	self newText: 'ABCDEF'.

	selection all.	
	selection start moveRight.
	selection end moveLeft.
	
	newText := selection copyText.
	
	self assert: newText asString equals: 'BCDE'.


]

{ #category : #'tests-default state' }
TxModelTest >> testCursorShouldBeAtStartAndEndBoth [

	self assert: cursor isAtStart.
	self assert: cursor isAtEnd.
]

{ #category : #'tests-navigation' }
TxModelTest >> testCut [
	self newText: 'ABCDEF'.
	
	selection all.
	selection end moveLeft: 2.
	selection start moveRight: 2.
	
	selection cut.

	self assert: text asString equals: 'ABEF'
]

{ #category : #'tests-navigation' }
TxModelTest >> testCutMultiline [
	
	self newText: 'ABC',String cr,'DEF'.
	selection all.
	selection end moveLeft: 2.
	selection start moveRight: 2.
	
	self assert: selection start lineNumber equals: 1.
	selection cut.

	self assert: text asString equals: 'ABEF'
]

{ #category : #'tests-navigation' }
TxModelTest >> testCutMultiline2 [

	self newText: 'ABC',String cr, 	'zzzz' , String cr , 'DEF'.
	selection all.
	selection end moveLeft: 2.
	selection start moveRight: 2.
	
	self assert: selection start lineNumber equals: 1.
	selection cut.

	self assert: text asString equals: 'ABEF'
]

{ #category : #'tests-navigation' }
TxModelTest >> testDeleteKey [

	self newText: 'ABC',String cr,'DEF'.
	
	cursor moveToStart moveToLineEnd.

	selection 
		start: cursor;
		end: cursor.
		
	selection deleteKey.
	
	self assert: text asString equals: 'ABCDEF'.
	
	selection deleteKey.
	self assert: text asString equals: 'ABCEF'
]

{ #category : #'tests-navigation' }
TxModelTest >> testDeleteKeyBeforeTwoLines [

	self newText: 'ABC', String cr, String cr, 'DEF'.
	
	cursor moveToStart.
	cursor linePosition: 3.
	
	selection := cursor asSelection.
	
	selection deleteKey.
	selection deleteKey.
	
	self assert: text asString equals: 'ABCDEF'.
	
	self assert: cursor lineNumber equals: 1.
	self assert: cursor linePosition equals: 3
]

{ #category : #'tests-navigation' }
TxModelTest >> testDeleteKeyBetweenThreeEmptyLines [

	self newText: 'ABC', String cr, String cr, String cr, 'DEF'.
	
	cursor moveToStart; moveToLineEnd; moveRight.
	self assert: cursor lineNumber equals: 2.
	self assert: cursor linePosition equals: 0.
	
	selection := cursor asSelection.
	selection deleteKey.
	
	self assert: text asString equals: 'ABC

DEF'.
]

{ #category : #'tests-navigation' }
TxModelTest >> testDeleteKeyBetweenTwoEmptyLinesThenMoveRightAndLeftTwice [

	self newText: 'ABC', String cr, String cr, 'DEF'.
	
	cursor moveToStart; moveToLineEnd; moveRight.
	self assert: cursor lineNumber equals: 2.
	self assert: cursor linePosition equals: 0.
	
	selection := cursor asSelection.
	selection deleteKey.
	
	self assert: text asString equals: 'ABC
DEF'.
	cursor moveRight; moveLeft; moveLeft.
		
	self assert: cursor lineNumber equals: 1.
	self assert: cursor linePosition equals: 3
]

{ #category : #'tests-positionDiff' }
TxModelTest >> testDifferenceEquivalentToMovingRight [
	| start  end |
	self newText: 'ABC', String cr, 'DEF'.

	start := text startPosition.
	end := text endPosition.
	
	self assert: end -- start = -7.
	self assert: start -- end = 7.

	self assert: (end + (-7) ) isAtStart.
	self assert: (start + (7) ) isAtEnd.
				

]

{ #category : #'tests-navigation' }
TxModelTest >> testDown [

	self newText: 'ABC', String cr, 'DEF'.

	cursor moveToStart.	
	cursor moveDown.

	self assert: cursor lineNumber equals: 2.
	self assert: cursor linePosition equals: 0.
	
	cursor moveDown.
	self assert: cursor isAtEnd.
]

{ #category : #'tests-navigation' }
TxModelTest >> testEmptyLine [
	
	self newText: String cr. 

	self assert: cursor isAtEnd.
	self assert: cursor lineNumber equals: 2.
	
	cursor moveToStart.
		
	self assert: cursor lineNumber equals: 1.
	
	cursor moveRight.
	
	self assert: cursor lineNumber equals: 2.

	cursor moveToStart.
	cursor moveDown.
	
	self assert: cursor lineNumber equals: 2.


]

{ #category : #'tests-navigation' }
TxModelTest >> testEmptyLines [
	
	self newText: String cr, String cr, String cr. 
	
	self assert: cursor isAtEnd.	
	self assert: cursor lineNumber equals: 4.
	

]

{ #category : #'tests-navigation' }
TxModelTest >> testEmptyLinesAtStartOfText [
	
	self newText: String cr, String cr, String cr, 'CDE'. 
	
	self assert: cursor isAtEnd.
	self assert: cursor lineNumber equals: 4
]

{ #category : #'tests-attributes accessing' }
TxModelTest >> testGettingAbsentAttribute [

	|  actual attributeClass |
	
	attributeClass := TxMockAttribute.
	actual := text defaultStyle get: attributeClass.
	
	self assert: actual equals: attributeClass defaultValue 
]

{ #category : #'tests-attributes accessing' }
TxModelTest >> testGettingExistedAttribute [

	| actual |
		
	text defaultStyle add: TxFontAttribute with: #font.
	
	actual := text defaultStyle get: TxFontAttribute.
	
	self assert: actual == #font
	
]

{ #category : #'tests-model basics' }
TxModelTest >> testGettingSelectionOfNewText [
	"Asking for selection from any text instance, should give a selection holding whole text"

	| sel |
	
	text := TxModel new.
	
	sel := text newSelection.
	
	self assert: sel start isAtStart.
	self assert: sel end isAtEnd.
	self assert: sel text == text.  "identity equal!"
]

{ #category : #'tests-model basics' }
TxModelTest >> testGettingSelectionOfNonEmptyText [
	"Asking for selection from any text instance, should give a selection holding whole text"
	| sel |
	
	text := TxModel new.
	text endPosition insert:'something'.
	
	sel := text newSelection.
	
	self assert: sel start isAtStart.
	self assert: sel end isAtEnd.
	self assert: sel text == text.  "identity equal!"
]

{ #category : #'tests-insertion' }
TxModelTest >> testInsert [
	
	self newText: 'AAACCC'.
	
	self assert: cursor linePosition equals: 6.
	
	cursor linePosition: 3.
	self assert: cursor linePosition equals: 3.
	
	cursor insert: 'bbb'.
	
	self assert: text asString equals: 'AAAbbbCCC'.
	
	self assert: cursor linePosition equals: 6

]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertAtCurrentPosition [
	
	self newText: 'ABC'.
	
	self assert: text asString equals: 'ABC'.
	
	self assert: cursor isAtEnd.
	self deny: cursor isAtStart.
	
	self assert: cursor linePosition equals: 3.
	self assert: cursor lineNumber equals: 1
]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertAtEnd [
	
	self newText: 'ABC'.
	
	cursor moveToEnd. 
	
	self assert: cursor isAtEnd.
	
	cursor insert: 'xyz'.
	
	self assert: text asString equals: 'ABCxyz'.
	self assert: cursor linePosition equals: 6

]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertAtStart [
	
	self newText: 'ABC'.
	
	cursor moveToStart.
	
	self assert: cursor isAtStart.
	cursor insert: 'xyz'.
	
	self assert: text asString equals: 'xyzABC'.	
	self assert: cursor linePosition equals: 3

]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertEmptyLine [
	
	self newText: 'AAACCC'.

	cursor linePosition: 3.	
	cursor insert: String cr.
	
	self assert: text asString equals: 'AAA', String cr, 'CCC'.
	
	self assert: cursor lineNumber equals: 2.
	self assert: cursor linePosition equals: 0.
	self assert: text spans size equals: 5.
	
]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertEmptyLineAtEndThenBackspaceThenDelete [
	
	self newText: 'ABC'.
	
	cursor moveToEnd. 
	cursor insert: String cr.
	
	selection backspaceKey.
	selection deleteKey.
	
	self assert: selection end isAtEnd.
	
	self assert: text asString equals: 'ABC'.
	self assert: selection end linePosition equals: 3

]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertEmptyLineAtEndThenMoveLeftThenDelete [
	
	self newText: 'ABC'.
	
	cursor moveToEnd. 
	cursor insert: String cr.
	
	cursor moveLeft.
	selection := cursor asSelection.
	
	selection deleteKey.
	
	self assert: selection end isAtEnd.
	
	self assert: text asString equals: 'ABC'.
	self assert: selection end linePosition equals: 3

]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertEmptyLineAtStartThenMoveLeftThenDelete [
	
	self newText: 'ABC'.
	
	cursor moveToStart. 
	cursor insert: String cr.
	cursor moveLeft.
	selection := cursor asSelection.
	selection deleteKey.
	
	cursor := selection end.
	
	self assert: cursor isAtStart.
	
	self assert: text asString equals: 'ABC'.
	self assert: cursor linePosition equals: 0

]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertEmptyLineThenBacksaceThenInsertLineThenMoveRightThenMoveLeftTwice [
	
	self newText: 'AAACCC'.

	cursor linePosition: 3.	
	cursor insert: String cr.
	selection := cursor asSelection.
	selection backspaceKey.
	cursor := selection end.
	cursor insert: String cr.
	
	self assert: text asString equals: 'AAA', String cr, 'CCC'.
	
	cursor moveRight.
	cursor moveLeft.
	cursor moveLeft.
	self assert: cursor lineNumber equals: 1.
	self assert: cursor linePosition equals: 3.
	
]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertEmptyLineThenMoveRightThenMoveLeftTwice [
	
	self newText: 'AAACCC'.

	cursor linePosition: 3.	
	cursor insert: String cr.
	
	self assert: text asString equals: 'AAA', String cr, 'CCC'.
	
	cursor moveRight.
	cursor moveLeft.
	cursor moveLeft.
	self assert: cursor lineNumber equals: 1.
	self assert: cursor linePosition equals: 3.
	
]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertMultilineString [
	
	self newText: 'AAACCC'.

	cursor linePosition: 3.	
	cursor insert: 'bb', String cr, 'bb'.
	
	self assert: text asString equals: 'AAAbb', String cr, 'bbCCC'.
	
	self assert: cursor lineNumber equals: 2.
	self assert: cursor linePosition equals: 2
]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertNewLineShouldChangeTextEndSpan [
	
	self newText: 'AAACCC'.

	cursor linePosition: 3.	
	cursor insert: String cr.
	
	self assert: text asString = ('AAA',String cr,'CCC').
	self assert: cursor lineNumber equals: 2.
]

{ #category : #'tests-insertion' }
TxModelTest >> testInsertTwoEmptyLinesThenDeleteFirstAndMoveRight [
	
	self newText: 'AAACCC'.

	cursor linePosition: 3.	
	cursor insert: String cr; insert: String cr.
	cursor moveToStart.
	cursor linePosition: 3.	
		
	selection := cursor asSelection. 
	selection deleteKey.
	cursor moveRight.
	
	self assert: text asString equals: 'AAA', String cr, 'CCC'.
	
	self assert: cursor lineNumber equals: 2.
	self assert: cursor linePosition equals: 0.
	
]

{ #category : #'test-attribute' }
TxModelTest >> testInsertingNewLinePreservesAttributes [
	
	self newText: 'AAACCC'.
	
	cursor linePosition: 3.
	self assert: cursor linePosition equals: 3.
	
	cursor insert: 'bbb'.
	
	self assert: text asString equals: 'AAAbbbCCC'.
	
	self assert: cursor linePosition equals: 6

]

{ #category : #'tests-navigation' }
TxModelTest >> testLeftMultiLine [

	self newText: 'ABC', String cr, 'DEF'.
	
	cursor moveLeft: 3.
	self assert: cursor lineNumber equals: 2.
	self assert: cursor linePosition equals: 0.
	
	cursor moveLeft.
	self assert: cursor lineNumber equals: 1.
	self assert: cursor linePosition equals: 3.
]

{ #category : #'tests-navigation' }
TxModelTest >> testLeftSingleLine [
	
	self newText: 'ABC'.
	
	self deny: cursor isAtStart.
	
	cursor moveLeft: 3.
	self assert: cursor isAtStart.
	
	cursor moveLeft.
	self assert: cursor isAtStart.
]

{ #category : #'tests-navigation' }
TxModelTest >> testLinePosition [
	
	self newText: 'ABC'.
	
	self assert: cursor isAtEnd.
	
	cursor linePosition: 1.
	self deny: cursor isAtStart.
	self assert: cursor linePosition equals: 1.
	self deny: cursor isAtEnd.
	
	cursor linePosition: 0.
	self assert: cursor isAtStart.
	self assert: cursor linePosition equals: 0.
	self deny: cursor isAtEnd.
	
]

{ #category : #'tests-navigation' }
TxModelTest >> testMinMax [
	| pos1 pos2  | 

	self newText: 'ABC',String cr,'DEF'.

	pos1 := text startPosition moveRight: 2.
	pos2 := text endPosition moveLeft: 2.
	
	
	self assert:  (pos1 min: pos2 ) equals: pos1.
	self assert:  (pos2 min: pos1 ) equals: pos1.

	self assert: (pos1 max: pos2) equals: pos2.
	self assert: (pos2 max: pos1) equals: pos2.
]

{ #category : #'tests-navigation' }
TxModelTest >> testMoveToLineEnd [

	self newText: 'ac', String cr, 'def', String cr, 'ghi'.
	
	cursor moveToStart.
	cursor moveDown.
	self assert: cursor lineNumber equals: 2.
	self assert: cursor linePosition equals: 0.
	
	cursor moveToLineEnd.
	
	self assert: cursor lineNumber equals: 2.
	self assert: cursor linePosition equals: 3.
]

{ #category : #'tests-selection' }
TxModelTest >> testMultiLinesSelectionAsString [
	
	self newText: 'ABC', String cr, 'DEF'.
	
	selection all.
	selection start moveRight.
	selection end moveLeft.
	
	self assert: selection asString equals: 'BC
DE'.


]

{ #category : #'tests-navigation' }
TxModelTest >> testReplaceAll [
	
	self newText: 'ABC'.

	selection all.	
	selection replaceWith: 'DEF'.

	self assert: text asString equals: 'DEF'
]

{ #category : #'tests-model basics' }
TxModelTest >> testReplaceAllWith [
	| replacementText |
	text := 'hello' asTxModel.
	replacementText := ' world' asTxModel.
	text replaceAllWith: replacementText.
	self assert: text asString equals: replacementText asString.
]

{ #category : #'tests-navigation' }
TxModelTest >> testReplacePart [

	self newText: 'ABCDEF'.
	selection all.
	selection end moveLeft: 3.

	selection replaceWith: 'DEF'.

	self assert: text asString equals: 'DEFDEF'
]

{ #category : #'tests-selection' }
TxModelTest >> testReversedSelectionAsString [
	
	self newText: 'ABCDEF'.

	selection beSelection.
	selection start moveToStart.
	selection end moveToStart.
	selection start moveRight.
	
	self assert: selection asString equals: 'A'.


]

{ #category : #'tests-navigation' }
TxModelTest >> testRightMultiLine [
	
	self newText: 'ABC', String cr, 'DEF'.
	
	cursor moveToStart.
	self assert: cursor lineNumber equals: 1.
	self assert: cursor linePosition equals: 0.
	
	cursor moveRight: 3.
	self assert: cursor lineNumber equals: 1.
	self assert: cursor linePosition equals: 3.
	
	cursor moveRight.
	self assert: cursor lineNumber equals: 2.
	self assert: cursor linePosition equals: 0.
]

{ #category : #'tests-navigation' }
TxModelTest >> testRightSingleLine [

	self newText: 'ABC'.
		
	cursor moveToStart.
	self assert: cursor isAtStart.
	self assert: cursor linePosition equals: 0.
	
	cursor moveRight: 3.
	self assert: cursor isAtEnd.
	self assert: cursor linePosition equals: 3.
	
	cursor moveRight.
	self assert: cursor isAtEnd.
	self assert: cursor linePosition equals: 3.
]

{ #category : #'tests-selection' }
TxModelTest >> testSelectionAll [
	
	self newText: 'ABC', String cr, 'DEF'.
	
	selection all.
	
	self assert: selection start isAtStart.
	self assert: selection end isAtEnd.
]

{ #category : #'tests-selection' }
TxModelTest >> testSelectionAsString [
	
	self newText: 'ABC', String cr, 'DEF'.
	
	selection all.
	selection start moveRight.
	selection end moveLeft.
	
	self assert: selection asString equals: 'BC
DE'.


]

{ #category : #'tests-default state' }
TxModelTest >> testSelectionShouldBeEmptyByDefault [

	self assert: text isEmpty.
	self assert: selection isEmpty
	
]

{ #category : #'tests-model basics' }
TxModelTest >> testSelectionUsesMutableCursors [
	"Check that selection start and end is cursors (mutable positions)"
	| sel start end |
	
	text := TxModel new.
	sel := text newSelection.
	
	start :=  sel start.
	end := sel end.
	
	self assert: start ~~ end.
	
	"moving the end and start does not changes the identity"
	sel end moveToStart.
	sel start moveToEnd.	
	
	self assert: sel start == start.
	self assert: sel end == end. 
]

{ #category : #'tests-selection' }
TxModelTest >> testSingleLineSelectionAsString [
	
	self newText: 'ABCDEF'.

	selection all.	
	selection start moveRight.
	selection end moveLeft.
	
	self assert: selection asString equals: 'BCDE'.


]

{ #category : #'tests-navigation' }
TxModelTest >> testStartEnd [
	| pos |
	self newText: 'ABC', String cr, 'DEF'.
	
	pos := text startPosition.
	
	self assert: pos isAtStart.
	self assert: pos lineNumber equals: 1.
	self assert: pos linePosition equals: 0.
	
	pos := text endPosition.

	self assert: pos isAtEnd.
	self assert: pos lineNumber equals: 2.
	self assert: pos linePosition equals: 3.
]

{ #category : #'tests-navigation' }
TxModelTest >> testTextIndex [
	| pos |
	self newText: 'ABC', String cr, 'DEF'.
	
	pos := text startPosition moveRight: 4.
	
	self assert: pos asTextIndex equals: 4.
	
	pos := text positionAtTextIndex: 4.
	self assert: pos linePosition equals: 0.
	self assert: pos isAtLineStart.
	
	pos := text positionAtTextIndex: 3.

	self assert: pos linePosition equals: 3.
	self assert: pos isAtLineEnd.

]

{ #category : #'tests-default state' }
TxModelTest >> testTextPositionShouldReferToText [


	self assert: text startPosition text == text.
	self assert: text endPosition text == text.
	
	self assert: text startPosition copy text == text.

]

{ #category : #'tests-default state' }
TxModelTest >> testTextShouldBeEmptyByDefault [

	self assert: text isEmpty.
	self assert: text asString equals: String empty.
]

{ #category : #'tests-navigation' }
TxModelTest >> testUp [
	| pos |
	self newText: 'ABC', String cr, 'DEF'.
	
	pos := text endPosition moveUp.
	
	self assert: pos lineNumber equals: 1.
	self assert: pos linePosition equals: 3.
	
	pos := pos moveUp.
	self assert: pos isAtStart.
]
