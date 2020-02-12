
{ File, Document, Packer, Paragraph, TextRun, PageNumber, PageBreak, AlignmentType, Footer, HeadingLevel, TableOfContents, Table, TableCell, TableRow, WidthType, BorderStyle } =require 'docx'

module .exports =require( './factory' ) .define
	headers: ->
		borders =
			top:
				style: BorderStyle .SINGLE
				size: 1
				color: '777777'
			bottom:
				style: BorderStyle .SINGLE
				size: 2
				color: "777777"
			left:
				style: BorderStyle .NONE
				size: 1
				color: "777777"
			right:
				style: BorderStyle .NONE
				size: 1
				color: "777777"
		res =[]
		ds =[]
		ds .push
			s: 'имя'
			width:
				size: 2000
				type: WidthType .DXA
		ds .push
			s: 'тип'
			width:
				size: 1500
				type: WidthType .DXA
		ds .push
			s: 'описание'
			width:
				size: 5300
				type: WidthType .DXA
		for d in ds
			s =d .s .toUpperCase()
			txt =new TextRun
				size: 20
				color: '005B96'
				text: ' ' + s
				bold: true
			p =new Paragraph ##005B96
				children: [ txt ]
				spacing: 
					before: 70
					after: 70
			res .push new TableCell children: [ p ], borders: borders #, width: d .width
		res
	init: ( @method, @group )->
		@list =@method .list
		borders =
			top:
				style: BorderStyle .SINGLE
				size: 1
				color: "777777"
			bottom:
				style: BorderStyle .SINGLE
				size: 1
				color: "777777"
			left:
				style: BorderStyle .NONE
				size: 1
				color: "777777"
			right:
				style: BorderStyle .NONE
				size: 1
				color: "777777"
		rows =[]
		rows .push new TableRow children: @headers(), tableHeader: true
		for parameter in @group
			cells =[]
			txts =[]
			if parameter .data .required #
				txts .push new TextRun
					size: 20
					color: 'FF4500'
					text: '*'
			txts .push new TextRun
				size: 20
				#color: '005B96'
				font: name: 'Monospace'
				text: parameter .data .name
			p =new Paragraph ##005B96
				children: txts
				spacing: 
					before: 70
					after: 70
				indent:
					left: 70
			cells .push new TableCell children: [ p ], borders: borders, width: { size: 2000, type: WidthType .DXA }
			txt =new TextRun
				size: 20
				#color: '005B96'
				font: name: 'Monospace'
				text: parameter .data .schema .type
			p =new Paragraph ##005B96
				children: [ txt ]
				spacing: 
					before: 70
					after: 70
				indent:
					left: 70
			cells .push new TableCell children: [ p ], borders: borders, width: { size: 1500, type: WidthType .DXA }
			txt =new TextRun
				size: 20
				#color: '005B96'
				text: parameter .data .description
			p =new Paragraph ##005B96
				children: [ txt ]
				spacing: 
					before: 70
					after: 70
				indent:
					left: 70
			cells .push new TableCell children: [ p ], borders: borders, width: { size: 5300, type: WidthType .DXA }

			rows .push new TableRow children: cells

		table = new Table
			rows: rows
			# width:
			# 	size: 8835
			# 	type: WidthType.DXA
			# indent:
			# 	left: 300
			# width:
			# 	size: 9000
			# 	type: WidthType.DXA
			spacing: 
				before: 200
			cantSplit: true
			columnWidths: [ 2000, 1500, 5300 ]
			#alignment: AlignmentType .RIGHT
		# @list .push new Paragraph ##005B96
		# 	children: [ table ]
		# 	alignment: AlignmentType .RIGHT
		# 	spacing: 
		# 		before: 150
		@list .push table
		txts =[]
		txts .push new TextRun
			size: 20
			color: 'FF4500'
			text: '*'
		txts .push new TextRun
			size: 20
			#color: '005B96'
			font: name: 'Monospace'
			text: ' - обязательное поле'
		p =new Paragraph ##005B96
			children: txts
			spacing: 
				before: 70
				after: 70
			indent:
				left: 70
		@list .push p
		# for parameter in @group
		# 	txt =new TextRun
		# 		size: 25
		# 		color: '005B96'
		# 		text: JSON .stringify parameter .data
		# 		bold: true
		# 	@list .push new Paragraph ##005B96
		# 		children: [ txt ]
		# 		spacing: 
		# 			before: 200