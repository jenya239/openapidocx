
{ File, Document, Packer, Paragraph, TextRun, PageNumber, PageBreak, AlignmentType, Footer, HeadingLevel, TableOfContents, Table, TableCell, TableRow } =require 'docx'

module .exports =require( './factory' ) .define
	# p: ( opts )->
	# 	txt_opts ={}
	# 	for opt in 'size color text bold'
	# 		txt_opts[ opt ] =opts[ opt ] if opts .hasOwnProperty( opt )
	# 	txt =new TextRun txt_opts
	# 	p_opts =children: [ txt ]
	# 	for opt in 'spacing indent'
	# 		p_opts[ opt ] =opts[ opt ] if opts .hasOwnProperty( opt )
	# 	@list .push new Paragraph p_opts
	header: ( params )->
		txts =[]
		if params .required #
			txts .push new TextRun
				size: 20
				color: 'FF4500'
				text: '*'
		txts .push new TextRun
			size: 22
			#color: '005B96'
			text: params .s1
			bold: true
		if params .s2
			txts .push new TextRun
				size: 22
				#color: '005B96'
				text: params .s2
		p_opts =
			children: txts
			spacing: 
				before: 150
				after: 150
		p_opts .indent =if params .indent then params .indent else { left: 200 }
		@list .push new Paragraph p_opts
	parameters_header: ( opts )->
		txt =new TextRun
			size: 22
			#color: '005B96'
			text: opts .str
			bold: true
		@list .push new Paragraph ##005B96
			children: [ txt ]
			spacing: 
				before: 150
				after: 150
			indent:
				left: 200
	process_parameters: ->
		@parameters ={}
		for obj in @data .parameters
			parameter =require( './parameter' ) .create @, obj
			unless @parameters[ parameter .data .in ]
				@parameters[ parameter .data .in ] =[]
			@parameters[ parameter .data .in ] .push parameter
		if @data .requestBody
			for k, v of @data .requestBody .content
				key =k
				body =v .schema
				break
			@header s1: 'REQUEST BODY - ' + key, required: @data .requestBody .required
			require( './formatter' ) .create @list, @path .json, body[ '$ref' ], 2
		if @parameters .query
			@parameters_header str: 'QUERY PARAMETERS'
			table =require( './table' ) .create @, @parameters .query
		if @parameters .header
			@parameters_header str: 'HEADER PARAMETERS'
			table =require( './table' ) .create @, @parameters .header
	section_header: ( opts )->
		txt =new TextRun
			size: 25
			color: '005B96'
			text: opts .str
			bold: true
		@list .push new Paragraph ##005B96
			children: [ txt ]
			spacing: opts .spacing
	init: ( @path, @name, @number, @data )->
		@list =[]
		s =@path .number + '.' + @number
		s +='. ' + @name .toUpperCase() + ' /' + @path .name
		txt =new TextRun
			text: s
			size: 32
			color: 'B44646'
			font: name: 'Monospace'
		@list .push new Paragraph ##005B96
			children: [ txt ]
			heading: HeadingLevel .HEADING_3
			spacing: 
				after: 300
		txt =new TextRun
			size: 20
			color: 'B44646'
			bold: true
			text: @data .summary
		@list .push new Paragraph ##005B96
			children: [ txt ]
			spacing: 
				after: 50
			#heading: HeadingLevel .HEADING_4 #005B96
		txt =new TextRun
			size: 20
			# color: '000000'
			text: @data .description
		@list .push new Paragraph ##005B96
			children: [ txt ]
			# spacing: 
			# 	before: 200
		@section_header str: 'REQUEST', spacing: { before: 200 }
		@process_parameters() if @data
		@section_header str: 'RESPONSE', spacing: { before: 250, after: 320 }
		for code, response of @data .responses
			@header s1: "STATUS CODE - #{ code }: ", s2: response .description
			if response .content
				for k, v of response .content
					key =k
					body =v .schema
					break
				continue unless body[ '$ref' ]
				@header s1: "RESPONSE MODEL - #{ k }", indent: { left: 400 }
				require( './formatter' ) .create @list, @path .json, body[ '$ref' ], 4

		@section_header str: 'EXAMPLE', spacing: { before: 250, after: 320 }
		example_request ={}
		for obj in @data .parameters
			example_request[ obj .name ] =obj .example if obj .example
		@header s1: "REQUEST", indent: { left: 300 }
		require( './formatter' ) .create @list, example_request, null, 4
		if @data .requestBody
			@header s1: "REQUEST BODY", indent: { left: 300 }
			require( './formatter' ) .create @list, @path .json, body[ '$ref' ], 4, false, true
		@header s1: "RESPONSE", indent: { left: 300 }
		for code, response of @data .responses
			@header s1: "STATUS CODE - #{ code }: ", s2: response .description, indent: { left: 400 }
			if response .content
				for k, v of response .content
					key =k
					body =v .schema
					break
				continue unless body[ '$ref' ]
				@header s1: "RESPONSE MODEL - #{ k }", indent: { left: 600 }
				require( './formatter' ) .create @list, @path .json, body[ '$ref' ], 4, false, true

		@list .push new Paragraph
			border:
				bottom:
					color: "CCCCCC"
					space: 1
					value: "single"
					size: 6
			spacing: 
				after: 500
