
{ Media, File, Document, Packer, Paragraph, TextRun, PageNumber, PageBreak, AlignmentType, Header, Footer, HeadingLevel, TableOfContents, Table, TableCell, TableRow } =require 'docx'
fs =require 'fs'

module .exports =require( './factory' ) .define
	init: ( @json, @tag )->
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
			headers: default: new Header children: [ @header() ]
			footers: 
				#first: new Footer children: [ first_footer ]
				default: new Footer children: [ @footer() ]
			children: @list
	first_footer: ->
		new Paragraph
			alignment: AlignmentType .CENTER
			children: [ new TextRun 'Иваново, 2020 год' ]
			size: 14
			spacing: 
				before: 4000
	new_line: ->
		txt =new TextRun text: ''
		txt .break()
		txt
	new_lines: ( n )->
		res =[]
		for [1..n]
			res .push @new_line()
		res
	# dumb: ->
	# 	@list .push @main .list...
	sstr: ( s, first =false )->
		opts =
			alignment: AlignmentType .CENTER
			indent:
				left: 4200
			children: [ new TextRun s ]
			size: 20
		if first
			opts .spacing =before: 1000
		@list .push new Paragraph opts

	first_page: ->
		txt =new TextRun
			text: 'Общество с ограниченной ответственностью «Альтернатива Софт»'
			size: 20
			bold: true
		@list .push new Paragraph
			alignment: AlignmentType .CENTER
			children: [ txt ]
		@sstr 'УТВЕРЖДЕНА', true
		@sstr 'приказом ООО «Альтернатива'
		@sstr 'Софт»'
		@sstr 'от «28» февраля 2020 года'
		@sstr '№117'
		txt =new TextRun
			text: 'API Reference'
			size: 35
			color: 'B44646'
		@list .push new Paragraph
			alignment: AlignmentType .RIGHT
			children: [ txt ]
			spacing: 
				before: 3000
		txt =new TextRun
			size: 45
			color: '000000'
			text: @json .info .title
		@list .push new Paragraph ##005B96
			alignment: AlignmentType .RIGHT
			children: [ txt ]
			spacing: 
				before: 200
			#heading: HeadingLevel .HEADING_1
		txt =new TextRun
			size: 20
			color: '005B96'
			text: 'Версия API: ' + @json .info .version
		@list .push new Paragraph ##
			alignment: AlignmentType .RIGHT
			children: [ txt ]
		txt =new TextRun
			size: 20
			text: @json .info .description
		@list .push new Paragraph ##
			children: [ txt ]
			spacing: 
				before: 300
		txt =new TextRun
			size: 25
			text: 'КОНТАКТЫ'
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
			text: ': ' + @json .info .contact .email
		@list .push new Paragraph ##
			children: [ txt, txt2 ]
			spacing: 
				before: 200
		@list .push @first_footer()
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
		for k, v of @json .paths
			n += 1
			p =require( './path' ) .create k, n, v, @json, @
			if p .methods_count > 0
				console .log '===', k
				@list .push p .list...

	header: ->
		image =Media .addImage @doc, fs .readFileSync( './logo.png' ), 200, 28
		new Paragraph
			#alignment: AlignmentType .RIGHT,
			children: [
				image
			]
			spacing: 
				after: 800
	footer: ->
		new Paragraph
			alignment: AlignmentType .RIGHT,
			children: [
				new TextRun children: [ PageNumber .CURRENT ]
			]