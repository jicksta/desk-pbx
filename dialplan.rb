Voipms = 'SIP/%s@voipms'
Nufone = 'SIP/%s@nufone'
Vitelity = 'SIP/%s@vitelity'

Mobile = 1_409_767_2813
Roomie = 1_415_412_5674
MyDesk = 1_415_524_4444

desk {
  extension_length = extension.to_s.length
  peer_extension = case extension_length
    when 7  : "1415#{extension}"
    when 10 : "1#{extension}"
    when 11 : extension
    else
      +invalid
  end
  dial Vitelity % peer_extension, :caller_id => MyDesk
  dial Voipms   % peer_extension, :caller_id => MyDesk if last_dial_unsuccessful?
  dial Nufone   % peer_extension, :caller_id => MyDesk if last_dial_unsuccessful?
}

invalid {
  play 'invalid'
}

direct_dial {
  dial Vitelity % extension, :caller_id => MyDesk
}

from_trunk {
  case extension
    when 415_524_4444, 650_305_2000, 409_291_4773, 44_20_3051_4843
      dial "SIP/jay-desk-650&SIP/jay-desk-601&SIP/jay-desk-601-2",
           :for => 15.seconds, :caller_id => callerid
      
      alternatives = [Voipms % Mobile, Nufone % Mobile]
      
      # Try roommate as a middle-step if it's someone at the gate trying to get in.
      alternatives.insert(1, Voipms % Roomie) if calleridname == 'EUREKA GARDENS'
      
      until last_dial_successful? || alternatives.empty?
        ahn_log 'Trying cell phone.'
        dial alternatives.shift, :caller_id => callerid, :for => 15.seconds
      end
  end
}
