class ExtruderIdler < CrystalScad::Assembly
  def initialize(args={})
    @z = 6
    @y = 30
    @y2 = 20
    @y3 = 10
    @filament_hole = 2.3
    @bearing_position = {x:28.0,y:@y/2}
  end
  

  def part(show)

    
    bolt = Bolt.new(4,20)
    res = half(bolt,show).color(r:20,b:255,g:0) 

    if show
      res += half(bolt,show,true).mirror(z:1).translate(z:@z*2).color(r:50,b:220,g:140)
      bearing = Bearing.new(type:"624")
      bearing_axis = bolt.show
      bearing_axis += Washer.new(4).show.translate(z:2.5)    
      bearing_axis += bearing.show.translate(z:@z/2+0.5)
      bearing_axis += Washer.new(4).show.translate(z:@z/2+0.5+5)    
      bearing_axis += Nut.new(4,type:"985").show.translate(z:@z/2+0.5+5+3.5)    
      res += bearing_axis.translate(@bearing_position)

    end    
    res
       
  end 
  
  def half(bearing_bolt,show, mirror=false)
    res = cube([@x=55,@y,@z]).translate(x:-20)
    # cutout for bearing
    res -= cube([30.1,@y2,@z+0.2]).translate(x:22,y:@y/2-@y2/2,z:2.5)    
  
    # cutout for motor shaft, and hobbed part  
    res -= cube([13.1,@y3,@z+0.2]).translate(x:10,y:@y/2-@y3/2,z:-0.1)    

    # cutout for springs  
    res -= cube([20,@y2,@z+0.2]).translate(x:-10+0.1,y:@y/2-@y2/2,z:-0.1)    


    # bolt (passed by part)
    
    res -= bearing_bolt.output.translate(@bearing_position)
    
    # filament guide
    res -= cylinder(d:@filament_hole,h:100).rotate(x:90).translate(x:21,y:50,z:@z)
    
    # spring & bolt cutouts
    [4.5,-4.5].each do |pos|
    #  res -= cylinder(d:7,h:12).rotate(y:-90).translate(x:0,y:@y/2-pos,z:@z)
      nut=Nut.new(4)
#      res += nut.show.rotate(y:-90).translate(x:-10,y:@y/2-pos,z:@z) if show
      res -= nut.output.rotate(y:-90).translate(x:-9,y:@y/2-pos,z:@z)
      res -= cylinder(d:4.4,h:18).rotate(y:-90).translate(x:-6,y:@y/2-pos,z:@z)
    end
    
    # extra bolts for holding the halves together on the spring side
    
    
    [4,@y-4].each do |pos|
      
      b = Bolt.new(3,16,washer:true,no_bom:mirror)
      
      if mirror == false
        res += b.show.translate(x:-16,y:pos) if show
        res -= b.output.translate(x:-16,y:pos)
      else
        res -= b.output.translate(x:-16,y:pos)
      
        n = Nut.new(3)
        w = Washer.new(3)
        res += n.show.translate(x:-16,y:pos,z:-2.5) if show   
        res += w.show.translate(x:-16,y:pos,z:-0.5) if show      
      end  
    end
    
    
    res
  end 
  
end

