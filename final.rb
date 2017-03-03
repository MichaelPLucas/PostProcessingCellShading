require 'chunky_png'

filename = gets.chomp

puts "Process starting..."

img = ChunkyPNG::Image.from_file(filename)

pxls = []

for i in 0...img.height
	row = []
	for j in 0...img.width
		pxl = img.pixels[i * img.width + j]
		row.push [ChunkyPNG::Color.r(pxl),
		          ChunkyPNG::Color.g(pxl),
		          ChunkyPNG::Color.b(pxl),
		          ChunkyPNG::Color.a(pxl)]
	end
	pxls.push row
end

puts "Image read..."

def avg_pxl(arr)
	r = 0
	g = 0
	b = 0
	a = 0
	arr.each do |pxl|
		r += pxl[0]
		g += pxl[1]
		b += pxl[2]
		a += pxl[3]
	end
	return [r / arr.length, g / arr.length, b / arr.length, a / arr.length]
end

def dist(p1, p2)
	r = (p1[0] - p2[0]).abs
	g = (p1[1] - p2[1]).abs
	b = (p1[2] - p2[2]).abs
	a = (p1[3] - p2[3]).abs
	return r + g + b + a
end

def k_means(img, pxls, centers)
	result = Hash.new

	img.width.times do |x|
		img.height.times do |y|
			best = 0
			bdist = -1
			centers.length.times do |i|
				ndist = dist(centers[i], pxls[y][x])
				if (bdist == -1 || ndist < bdist)
					best = i
					bdist = ndist
				end
			end
			result[[x, y]] = best
		end
	end

	return result
end

centers = []
for i in 0..3
	x = img.width * (2 * i + 1) / 8
	for j in 0..3
		y = img.height * (2 * j + 1) / 8
		centers.push pxls[y][x]
	end
end

puts "KMeans beginning..."

last = []
clusters = Hash.new
while last != centers
	last = centers
	clusters = k_means(img, pxls, centers)

	temp = []
	16.times do
		temp.push []
	end

	clusters.each do |k, v|
		temp[v].push pxls[k[1]][k[0]]
	end

	temp.length.times do |i|
		if (temp[i].length == 0)
			next
		end
		centers[i] = avg_pxl(temp[i])
	end
end
=begin
img.width.times do |x|
	img.height.times do |y|
		pxls[y][x] = centers[clusters[[x, y]]]
	end
end

puts "KMeans finished..."

def mult(c, a)
	return [a[0] * c, a[1] * c, a[2] * c, a[3] * c]
end

def add(a1, a2)
	return [a1[0] + a2[0], a1[1] + a2[1], a1[2] + a2[2], a1[3] + a2[3]]
end

def convolve(pxls, kernel, offset)
	for y in offset...(pxls.length - offset)
		for x in offset...(pxls[y].length - offset)
			sum = [0, 0, 0, 0]
			for i in 0...kernel.length
				for j in 0...kernel[i].length
					sum = add(sum, mult(kernel[i][j], pxls[y - i + offset][x - j + offset]))
				end
			end
			pxls[y][x] = sum
		end
	end
	return pxls
end

gauss = [[1.0/16, 2.0/16, 1.0/16],
         [2.0/16, 4.0/16, 2.0/16],
         [1.0/16, 2.0/16, 1.0/16]]

sobelx = [[-1, 0, 1],
          [-2, 0, 2],
          [-1, 0, 1]]

sobely = [[1, 2, 1],
          [0, 0, 0],
          [-1, -2, -1]]

puts "Gauss starting..."

pxls = convolve(pxls, gauss, 1)

puts "Gauss finshed. Sobel x starting..."

pxls = convolve(pxls, sobelx, 1)

puts "Sobel x finished. Sobel y starting..."

pxls = convolve(pxls, sobely, 1)

puts "Sobel y finished..."
=end
png = ChunkyPNG::Image.new(img.width, img.height, ChunkyPNG::Color::TRANSPARENT)

png.width.times do |x|
	png.height.times do |y|
		c = centers[clusters[[x, y]]]#pxls[y][x].map { |x| x.to_i }
		png[x,y] = ChunkyPNG::Color.rgba(c[0], c[1], c[2], c[3])
	end
end

png.save('intermediary.png', :interlace => true)
