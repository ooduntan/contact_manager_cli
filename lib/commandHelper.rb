# this class help the cli
class CommandHelper
	def check_add_format(command_array)
		if command_array[2].is_a?(NilClass) || command_array[4].is_a?(NilClass)
			puts ''
		elsif command_array[1].is_a?(NilClass) || command_array[1] != '-u'

		elsif command_array[3].is_a?(NilClass) || command_array[3] != '-p'

		else

	end
	end
end