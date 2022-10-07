import "mathUtil"
import "tc"
density = "¶@#W$9876543210?!ycl;:+=-,.‘"

avg4Pixel = function(x,y)
	imgHeight = image.height
	dotList1 = imgArray[x+y*imgHeight]
	dotList2 = imgArray[x+1+y*imgHeight]
	dotList3 = imgArray[x+(y+1)*imgHeight]
	dotList4 = imgArray[x+1+(y+1)*imgHeight]
	sumdotList = dotList1.sum+dotList2.sum+dotList3.sum+dotList4.sum
	lendotList = dotList1.len+dotList2.len+dotList3.len+dotList4.len
	avgDot = sumdotList/lendotList
	return avgDot
end function

densityChar = function(x,y)
	return density[floor(mathUtil.lerp(density.len-1,0,
	avg4Pixel(x,y)/255))]
end function

Timer = {}
Timer.startTime = 0
Timer.stopTime = 0
Timer.start = function
	self.startTime = time
end function
Timer.stop = function
	self.stopTime = time
end function
Timer.elapsedTime = function
	return floor(1000 * (self.stopTime - self.startTime))
end function

// MAIN LOOP

readTimer = new Timer
compTimer = new Timer
renderTimer = new Timer

clear

flip

while true
	
	randFileNumber = floor(rnd*1000)
	fileNumber = "0"*(5-str(randFileNumber).len) + str(randFileNumber)
	image = file.loadImage("faces/" + fileNumber + ".png")
	
	// Tune amount of repetitions
	for _ in range(1,1)
		
		// Dump everything into an array to rule out performance
		// penalties from reading from image directly
		readTimer.start
		imgArray = range(0,image.width*image.height)
		for y in range(0,image.height-1)
			for x in range(0,image.width-1)
				idx = x+y*image.height
				pixelColor = image.pixel(x,y)
				//[:-1] removes the alpha
				colorValuesWithoutAlpha = color.toList(pixelColor)[:-1]
				imgArray[idx] = colorValuesWithoutAlpha
			end for
		end for
		readTimer.stop
		
		// Compute lines
		compTimer.start
		lines = []
		for y in range(0,image.height-1,2)
			lineChars = ""
			for x in range(0,image.width-1,2)
				dc = densityChar(x,y)
				lineChars = lineChars + dc
			end for
			lines.push lineChars
		end for
		compTimer.stop
		
		gfx.clear
		
		renderTimer.start
		// Render lines
		for lineIdx in range(0,lines.len-1)
			line = lines[lineIdx]
			y = lineIdx * 8
			gfx.print line, 0, y, color.white, "small"
		end for
		renderTimer.stop
		
		// Print elapsed time
		gfx.print "Reading took "+readTimer.elapsedTime+"ms",0,615,color.orange
		gfx.print "Computation took "+compTimer.elapsedTime+"ms",0,615-20,color.orange
		gfx.print "Rendering took "+renderTimer.elapsedTime+"ms",0,615-40,color.orange
		
		// Draw original image
		gfx.drawImage image,450,500
		
		flip
		
	end for
	
end while