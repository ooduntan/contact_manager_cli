class String
	def self.is_num_str()
		val=self =~ /^\d+$/?true:false
		val
	end
end