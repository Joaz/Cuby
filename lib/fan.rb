class Fan < CrystalScad::Assembly

  def initialize(args={})
    @size = args[:size] || 40
    @height = args[:height] || 10
    @bolt_distance = 32
    @output_size = args[:output_size] || 8
    
    @holes = 3
  end
  
  def part(show)
    res = cube([@size,@size,@height]).center_xy
    
    if show
      res -= cylinder(d:@size-2,h:@height+0.2).translate(z:-0.1)
    else
      res += cylinder(d:@size-2,h:@height+0.2+@output_size*2).translate(z:-@output_size-0.1)      
      
      offset = (@size-@bolt_distance)/2.0
      
      [@bolt_distance/2.0,-@bolt_distance/2.0].each do |x|
         [@bolt_distance/2.0,-@bolt_distance/2.0].each do |y|
           res += cylinder(d:3.1,h:@height+0.2+@output_size*2).translate(x:x,y:y,z:-@output_size-0.1) 
         end  
      end
      
      
    end
       
    res.color("grey")
  end
    
  
end
