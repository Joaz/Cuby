class MotorMount < CrystalScad::Assembly
  
	def initialize(args={})
		@thickness = args[:thickness] || 6
		@bolt_height = args[:bolt_height] || 10
		@washer = args[:washer] || true
	end  

  def show
    part(true)
  end
  
  def output
    part(false)
  end
  
  def part(show)
  	motor =  Nema17.new
  	motor_model = motor.show.rotate(x:0).translate(z:-47) if show
     
		res += cube([42,42,@thickness]).center_xy
		# use only 3 bolts
 # 	res -= cube([42-10+0.1,42/2+0.1,@thickness+0.2]).translate(x:-11,z:-0.1)
##  	res -= cube([42/2+0.1,42/2,@thickness+0.2]).translate(y:-11,z:-0.1)
  
  
    # flange hole
		res -= cylinder(d:24,h:@thickness+0.2).translate(x:0,y:0,z:-0.1)		

		 
		bolts = create_bolts("top",res,motor,height:@thickness,bolt_height:@bolt_height,washer:@washer)[0..2]
		res -= bolts
		res += bolts if show

    res += motor_model if show
   
    res
  end
  
end
