extends Node2D


class Line:
	var Start
	var End
	var LineColor
	var InputTime

	func _init(Start, End, LineColor, InputTime):
		self.Start = Start
		self.End = End
		self.LineColor = LineColor
		self.InputTime = InputTime


var Lines = []
var RemovedLine = false


func _process(delta):
	for i in range(len(Lines)):
		Lines[i].InputTime -= delta

	if len(Lines) > 0 || RemovedLine:
		# TODO: This does NOT work!
		_draw()  #Calls _draw
		RemovedLine = false


func _draw():
	var Cam = get_viewport().get_camera_3d()
	for i in range(len(Lines)):
		var ScreenPointStart = Cam.unproject_position(Lines[i].Start)
		var ScreenPointEnd = Cam.unproject_position(Lines[i].End)

		#Dont draw line if either start or end is considered behind the camera
		#this causes the line to not be drawn sometimes but avoids a bug where the
		#line is drawn incorrectly
		if Cam.is_position_behind(Lines[i].Start) || Cam.is_position_behind(Lines[i].End):
			continue

		draw_line(ScreenPointStart, ScreenPointEnd, Lines[i].LineColor)

	#Remove lines that have timed out
	var i = Lines.size() - 1
	while i >= 0:
		if Lines[i].InputTime < 0.0:
			Lines.remove(i)
			RemovedLine = true
		i -= 1


func DrawLine(Start, End, LineColor, InputTime = 0.0):
	Lines.append(Line.new(Start, End, LineColor, InputTime))


func DrawRay(Start, Ray, LineColor, InputTime = 0.0):
	Lines.append(Line.new(Start, Start + Ray, LineColor, InputTime))


func DrawCube(Center, HalfExtents, LineColor, InputTime = 0.0):
	#Start at the 'top left'
	var LinePointStart = Center
	LinePointStart.x -= HalfExtents
	LinePointStart.y += HalfExtents
	LinePointStart.z -= HalfExtents

	#Draw top square
	var LinePointEnd = LinePointStart + Vector3(0, 0, HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, InputTime)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, InputTime)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(0, 0, -HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, InputTime)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(-HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, InputTime)

	#Draw bottom square
	LinePointStart = LinePointEnd + Vector3(0, -HalfExtents * 2.0, 0)
	LinePointEnd = LinePointStart + Vector3(0, 0, HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, InputTime)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, InputTime)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(0, 0, -HalfExtents * 2.0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, InputTime)
	LinePointStart = LinePointEnd
	LinePointEnd = LinePointStart + Vector3(-HalfExtents * 2.0, 0, 0)
	DrawLine(LinePointStart, LinePointEnd, LineColor, InputTime)

	#Draw vertical lines
	LinePointStart = LinePointEnd
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, InputTime)
	LinePointStart += Vector3(0, 0, HalfExtents * 2.0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, InputTime)
	LinePointStart += Vector3(HalfExtents * 2.0, 0, 0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, InputTime)
	LinePointStart += Vector3(0, 0, -HalfExtents * 2.0)
	DrawRay(LinePointStart, Vector3(0, HalfExtents * 2.0, 0), LineColor, InputTime)
