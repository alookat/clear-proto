# variables
listHeight = 110

listStyle =
	"font": "34px/#{listHeight}px Helvetica Neue"
	"padding-left": "20px"

# colours
red = new Color(r: 217, g: 0, b: 21)
darkRed = new Color(red).darken(20)
yellow = new Color(r: 255, g: 175, b: 30)
top = new Color(r: 40, g: 40, b: 40, a: 0.5)
border = new Color(r: 0, g: 0, b: 0, a: 0.1)

bg = new BackgroundLayer
	backgroundColor: "black"
	
# will need to be brought to front later
statusBar = new Layer
	width: 728, height: 22
	midX: Screen.width/2, y: 10
	image: "images/statusBar.png"
	
# the scrollable list
listScroll = new ScrollComponent
	size: Screen.size
	scrollHorizontal: false
	perspective: 1000

listScroll.pinchable.enabled = true
listScroll.pinchable.scale = false
listScroll.pinchable.rotate = false
# listPinch = new Layer
# 	size: Screen.size
# listPinch.pinchable.enabled = true

# let's "tag" every list item as "list"
# so we can target them collectively later
list = []

# now let's make the actual list items
for listItem in [0..8]
	listItem = new Layer
		parent: listScroll.content
		width: Screen.width
		height: listHeight
		y: listItem * listHeight + 90
		backgroundColor: Color.mix(red, yellow, listItem*0.1)
		html: "This is a list item"
	listItem.style = listStyle
		
	# and add a border to each
	listItemBorder = new Layer
		width: listItem.width
		parent: listItem
		height: 1
		backgroundColor: border
	
	# and finally push them to that list array	
	list.push(listItem)

# the top part
listName = new Layer
	width: Screen.width, height: 90
	html: "Personal List"
	backgroundColor: top
listName.style = 
	"font": "500 27px/127px Helvetica Neue"
	"text-align": "center"
	"-webkit-backdrop-filter": "blur(30px)"
listNameBorderBottom = new Layer
	width: listName.width
	parent: listName
	height: 1
	maxY: listName.maxY
	backgroundColor: top
	
# bring that status bar to the front!
statusBar.bringToFront()

listItemNew = new Layer
	parent: listScroll.content
	width: Screen.width
	height: listHeight
	maxY: list[0].y
	backgroundColor: red.darken(10)
# 	html: "Pull to Create Item"
	style: listStyle
	rotationX: 60
	originY: 1

# when we pull the list down, let's add a new item
# listScroll.onPanStart ->
# 	if listScroll.y += 1
# 		listItemNew = new Layer

addThis = false
listScroll.onMove ->
# 	print "scrollY :" + listScroll.scrollY + " rotationX :" + listItemNew.rotationX
	listItemNew.rotationX = Utils.modulate(listScroll.scrollY, [0, -listHeight], [60, 0], true)
	

	fraction = Utils.modulate(listScroll.scrollY, [0, -listHeight], [0, 1], true)
	listItemNew.backgroundColor = 
		Color.mix(darkRed, red, fraction, true)

# 	print listScroll.scrollY
	if listScroll.scrollY <= -110
		listItemNew.html = "Release to Create Item"
		addThis = true
	else 
		listItemNew.html = "Pull to Create Item"
	print listItemNew.rotationX
listScroll.onTouchEnd ->
	if addThis is true
		# why isn't this working (rotation goes back to 60)
		listItemNew.rotationX = 0
# 		listItemNew.originY = 0
# 		listItemNew.y = 100
		print listItemNew.rotationX



listScroll.onPinch (event) ->
	print event.touchDistance
	distance = event.touchDistance
	
# 	centerPoint = event.touchCenter.y
# 	listScroll.midY = centerPoint
				
# 		print event.touchDistance / listItem.index
# 		listItem.y = event.touchDistance / listItem.index


