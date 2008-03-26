desk {
  extension_length = extension.to_s.length
  peer_extension = case extension_length
    when 7  : "1415#{extension}"
    when 10 : "1#{extension}"
    else extension
  end
  dial "SIP/#{peer_extension}@voipms", :caller_id => "14155244444"
  dial "SIP/#{peer_extension}@nufone", :caller_id => "14155244444" if last_dial_unsuccessful?
}

from_trunk {
  case extension
    when 415_524_4444, 650_305_2000, 409_291_4773, 44_20_3051_4843
      dial "SIP/jay-desk-650&SIP/jay-desk-601&SIP/jay-desk-601-2",
           :for => 15.seconds, :caller_id => callerid
      
      alternatives = %w[SIP/14097672813@voipms SIP/14097672813@nufone]
      
      # Try roommate if it's someone at the gate trying to get in.
      alternatives.insert(1, 'SIP/14154125674@voipms') if calleridname == 'EUREKA GARDENS'
      
      until last_dial_successful? || alternatives.empty?
        ahn_log 'Trying cell phone.'
        dial alternatives.shift, :caller_id => callerid, :for => 15.seconds
      end
  end
}