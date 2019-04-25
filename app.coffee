
{InputLayer} = require "input"
# Disable Hints
Framer.Extras.Hints.disable()
Nunito = Utils.loadWebFont("Nunito")

document.body.style.cursor = "auto"

#start
mheight = Screen.height
mwidth = Screen.width
widthDesktop = 1000
widthTablet = 700
startDesctopY = 195
startLineY = 100 #start Y for first line
lineHeight = 48 #height of line

drag = false
isClick = false

htUser = 0.1
htName = 0.2
htPosition = 0.35
htStatus = 0.55
htProjects = 0.65

onlines = []
birthdays = []
line = []
avatar = []
selectedAvatar = []
selects = []
selectedLine = []
showingLines = []
selectedTextDefault = "drag users here to create group"

Users = new Layer
	height: mheight
	width: mwidth
	
index = new ScrollComponent
	height: mheight
	parent: Users

index.mouseWheelEnabled = true
index.scrollHorizontal = false

table = new Layer
	parent: index.content

tittle = new TextLayer
	parent: table
		
selectZone = new Layer
	parent: index.content
selectedText = selectedTextDefault
selectZoneLabel = new TextLayer
	parent: selectZone
		
copyright = new TextLayer
	parent: index.content


searchResults = new TextLayer	


inputLine = new Layer
	parent: table
	opacity: 0

request = "All"
	
searchInput = new InputLayer
	parent: table
	backgroundColor: null
	width: Screen.width - 28
	fontSize: 36
	text: "Enter request"
	color: "#C0BBBB"
	fontFamily: Nunito
	padding: 0
	visible: false
	

#json
data = JSON.parse Utils.domLoadDataSync "data/users.json"
users = data.users
usersNumber = users.length
table.height = 95 + 53 * usersNumber + 16

for i in [0...usersNumber]
	showingLines[i] = i

window.onresize = ->
	mwidth = Screen.width
	mheight = Screen.height
	buindInterface()
	

#Creating Desctop Interface
searchForm = () ->
	searchResults.parent = table
	searchResults.x = tittle.x+tittle.width+5
	searchResults.y = 22
	searchResults.text = request + " - found "+ showingLines.length
	searchResults.fontSize = 18
	searchResults.fontFamily = Nunito
	searchResults.color = "#908C8C"
	
	inputLine.x = tittle.x+tittle.width+5
	inputLine.width = 300
	inputLine.height = 1
	inputLine.y = searchResults.y +  searchResults.height - 3
	inputLine.backgroundColor = "#BBD4F2"
	
	searchInput.width = 300
	searchInput.height = 30
	searchInput.y = 18
	searchInput.x = tittle.x+tittle.width+5
	
desctopTableTop = () ->
# Search row
	search.parent = table
	search.x = 24
	search.y = 24
	
	tittle.text = "Users:"
	tittle.fontSize = 18
	tittle.fontFamily = Nunito
	tittle.color = "#908C8C"
	tittle.fontWeight = "bold"
	tittle.y = 22
	tittle.x = 60

	searchForm()
	spacer = new Layer
		backgroundColor: "#EDEDED"
		parent: table
		height: 1
		width: 958
		x: Align.center
		y: 55
				
# table's header	
desctopTableHeader = () ->
	lineWidth = table.width - 28
	hName = new TextLayer
		parent: table
		text: "User"
		fontSize: 12
		fontFamily: Nunito
		color: "#908C8C"
		y: 70
		x: 60
	hPosition = new TextLayer
		parent: table
		text: "Position"
		fontSize: 12
		fontFamily: Nunito
		color: "#908C8C"
		y: 70
		x: table.width*htPosition+14
	hStatus = new TextLayer
		parent: table
		text: "Status"
		fontSize: 12
		fontFamily: Nunito
		color: "#908C8C"
		y: 70
		x: lineWidth*htStatus+14
	hProject = new TextLayer
		parent: table
		text: "Projects"
		fontSize: 12
		fontFamily: Nunito
		color: "#908C8C"
		y: 70
		x: lineWidth*htProjects+14
	
#fill data for one line
fillLines = (i, pos) ->
	color = "#474747"
	lineWidth = table.width - 28
	nickLength = lineWidth*htUser #length of nickname in string
	nameLength = lineWidth*htName#length of name in string
	positionLength = lineWidth*0.1
	statusLength = lineWidth*htStatus #length of position in string
	projectsLength = lineWidth*htProjects #length of projects in string
	
	
	line[i] = new Layer
		parent: table
		name: "line" + pos
		
	line[i].width = lineWidth
	line[i].height = lineHeight
	line[i].y = startLineY + (lineHeight+5) * pos 
	line[i].x = Align.center
	line[i].borderRadius = 5
	line[i].backgroundColor = "#FFFFFF"
	line[i].ind = i
	line[i].draggable.enabled = true
	line[i].selected = false
	line[i].find = true
	
	
	selects[i] = select.copy()
	selects[i].parent = line[i]
	selects[i].width = 20
	selects[i].x = 12
	selects[i].y = Align.center
	selects[i].ind = i
	
	avatar[i] = new Layer
		width: 32
		height: 32
		parent: line[i]
		borderRadius: 3
		y: Align.center
		x: selects[i].x + select.width + 12
		clip: true
		name: "avatar" + i
		
	avatar[i].ind = i
	
	
	photo = new TextLayer
		parent: avatar[i]
		fontFamily: Nunito
		fontSize: 14
		color: "#fff"
		text: i
		x: Align.center
		y: Align.center
	
	selectedAvatar[i] = avatar[i].copy()
	selectedAvatar[i].parent = selectZone
	selectedAvatar[i].visible = false
	selectedAvatar[i].ind = i
	
		
	nick = new TextLayer
		parent: line[i]
		width: nickLength
		height: 16
		text: "#{data.users[i].nickname}"
		fontFamily: Nunito
		fontSize: 14
		fontWeight: "bold"
		color: color
		x: avatar[i].x+avatar[i].width+16
		y:Align.center
		
	name = new TextLayer
		parent: line[i]
		text: "#{data.users[i].firstName}" +" "+ "#{data.users[i].lastName}"
		fontFamily: Nunito
		fontSize: 14
		color: color
		width: nameLength
		x: nick.x+nick.width+16
		y:Align.center
	
	position = new TextLayer
		parent: line[i]
		text: "#{data.users[i].position}"
		fontFamily: Nunito
		fontSize: 14
		color: color
		width: table.width*(htStatus-htPosition)
		x: table.width*htPosition 
		y:Align.center	
		
	status = new Layer
		parent: line[i]
		x: table.width*htStatus
		width: 10
		backgroundColor: null
		height: line[i].height
	
	statusContainer = new Layer
		parent: status
		x: Align.center
		backgroundColor: null
		height: line[i].height	
	
	onlines[i] = online.copy()
	onlines[i].parent = statusContainer
	onlines[i].x = 0
	onlines[i].y = Align.center
	statusContainer.width = 20
	
	#add birthday icon
	if data.users[i].birthday
		birthdays[i] = birthday.copy()
		birthdays[i].parent = statusContainer
		birthdays[i].x = onlines[i].x + 20
		birthdays[i].y = Align.center
		statusContainer.width = statusContainer.width + 20
	statusContainer.x = Align.center
	
	#creating projects	
	projects = new TextLayer
		parent: line[i] 
		text: "#{data.users[i].projects[0]}"
		fontSize: 14
		fontFamily: Nunito
		color: color
		width: table.width*(1-htProjects)
		x: lineWidth*htProjects
		y:Align.center	
	
	if data.users[i].projects.length == 2
		projects.text = projects.text + ", " + "#{data.users[i].projects[1]}"
	
	if data.users[i].projects.length > 2
		for j in [0...2]
			projects.text = projects.text + ", " + "#{data.users[i].projects[j+1]}"
		projects.text = projects.text + ", "+ (data.users[i].projects.length-2) + " more..."	

	line[i].states.normal = 
		shadowX: 0
		shadowY: 0
		shadowBlur: 0
		shadowSpread : 0
		opacity: .7
		shadowColor: "rgba(201,201,201,.5)"
	line[i].states.hover = 
		shadowX: 0
		shadowY: 1
		shadowBlur: 9
		shadowSpread : 3
		opacity: 1
		shadowColor: "rgba(201,201,201,.5)"
	line[i].states.drag = 
		shadowX: 0
		shadowY: 3
		shadowBlur: 12
		shadowSpread : 5
		shadowColor: "rgba(103,134,142,.5)"
		opacity: .5
	line[i].stateSwitch("normal")

heights = () ->
	table.animate
		height: 95 + 53 * showingLines.length + 16
		options:
			time: .2
	table.height = 95 + 53 * showingLines.length + 16
	copyright.animate
		y: table.y + table.height + 100	
		options:
			time: .2
			
#build Selected Zone
drawSelectedAvatars = (i) ->
	selectedAvatar[i].visible = true
	selectedAvatar[i].opacity = 0
	selectedAvatar[i].y = Align.center
	selectedAvatar[i].x = 5 + (32+5)*(selectedLine.length-1)
	selectedAvatar[i].animate
		opacity: 1
		options: 
			time: .2

drawAvatarsInZone = ->
	if selectedLine.length > 0
		j = 0
		for i in [0..usersNumber-1]
			if line[i].selected == true
				selectedAvatar[i].animate
					x: 5 + (32+5)*(j)
					options: 
						time: .2
				j = j + 1
	if selectedLine.length == 0
		selectZoneLabel.animate
			opacity: 1
			options: 
				time: .2		

selectZoneDraw = () ->
	selectZone.width = 400
	selectZone.height = 43
	selectZone.backgroundColor = null
	selectZone.x = Align.center
	selectZone.y = 140
		
	selectZone.style =
		"border-radius": "6px"
		"border-width": "1px"
		"border-color": "#CDD5D7"
		"border-style": "dashed"
	
	
	selectZoneLabel.text = selectedText
	selectZoneLabel.fontSize = 14
	selectZoneLabel.fontFamily = Nunito
	selectZoneLabel.color = "#CDD5D7"
	selectZoneLabel.x = Align.center
	selectZoneLabel.y = Align.center
		
desktopInterface = ->		
	index.width = mwidth
	index.backgroundColor = "#F2F6F7"
	table.width = mwidth*.9
	table.y = startDesctopY
	table.borderRadius = 9
	table.backgroundColor = "#FFFFFF"
	table.x = Align.center
	
	copyright.text = "Copyright FireFly"
	copyright.fontSize = 14
	copyright.fontFamily = Nunito
	copyright.color = "#CDD5D7"
	copyright.x = Align.center
	copyright.y = table.y + table.height + 100
	heights()
	
	logo.parent = index.content
	logo.x = Align.center
	logo.y = 36
	
	selectZoneDraw()
	desctopTableTop()
	desctopTableHeader()
	
	for i in [0...showingLines.length]
		fillLines(showingLines[i], i)
	
	

#popup
flag = "no" # was button pressed
newButton = (parentLayer, text, i, posY) ->
	flag = "no"
	button = new Layer
		parent: parentLayer
		borderRadius: 4
		height: 32
		y: posY
	
	buttonLabel = new TextLayer
		parent: button
		text: text
		fontFamily: Nunito
		fontSize: 18
		fontWeight: "bold"
		color: "#F5F6FA"
	
	button.width = buttonLabel.width + 60
	button.x = Align.center
	
	buttonX = button.x
	buttonWidth = buttonLabel.width + 60
# 	textX


		
	button.states.normal =
		height: 32
# 		y: posY
		width: buttonWidth
# 		x: Align.center
# 		scale: 1
		x: buttonX
		y: posY
		backgroundColor: "#00A8FF"
		shadowX: 1
		shadowY: 4
		shadowBlur: 8
		shadowColor: "rgba(0,168,255,.5)"
	
	button.states.hover =
# 		y: posY - 1
		height: 34
		width: buttonWidth + 6
		x: buttonX - 3
# 		scale: 1.01
		y: posY-2
		backgroundColor: "#0799E5"
		shadowX: 1
		shadowY: 5
		shadowBlur: 9
		shadowColor: "rgba(0,168,255,.5)"
	
	button.states.press =
# 		y: posY - 1
		height: 30
		width: buttonWidth - 2
		x: buttonX+1
# 		x: Align.center - 1
		y: posY+3
		width: buttonLabel.width + 58
		height: 30
		backgroundColor: "#0799E5"
		shadowX: 1
		shadowY: 2
		shadowBlur: 2
		shadowColor: "rgba(0,168,255,.5)"
	
	button.stateSwitch("normal")
	buttonLabel.x = Align.center
	buttonLabel.y = Align.center
	
	
	button.onMouseOver ->
		button.stateSwitch("hover")
		buttonLabel.color = "#E3E5ED"
		buttonLabel.fontSize = 19
		buttonLabel.x = Align.center
		buttonLabel.y = Align.center
	button.onMouseOut ->
		button.stateSwitch("normal")
		buttonLabel.color = "#F5F6FA"
		buttonLabel.fontSize = 18
		buttonLabel.x = Align.center
		buttonLabel.y = Align.center
	button.onMouseDown ->
		button.stateSwitch("press")
		buttonLabel.color = "#E3E5ED"
		buttonLabel.fontSize = 17
		buttonLabel.x = Align.center
		buttonLabel.y = Align.center
	button.onMouseUp ->
		button.stateSwitch("hover")
		buttonLabel.fontSize = 19
		buttonLabel.color = "#E3E5ED"
		buttonLabel.x = Align.center
		buttonLabel.y = Align.center
		flag = text

popupOn = false
popupBack = new Layer
	width: mwidth
	height: mheight
	x : 0
	y: 0
	backgroundColor: "#3D4951"
	opacity: 0
	visible: false



popupUser = (i) ->
	popupOn = true
	popup = new Layer
		parent: Users
		backgroundColor: null
		width: mwidth
		height: mheight
		x : 0
		y: 0
	popupBack.parent = popup
	popupBack.visible = true
			
	uCard = new Layer
		parent: popup
		flat: true
		clip: true
		width: 600
# 		height: 300
		backgroundColor: "#fff"
		borderRadius: 9
		shadowX: 1
		shadowY: 16
		shadowBlur: 24
		shadowSpread : 3
		shadowColor: "rgba(103,134,142,.5)"
		x: Align.center
		
	
	gradient = new Gradient
		start: "#D9EDD0"
		end: "#D6E4E7"
		angle: -90
		
	upicBack = new Layer
		parent: uCard
		width: uCard.width
		height: 132
		x: Align.center
		y: 0
		gradient: gradient
	
	userpic = new Layer
		parent: uCard
		width: 100
		height: 100
		x: 16
		y: 16
		borderRadius: 4
		clip: true
	
	photo = new TextLayer
		parent: userpic
		fontFamily: Nunito
		fontSize: 28
		color: "#fff"
		text: i
		x: Align.center
		y: Align.center	
	
			
	nick = new TextLayer
		parent: uCard
		text: users[i].nickname
		fontFamily: Nunito
		fontSize: 18
		fontWeight: "bold"
		color: "#4A4A4A"
		x: userpic.x + userpic.width + 16
		y: 20
		
	name = new TextLayer
		parent: uCard
		text: users[i].firstName + " " + users[i].lastName
		fontFamily: Nunito
		fontSize: 18
		color: "#4A4A4A"
		x: nick.x
		y: nick.y + nick.height
	
	position = new TextLayer
		parent: uCard
		text: users[i].position
		fontFamily: Nunito
		fontSize: 12
		color: "#4A4A4A"
		x: nick.x
		y: name.y + name.height + 3
	
		
	uTime.parent = uCard
	uTime.x = uCard.width*3/4
	uTime.y = 20
	
	uStatus.parent = uCard
	uStatus.x = uTime.x
	uStatus.y = uTime.y + uTime.height + 10
	
	uVacation.parent = uCard
	uVacation.x = uTime.x
	uVacation.y = uStatus.y + uStatus.height + 10
	
	uBirthday.parent = uCard
	uBirthday.x = uTime.x
	uBirthday.y = uVacation.y + uVacation.height + 10
	
	time = new TextLayer
		parent: uCard
		text: "GMT +" + users[i].contacts[0][1]
		fontFamily: Nunito
		fontSize: 12
		color: "#4A4A4A"
		x: uTime.x + uTime.width + 5
		y: uTime.y + 2
	vacation = new TextLayer
		parent: uCard
		text: users[i].vacation
		fontFamily: Nunito
		fontSize: 12
		color: "#4A4A4A"
		x: uTime.x + uTime.width + 5
		y: uVacation.y + 2
	online = new TextLayer
		parent: uCard
		text: users[i].type
		fontFamily: Nunito
		fontSize: 12
		color: "#4A4A4A"
		x: uStatus.x + uStatus.width + 5
		y: uStatus.y + 2
		
	birthday = new TextLayer
		parent: uCard
		text: users[i].birthdaydate
		fontFamily: Nunito
		fontSize: 12
		color: "#4A4A4A"
		x: uBirthday.x + uBirthday.width + 5
		y: uBirthday.y + 2
	

	
	containerContacts = new Layer
		parent: uCard
		clip: true
		backgroundColor: null
		height: 22
		x: userpic.x
		y: upicBack.height + 20
	
	containerSkills = new Layer
		parent: uCard
		clip: true
		backgroundColor: null
		width: uCard.width*1/4 - 16
		height: 22
		x: uCard.width/2
		y: upicBack.height + 20
	
	containerProjects = new Layer
		parent: uCard
		clip: true
		backgroundColor: null
		width: uCard.width*1/4 - 16
		height: 22
		x: uCard.width*3/4
		y: upicBack.height + 20
		
	hContacts = new TextLayer
		parent: containerContacts
		text: "Contacts"
		fontFamily: Nunito
		fontSize: 18
		fontWeight: "bold"
		color: "#4A4A4A"
		x: 0
		y: 0
	
	hSkills = new TextLayer
		parent: containerSkills
		text: "Skills"
		fontFamily: Nunito
		fontSize: 18
		fontWeight: "bold"
		color: "#4A4A4A"
		x: 0
		y: 0
	
	hProjects = new TextLayer
		parent: containerProjects
		text: "Projects"
		fontFamily: Nunito
		fontSize: 18
		fontWeight: "bold"
		color: "#4A4A4A"
		x: 0
		y: 0
		
	containerContacts.width = hContacts.width
	containerSkills.width = hSkills.width
	containerProjects.width = hProjects.width
	for key in [1..users[i].contacts.length-1]
		contact = new TextLayer
			parent: containerContacts
			textOverflow: "ellipsis"
			text: users[i].contacts[key][0]+": "+users[i].contacts[key][1] 
			fontFamily: Nunito
			fontSize: 14
			color: "#908C8C"
			x: 0
			y: 26*key
		containerContacts.height = containerContacts.height + 26
		containerContacts.width = contact.width if contact.width > containerContacts.width
	
	for key in [0..users[i].skills.length-1]
		skill = new TextLayer
			parent: containerSkills
			text: users[i].skills[key] 
			fontFamily: Nunito
			fontSize: 14
			color: "#908C8C"
			x: hSkills.x
			y: hSkills.y + 26*key + 26
		containerSkills.height = containerSkills.height + 26
		containerSkills.width = skill.width if skill.width > containerSkills.width
		
	for key in [0..users[i].projects.length-1]
		project = new TextLayer
			parent: containerProjects
			text: users[i].projects[key] 
			fontFamily: Nunito
			fontSize: 14
			color: "#908C8C"
			x: hProjects.x
			y: hProjects.y + 26*key + 26
		containerProjects.height = containerProjects.height + 26
		containerProjects.width = project.width if project.width > containerProjects.width
	containerSkills.x = containerContacts.width + 52
	
	uCard.height = containerContacts.height + 162
	if containerSkills.height > containerContacts.height
		infoHeight = containerSkills.height + 162
	if containerProjects.height > containerSkills.height
		infoHeight = containerProjects.height + 162
		
	spacer = new Layer
		backgroundColor: "#EDEDED"
		parent: uCard
		height: 1
		width: 568
		x: Align.center
		y: infoHeight
		
	if line[i].selected == false 
		newButton(uCard, "Select", i, spacer.y + 20) 
	if line[i].selected == true 
		newButton(uCard, "Deselect", i, spacer.y + 20) 
		
	uCard.height = spacer.y + 72 
		
	uCard.y = Align.center
		
	uCard.scale = 0
	
	uCard.animate
		properties:
			scale: 1
			options:
				curve: Bezier.ease
				time: 0.1
				delay: 0.1
				
	popupBack.animate
		properties:
			opacity: .9
			options:
				time: 1.5
	
	closePopup = ->
		popupOn = false
		popup.animate
			properties:
				opacity: 0
				options:
					time: .3
	
				
	popupBack.onMouseUp ->
		closePopup()
	
	popup.on Events.AnimationEnd, ->
		popup.destroy()
		popupBack.opacity = 0

	uCard.onMouseUp ->
		if flag =="Select"
			clearLines()
			closePopup()
			setSelected(i)
			
		if flag =="Deselect"
			clearLines()
			closePopup()
			deselect(i)
			
		
		

listenHover = () ->
	for i in showingLines
		line[i].onMouseOver ->
			this.z = 500
			this.stateSwitch("hover")
		line[i].onMouseOut ->
			this.z = 1
			this.stateSwitch("normal")	

listenPressLine = () ->
		for i in showingLines
			line[i].onTap ->
				if popupOn == false and this.selected == false
					popupUser(this.ind)
						
# if mwidth >= 1000
# 	desktopInterface()

desktopInterface()
# if mwidth <1000
# 	currentWidth = widthTablet


#Desktop Interface
desktopResize = ->
	table.width = currentWidth
	desktopInterface()

drawLines = () ->
	if showingLines.length > 0
		for k in [0..showingLines.length-1]
			line[showingLines[k]].animate
				y: startLineY + (lineHeight+5) * k
				options:
					time: .2
	
dragY = 0	
dragX = 0	
listenSelectedPress = () ->
		for i in selectedLine
			selectedAvatar[i].onTap ->
				if popupOn == false 
					popupUser(this.ind)

unselectAvatar = (i) ->
# 		if selectedAvatar[i].y > (selectZone.y+selectZone.height - table.y)
		if selectedAvatar[i].y > (selectZone.y+selectZone.height - table.y) or (selectedAvatar[i].y+avatar[i].height) < (selectZone.y)
			clearLines()
			deselect(i)
			
listenDragAvatar = () ->
		for i in selectedLine
			selectedAvatar[i].draggable.enabled = true
			selectedAvatar[i].on Events.Move, ->
				index.scrollVertical = false
			selectedAvatar[i].onDragStart ->
				dragX = this.x	
				this.z = 500	
			selectedAvatar[i].onDragEnd ->
				clearLines()
				unselectAvatar(this.ind)
				this.z = 1
				this.animate
						x: dragX
						y: Align.center
					options:
						time: .2
				index.scrollVertical = true	
				
selected = (i) ->
	selectedAvatr[i].visible = true

deselect = (i) ->
	selectedAvatar[i].visible = false
	line[i].selected = false
	line[i].draggable.enabled = true
	for k in [0..selectedLine.length - 1]
		if selectedLine[k] == i
			selectedLine.splice(k, 1)
	line[i].visible = true
	line[i].opacity = 1
	for j in [0..usersNumber-1]
		if line[j].selected == false and line[j].find == true
			showingLines.push(j)
	line[i].stateSwitch("normal")
	drawLines()
	drawAvatarsInZone()
	selectZoneDraw()
	heights()
	searchForm()
	
setSelected = (i) ->
	line[i].selected = true
	line[i].visible = false
	line[i].draggable.enabled = false
	if selectedLine.length == 0
		selectZoneLabel.animate
			opacity: 0
			options: 
				time: .2
	selectedLine.push(i)
	for j in [0..usersNumber-1]
		if line[j].selected == false and line[j].find == true
			showingLines.push(j)
	drawLines()
	drawSelectedAvatars(i)
	selectZoneDraw()
	listenSelectedPress()
	listenDragAvatar()
	heights()
	searchForm()
# 	selected(i)
clearLines = ->
	for i in showingLines
		showingLines.pop()


collision = (i) ->
	if (line[i].y < selectZone.y+selectZone.height - table.y) and (line[i].y > selectZone.y - table.y)
		setSelected(i)
				
listenDragLine = () ->
		for i in showingLines
			line[i].on Events.Move, ->
				index.scrollVertical = false
				drag = true
				this.stateSwitch("drag")
			line[i].onDragStart ->
				dragY = this.y		
			line[i].onDragEnd ->
				clearLines()
				collision(this.ind)
# 				print this.y
				this.animate
					x: Align.center
					y: dragY
					options:
						time: .2
				index.scrollVertical = true
				this.stateSwitch("normal")
# 				this.on Events.AnimationEnd, ->	
# 					drag = false


listenCheck = () ->
		for i in showingLines
			selects[i].onTap ->
				isClick = true
				clearLines()
				setSelected(this.ind)	


							
					
listeners = ->
	listenHover()
	listenCheck()
	listenPressLine()
	listenDragLine()
	listenDragAvatar()

				
#Search
searchInfo = ->
# Restore all lines
	for i in [0..usersNumber-1]
		line[i].find = false
		line[i].visible = true
#reply for request
		if request == "All" or request == "all" or request == "ALL"
			if line[i].selected == false
				showingLines.push(i)
				line[i].find = true

		if request == "#{data.users[i].position}" 
			if line[i].selected == false
				showingLines.push(i)
				line[i].find = true
#hide unfinded lines	
	for i in [0..usersNumber-1]
		if line[i].find == false
			line[i].visible = false
		
			
	
sendRequest = ->
	if searchInput.value is ""
		searchInput.value = "All"
	request = searchInput.value
	searchResults.visible = true
	inputLine.animate
		properties:
			opacity: 0
			options:
				time: .4	
	searchResults.opacity = 1
	searchInput.visible = false
	
	searchInfo()
	drawLines()
	searchForm()
	heights()

inputRequest = ->
	searchResults.animate
		properties:
			opacity: 0
			options:
				time: .4	
	inputLine.animate
		properties:
			opacity: 1
			options:
				time: .4	
	searchInput.visible = true
	searchInput.z = 100
	searchResults.z = 10
	searchInput.onEnterKey -> 
		clearLines()
# 		print "Clear"
		sendRequest()


					
				
	
window.onresize = -> 
	mwidth = Screen.width
	mheight = Screen.height
	if mwidth >= 1000
		currentWidth = mwidth
		desktopResize()
	if mwidth <1000
		currentWidth = widthTablet

listeners()

		
searchResults.onTap ->
	inputRequest()
	
	