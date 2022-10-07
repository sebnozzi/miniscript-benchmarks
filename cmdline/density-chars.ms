
// This benchmark performs the computations needed for
// rendering the faces using ASCII characters found in the
// "asciiFaces" MiniMicro demo, but with these differences:
//
// - it does not read any image, instead it generates random "color vaues"
// - it does not render anything
//
// It serves the purpose of benchmarking data-generation and storage into
// array (similar to reading pixels and storing into array) and most 
// importantly the computation of average values and the selection of the
// corresponding ASCII character.

density = "¶@#W$9876543210?!ycl;:+=-,.‘"
imgWidth = 128
imgHeight = 128

// (Taken from MiniMicro's mathUtil)
// lerp: Interpolate between two values, that is, return a value that is
// some portion (t) of the way from a to b.
lerp = function(a, b, t)
	return a + (b-a) * t
end function

avg4Pixel = function(x,y)
	dotList1 = imgArray[x+y*imgHeight]
	dotList2 = imgArray[x+1+y*imgHeight]
	dotList3 = imgArray[x+(y+1)*imgHeight]
	dotList4 = imgArray[x+1+(y+1)*imgHeight]
	sumdotList = dotList1.sum+dotList2.sum+dotList3.sum+dotList4.sum
	lendotList = dotList1.len+dotList2.len+dotList3.len+dotList4.len
	avgDot = sumdotList / lendotList
	return avgDot
end function

densityChar = function(x,y)
	return density[floor(lerp(density.len-1,0,avg4Pixel(x,y)/255))]
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

while true
		
	readTimer.start
	imgArray = range(0,imgWidth*imgHeight)
	for y in range(0,imgHeight-1)
		for x in range(0,imgWidth-1)
			idx = x+y*imgHeight
			randomValues = [floor(rnd*256),floor(rnd*256),floor(rnd*256)]
			imgArray[idx] = randomValues
		end for
	end for
	readTimer.stop
	
	// Compute lines
	compTimer.start
	lines = []
	for y in range(0,imgHeight-1,2)
		lineChars = ""
		for x in range(0,imgWidth-1,2)
			dc = densityChar(x,y)
			lineChars = lineChars + dc
		end for
		lines.push lineChars
	end for
	compTimer.stop
	
	// Print elapsed times
	
	print "Generatiton took "+readTimer.elapsedTime+"ms"
	print "Computation took "+compTimer.elapsedTime+"ms"
	print ""
		
end while