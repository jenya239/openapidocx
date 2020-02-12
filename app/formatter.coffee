
{ File, Document, Packer, Paragraph, TextRun, PageNumber, PageBreak, AlignmentType, Footer, HeadingLevel, TableOfContents, Table, TableCell, TableRow } =require 'docx'

module .exports =formatter =require( './factory' ) .define
	str: ( s1, s2 ='', s3 ='', level =0 )->
		s2 ='' + s2
		txts =[]
		s1 =s1 + '*' if @obj .required and s1 in @obj .required
		txts .push new TextRun
			text: ' ' .repeat( @indent + level * 2 ) + s1 .padEnd( 12, ' ' )
			font: name: 'Monospace'
		if s2
			txts .push new TextRun
				text: s2 .padEnd( 12, ' ' )
				color: 'AAAAAA'
				font: name: 'Monospace'
		txts .push new TextRun
			text: s3
			color: 'AAAAAA'
			size: 16
			font: name: 'Monospace'
		@list .push new Paragraph ##005B96
			children: txts
			# indent:
			# 	left: 200 * level + @indent
	init: ( @list, @root, @ref, @indent =0, @inner =false, @example =false )->
		#jsonref =require 'jsonref'
		if @ref
			@obj =require( './ref' ) .retrive @root, @ref
			@str '{' unless @inner
			for k, v of @obj .properties
				if v[ '$ref' ]
					#@str k, 'asdf', v[ '$ref' ], 1
					k =k + '*' if @obj .required and k in @obj .required
					@str k + ' {', '', '', 1
					formatter .create @list, @root, v[ '$ref' ], @indent + 2, true, @example
				else
					if @example
						@str( k, v .example, '', 1 ) if v .hasOwnProperty( 'example' )
					else
						@str k, v .type, v .description, 1
			@str '}'
		else
			@obj =@root
			@str '{'
			for k, v of @obj
				@str k, v, '', 1
			@str '}'
		@str '* - обязательное поле'

		#@str JSON .stringify @obj