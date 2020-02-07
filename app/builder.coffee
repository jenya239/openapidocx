
{ File, Document, Packer, Paragraph, TextRun, PageNumber, PageBreak, AlignmentType, Footer, HeadingLevel, TableOfContents, Table, TableCell, TableRow } =require 'docx'

module .exports =require( './factory' ) .define
	init: ( @main )->
		#@doc = new Document
		@doc = new File
			styles: 
				paragraphStyles: [
					{
						id: 'MySpectacularStyle'
						name: 'My Spectacular Style'
						basedOn: 'Heading1'
						next: 'Heading1'
						quickFormat: true
						run:
							italics: true
							color: '990000'
					}
				]
		@list =[]
		# @dumb()
		@first_page()
		@second()
		@content()
		@doc .addSection
			properties: {}
			footers: default: new Footer children: [ @footer() ]
			children: @list
	new_line: ->
		txt =new TextRun text: ''
		txt .break()
		txt
	new_lines: ( n )->
		res =[]
		for [1..n]
			res .push @new_line()
		res
	dumb: ->
		@list .push @main .list...
	first_page: ->
		txt =new TextRun
			text: 'API Reference'
			size: 35
			color: 'B44646'
		@list .push new Paragraph
			alignment: AlignmentType .RIGHT
			children: [ txt ]
			spacing: 
				before: 3500
		txt =new TextRun
			size: 45
			color: '000000'
			text: @main .json .info .title
		@list .push new Paragraph ##005B96
			alignment: AlignmentType .RIGHT
			children: [ txt ]
			spacing: 
				before: 200
			#heading: HeadingLevel .HEADING_1
		txt =new TextRun
			size: 20
			color: '005B96'
			text: 'API Version: ' + @main .json .info .version
		@list .push new Paragraph ##
			alignment: AlignmentType .RIGHT
			children: [ txt ]
		txt =new TextRun
			size: 20
			text: @main .json .info .description
		@list .push new Paragraph ##
			children: [ txt ]
			spacing: 
				before: 300
		txt =new TextRun
			size: 25
			text: 'CONTACT'
			bold: true
		@list .push new Paragraph ##
			children: [ txt ]
			spacing: 
				before: 300
		txt =new TextRun
			size: 20
			text: 'EMAIL'
			bold: true
		txt2 =new TextRun
			size: 20
			text: ': ' + @main .json .info .contact .email
		@list .push new Paragraph ##
			children: [ txt, txt2 ]
			spacing: 
				before: 200
	second: ->
		@list .push new Paragraph children: [ new PageBreak() ]
		@list .push new TableOfContents 'Index',
			hyperlink: true
			headingStyleRange: '1-5'
	content: ->
		@list .push new Paragraph children: [ new PageBreak() ]
		txt =new TextRun
			text: 'API'
			size: 50
			bold: true
		@list .push new Paragraph ##
			children: [ txt ]
			spacing: 
				after: 0
		n =0
		for k, v of @main .json .paths
			n += 1
			p =require( './path' ) .create k, n, v, @main .json
			@list .push p .list...


	footer: ->
		new Paragraph
			alignment: AlignmentType .RIGHT,
			children: [
				new TextRun children: [ PageNumber .CURRENT ]
			]