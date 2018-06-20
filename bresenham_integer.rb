#
# Bresenham's line algorithm
#   integer only
#   IBM 1962
#
def print_line_from_to(x0,y0, x1,y1)
  dx = x1 - x0
  dy = y1 - y0
  d = 2*dy - dx
  y = y0

  (x0..x1).each do |x|
    puts "#{x} x #{y}" 
    if d > 0
       y = y + 1
       d = d - 2*dx
    end
    d = d + 2*dy
  end
end

# Calculate x,y coordinates
print_line_from_to(0,0, 20,10)