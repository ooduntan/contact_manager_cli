# this helps check if a string is a numbered string only
class String
  def self.num_str?
    val = self =~ /^\d+$/ ? true : false
    val
  end
end
