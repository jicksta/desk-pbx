desk {
  extension_length = extension.to_s.length
  if extension_length == 7
    dial "SIP/1415#{extension}@voipms", :caller_id => "14155244444"
  elsif extension_length == 10
    dial "SIP/1#{extension}@voipms", :caller_id => "14155244444"
  else
    dial "SIP/#{extension}@voipms", :caller_id => "14155244444"
  end
}

from_trunk {
  case extension
    when 415_524_4444, 650_305_2000, 409_291_4773, 44_20_3051_4843
      dial "SIP/jay-desk-650", 'SIP/jay-desk-601', 'SIP/jay-desk-601-2',
           :for => 1.minute, :caller_id => callerid
    else
      play 'invalid'
    end
  end
}