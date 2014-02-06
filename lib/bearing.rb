# this should go to crystalscad standard library
class Bearing < CrystalScad::Assembly
  attr_accessor :size
  def initialize(args={})		
    @args = args
    @args[:type] ||= "608"
    @args[:sealing] ||= "ZZ"
    @args[:output_margin_height] ||= 0.0
    @args[:margin_diameter] ||= 0.0    
    @args[:outer_rim_cut] ||= 0.0
    @args[:flange] ||= false
		@args[:transformations] ||= nil

    
    prepare_data
      
    @@bom.add(description) unless args[:no_bom] == true
  end
  
  def prepare_data
    chart = {"608" => {inner_diameter:8,outer_diameter:22,thickness:7, inner_rim:12, outer_rim:19},
             "624" => {inner_diameter:4,outer_diameter:13,thickness:5, inner_rim:6.3, outer_rim:11.0, flange_diameter:15, flange_width:1},
             "625" => {inner_diameter:5,outer_diameter:16,thickness:5, inner_rim:7.5, outer_rim:13.5},
           "61800" => {inner_diameter:10,outer_diameter:19,thickness:5, inner_rim:12, outer_rim:16.3},
           "63800" => {inner_diameter:10,outer_diameter:19,thickness:7, inner_rim:12, outer_rim:16.3},
    			 "mr105" => {inner_diameter:5,outer_diameter:10,thickness:4}
    }
    @size = chart[@args[:type].to_s.downcase]
		@height = @size[:thickness]
  end
  
  def description
    "Bearing " + @args[:type].to_s + @args[:sealing].to_s
  end
  
  def output
    bearing = cylinder(d:@size[:outer_diameter]+@args[:margin_diameter],h:@size[:thickness]+@args[:output_margin_height])
    
    if @args[:outer_rim_cut].to_f > 0 
      bearing+= cylinder(d:@size[:outer_rim],h:@args[:outer_rim_cut]).translate(z:-@args[:outer_rim_cut]) 
      bearing+= cylinder(d:@size[:outer_rim],h:@args[:outer_rim_cut]).translate(z:@size[:thickness]) 
    end
    if @args[:flange] == true
      bearing += cylinder(d:@size[:flange_diameter].to_f, h:@size[:flange_width])      
    end
		bearing.transformations+=@args[:transformations] if @args[:transformations]
    bearing
  end
  
  def show
    if @size[:inner_rim].to_f > 0 && @size[:outer_rim].to_f > 0
      bearing = cylinder(d:@size[:outer_diameter],h:@size[:thickness])
      bearing-= cylinder(d:@size[:outer_rim],h:@size[:thickness]+0.2).translate(z:-0.1)
      bearing = bearing.color("Silver")
      
      bearing+= cylinder(d:@size[:outer_rim],h:@size[:thickness]-0.4).translate(z:0.2).color("PaleGoldenrod")
      bearing+= cylinder(d:@size[:inner_rim],h:@size[:thickness]).color("Silver")
      bearing-= cylinder(d:@size[:inner_diameter],h:@size[:thickness]+0.2).translate(z:-0.1).color("Silver")
      
         
    else
      # simple version
      bearing = cylinder(d:@size[:outer_diameter],h:@size[:thickness])
      bearing-= cylinder(d:@size[:inner_diameter],h:@size[:thickness]+0.2).translate(z:-0.1)    
      bearing.color("LavenderBlush")
    end  
    if @args[:flange] == true
      flange = cylinder(d:@size[:flange_diameter].to_f, h:@size[:flange_width].to_f)
      flange-= cylinder(d:@size[:outer_diameter],h:@size[:thickness]+0.2).translate(z:-0.1)
      bearing+=flange.color("Silver")
    end

		
		bearing.transformations+=@args[:transformations] if @args[:transformations]

	  bearing
	
	end
    	  
end
