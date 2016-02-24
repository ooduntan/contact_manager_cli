class ContactManager

	def initialize(name, number)

	end

	def addNewUser(name, phoneNUmber)

		if name.length>0 && phoneNUmber.length>0
			saveContact(name, number)
		else
			false
		end

	end

	def checkPhoneNumber?(phoneNUmber)
			phoneNUmber=phoneNUmber.to_i

	end

	def searchUser(name)
		if name.length>0
			lookUpData(name)
		else
			false
		end
	end

	def displaySearchResult(listedNumber)
		returnValue=""
		if listedNumber.length>0
			returnValue="Your search result has produced #{listedNumber.length} results"
		else
			false
		end
	end

end