
{ File, Document, Packer, Paragraph, TextRun, PageNumber, PageBreak, AlignmentType, Footer, HeadingLevel, TableOfContents, Table, TableCell, TableRow } =require 'docx'

module .exports =require( './factory' ) .define
	init: ( @obj, @level =0, @list )->
		for k, v of @obj
			#console .log k
			indent ="    " .repeat @level
			if typeof v is 'object'
				if @level ==0
					@list .push new Paragraph children: [ new PageBreak() ]
				children =[
					new TextRun( text: indent )
					new TextRun( text: k, bold: true )
					new TextRun( text: ': ' )
				]
				p = new Paragraph children: children
				@list .push p
				@create v, @level + 1, @list
			else
				@list .push new Paragraph children: [
					# new TextRun( text: '1111asfasdfasdf' )
					new TextRun( text: indent )
					new TextRun( text: k, bold: true )
					new TextRun( text: ': ' )
					new TextRun( text: v )
				]