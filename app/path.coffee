
{ File, Document, Packer, Paragraph, TextRun, PageNumber, PageBreak, AlignmentType, Footer, HeadingLevel, TableOfContents, Table, TableCell, TableRow } =require 'docx'

module .exports =require( './factory' ) .define
	init: ( @name, @number, @data, @json, @builder )->
		@name =@name .replace /\//g, ''
		@list =[]
		txt =new TextRun
			size: 50
			bold: true
			color: 'B44646'
			text: @number + '. ' + @name .toUpperCase()
		@list .push new Paragraph ##005B96
			children: [ txt ]
			spacing: 
				after: 800
				before: 0
			heading: HeadingLevel .HEADING_2
		n =0
		for k, v of @data
			if not v .tags or @builder .tag not in v .tags
				continue
			n += 1
			m =require( './method' ) .create @, k, n, v
			@list .push m .list...
		@methods_count =n
		@list .push new Paragraph children: [ new PageBreak() ]