Class {
	#name : #TxTextRenderer,
	#superclass : #Object,
	#instVars : [
		'text',
		'font',
		'canvas',
		'glyphRenderer',
		'color',
		'advance',
		'maxAscent',
		'currentLine'
	],
	#category : #'TxText-Athens'
}

{ #category : #'as yet unclassified' }
TxTextRenderer class >> textGoryDetails [

"
Took from: http://www.freetype.org/freetype2/docs/tutorial/step2.html

(Font face metrics)
In this case, you can access the global design metrics as:

units_per_EM 	

This is the size of the EM square for the font face. It is used by scalable formats to scale design coordinates to device pixels, as described in the last chapter of this section. Its value usually is 2048 (for TrueType) or 1000 (for Type 1), but others are possible too. It is set to 1 for fixed-size formats like FNT/FON/PCF/BDF.

bbox 	

The global bounding box is defined as the largest rectangle that can enclose all the glyphs in a font face.

ascender 	

The ascender is the vertical distance from the horizontal baseline to the highest ‚Äòcharacter‚Äô coordinate in a font face. Unfortunately, font formats define the ascender differently. For some, it represents the ascent of all capital latin characters (without accents), for others it is the ascent of the highest accented character, and finally, other formats define it as being equal to bbox.yMax.

descender 	

The descender is the vertical distance from the horizontal baseline to the lowest ‚Äòcharacter‚Äô coordinate in a font face. Unfortunately, font formats define the descender differently. For some, it represents the descent of all capital latin characters (without accents), for others it is the ascent of the lowest accented character, and finally, other formats define it as being equal to bbox.yMin. This field is negative for values below the baseline.

height 	

This field is simply used to compute a default line spacing (i.e., the baseline-to-baseline distance) when writing text with this font. Note that it usually is larger than the sum of the ascender and descender taken as absolute values. There is also no guarantee that no glyphs extend above or below subsequent baselines when using this distance.

max_advance_width 	

This field gives the maximum horizontal cursor advance for all glyphs in the font. It can be used to quickly compute the maximum advance width of a string of text. It doesn't correspond to the maximum glyph image width!

max_advance_height 	

Same as max_advance_width but for vertical text layout.

underline_position 	

When displaying or rendering underlined text, this value corresponds to the vertical position, relative to the baseline, of the underline bar's center. It is negative if it is below the baseline.

underline_thickness 	

When displaying or rendering underlined text, this value corresponds to the vertical thickness of the underline.


"
]

{ #category : #accessing }
TxTextRenderer >> advance: ad [
	
	canvas pathTransform translateBy: ad
]

{ #category : #accessing }
TxTextRenderer >> canvas [
	^ canvas
]

{ #category : #initialization }
TxTextRenderer >> initialize [
	super initialize.
	color := Smalltalk ui theme textColor.
]

{ #category : #rendering }
TxTextRenderer >> render: aText lines: lines on: aCanvas [

	text := aText.
	canvas := aCanvas.
	
	canvas pathTransform restoreAfter: [

		lines do: [:line | |  |
			currentLine := line.
			maxAscent := line maxAscent.
			"set the origin to font's baseline position"
			canvas pathTransform translateX: 220 Y: maxAscent.
			"reset advance"
			advance := 0@0.
			canvas pathTransform restoreAfter: [
				line renderOn: self ].
			"line is rendered, advance vertically by line height"
			canvas pathTransform translateX: 0 Y: line height * 1.2 - maxAscent.
		] ]
]

{ #category : #rendering }
TxTextRenderer >> renderCharacters: aString from: start to: stop [ 
	

	" accumulate advance while rendering spans"
	"canvas drawShape: (advance x @ advance y extent: 2 @ 2)."
	canvas 
		setPaint: color;
		setFont: font;
		drawString: aString from: start to: stop
]

{ #category : #rendering }
TxTextRenderer >> renderEndOfLineMark [
	canvas 
		setPaint: Color red;
		drawShape: (0@ 0 corner: 10@ -10).
]

{ #category : #rendering }
TxTextRenderer >> renderLines: lines on: aCanvas [

	canvas := aCanvas.
	
	canvas pathTransform restoreAfter: [
		lines do: [:line | |  |
			currentLine := line.
			maxAscent := line maxAscent.
			"set the origin to font's baseline position"
			canvas pathTransform translateX: 0 Y: maxAscent.
			"reset advance"
			advance := 0@0.
			
			canvas pathTransform restoreAfter: [
				line renderOn: self ].
			
			
			"line is rendered, advance vertically by line height"
			canvas pathTransform translateX: 0 Y: line height - maxAscent.

"			canvas pathTransform translateX: 0 Y: line height * 1.2 - maxAscent."
		] ]
]

{ #category : #rendering }
TxTextRenderer >> renderMorph: aMorph [

	canvas pathTransform restoreAfter: [  
	"	canvas pathTransform translateX: 0 Y: aMorph height negated. "
		
		aMorph currentPosition: (canvas pathTransform transform: 0@0).
	"	canvas fullDrawMorph: aMorph."
	]
]

{ #category : #accessing }
TxTextRenderer >> setColor: aColor [ 
	color := aColor.
]

{ #category : #accessing }
TxTextRenderer >> setFont: aFont [ 
	font := aFont
]
