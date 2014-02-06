class JHead < CrystalScad::Assembly
  
  def show
    peek.translate(z:8.2)+brass
  end
  
  def peek
      res = cylinder(d:10,h:40)
    # from brass part to cooling part (ignoring the flat cuts)
    res+= cylinder(d:16,h:13).translate(z:0)

    (1..5).each do |i|
      res+= cylinder(d:16,h:1).translate(z:12.5+2.8*i)
    end
    
    res+= cylinder(d:16,h:4).translate(z:13+3.3*4)

    # groovemount
    res+= cylinder(d:12,h:5).translate(z:30)
    res+= cylinder(d:16,h:5).translate(z:35)
  
    res-= cylinder(d:3.2,h:42).translate(z:-1)
    
    res.color("DimGray")
  end
  
  def brass
    res = cube([12.7,12.7,8.2]).translate(x:-4,y:-12.7/2)
    res += cylinder(d:7.8,h:1.4).translate(z:-1.4)
    res += cylinder(d2:7.8,d1:1.5,h:2).translate(z:-1.4-2)
    
    res.color("Goldenrod")  
  end

end
