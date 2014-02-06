class ExtruderBody < CrystalScad::Assembly
  def initialize(args={})
    @filament_size = 1.75
    @filament_hole = 2.0
  end
  
  def part(show)
   # res += Nema17.new.show.translate(z:-47-2)
    
    res += DriveGear.new.show.translate(z:4.5+6) if show
  
    filament = cylinder(d:@filament_size,h:200).rotate(x:90).color("red")
    filament_z=19
   
    idler = ExtruderIdler.new.show   
    res += idler.translate(x:-17,y:-15,z:13) if show
    
    spring_wall = cube([10,sp_y=20-0.4,25]).translate(x:-21,y:-sp_y/2)
    
    bolts_z=19
    bolt_x=-13.5
    [-4.5,4.5].each do |bolt_y| 

      # spring
      Spring.new # for BOM
#      spring_wall += cylinder(d:4.8,h:13).rotate(y:-90).translate(x:bolt_x-2,y:bolt_y,z:bolts_z+5)
      spring_wall -= cylinder(d:4.8,h:13).rotate(y:-90).translate(x:bolt_x-2,y:bolt_y,z:bolts_z)
      
    end
      
    res += spring_wall
    
    m = MotorMount.new
    res += m.part(show)#.rotate(z:-90)
        
    
    # j-head mount 
   
    res += cube([30,10,33]).translate(x:-12,y:15.5)
    
    # the piece of wall connecting to the mounting wall
    res += cube([32,9,33]).translate(x:-11,y:15.5)

    
    res -= long_slot(d:16.1,h:4.7+0.2,l:15).rotate(x:90,y:90).translate(x:4,y:25.6,z:34).color("blue")
    
    # wall for j-head groove 
    res += cube([30,4.5,33]).translate(x:-12,y:25.5)
    res -= long_slot(d:12.1,h:4.7+0.6,l:15).rotate(x:90,y:90).translate(x:4,y:26+4.2+0.5,z:34).color("blue")

  
    
    # filament guide ot the j-head
    res -= cylinder(d1:@filament_hole,d2:@filament_hole+1,h:2).rotate(x:90).translate(x:4,y:17,z:bolts_z)
    res -= cylinder(d:@filament_hole,h:20).rotate(x:90).translate(x:4,y:30,z:bolts_z)
    
    
    # some more structure for the bolt securing the j-head and its nut
    
    # for bolt 
    res += hull( 
                  cube([7.5,7,1]).translate(x:-12,y:28,z:bolts_z+13),
                  cube([7.5,7,1]).translate(x:-12,y:28-7,z:0)
                  
               )
    # for nut
    res += hull( 
                  cube([5.5,7,1]).translate(x:12.5,y:28,z:bolts_z+13),
                  cube([5.5,7,1]).translate(x:12.5,y:28-7,z:0)
                  
               )
    
    # bolt securing the j-head
    
    b = Bolt.new(3,30,washer:true)
    n = Nut.new(3)
    res -= b.output.rotate(y:90).translate(x:-12,y:28,z:bolts_z+7.5)
    res += b.show.rotate(y:90).translate(x:-12,y:28,z:bolts_z+7.5) if show
    
    res -= n.output.rotate(y:90).translate(x:16,y:28,z:bolts_z+7.5)
    res += n.show.rotate(y:90).translate(x:16,y:28,z:bolts_z+7.5) if show

    
    # fan
    fan = Fan.new
    res += cube([44,47.5,6]).center_x.translate(y:20)
    
    res -= fan.output.translate(y:48,z:-10.1)
    res += fan.show.translate(y:48,z:-10) if show
  
    res-= cube([24,50,6.2]).center_x.translate(y:40,z:-0.1)
      
  
    jhead= JHead.new
    res += jhead.show.rotate(x:90).translate(x:4,y:63.5+5.2,z:filament_z) if show
    
    # mounting wall to i3 carriage
    res += cube([7,42+3.5,45]).translate(x:21,y:-21)
    
    res -= cylinder(d:3.2,h:10).rotate(y:90).translate(x:20,y:12,z:10)
    res -= cylinder(d:3.2,h:10).rotate(y:90).translate(x:20,y:12,z:34)
    res -= cylinder(d:3.2,h:10).rotate(y:90).translate(x:20,y:12,z:40)
    
    res += filament.translate(x:4,y:100,z:filament_z) if show

    res
  end
  
 
  
end
