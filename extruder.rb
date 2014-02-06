#!/usr/bin/ruby1.9.3

class String
  def underscore
    word = self.dup
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end
end
 
require "rubygems"
require "crystalscad"
require "require_all"

include CrystalScad

require_all "lib/*.rb"




body = ExtruderBody.new
body.show.save("extruder.scad","$fn=64;")

@@bom.save("bom.txt")

idler = ExtruderIdler.new
idler.show.save("idler.scad","$fn=64;")


parts = [ExtruderBody, ExtruderIdler]
parts.each do |part|
  name = part.to_s.underscore
  part.new.output.save("output/#{name}.scad","$fn=64;")
  if ARGV[0] == "build"
    puts "Building #{name}..."
    system("openscad -o output/#{name}.stl output/#{name}.scad")
    system("admesh output/#{name}.stl -b output/#{name}.stl")
  end

end
