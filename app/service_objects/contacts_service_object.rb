class ContactsServiceObject


  def self.matched_users(phone_numbers)
    parsed_phone_numbers = []
    phone_numbers.each do |phone_number|
      parsed_phone_number = Phonelib.parse(phone_number)
      if parsed_phone_number.valid?
        parsed_phone_numbers << parsed_phone_number.international
      end
    end
    return User.where(:phone => parsed_phone_numbers)
  end

end