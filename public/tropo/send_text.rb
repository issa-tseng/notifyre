#
# this file is hosted on Tropo's servers
#
if $action == "create"
    if defined? $msg || defined? $to || $msg == "" || $to == ""
        log("Something blank")
    else
        message($msg, {
            :to => "tel:+"+$to,
            :network => "SMS"})
    end
else
    message("This is notifyre.com. Visit for our site for more info.", {:to => $currentCall.callerID, :network => "SMS"})
    log("Message from " + $currentCall.callerID + ": " + $currentCall.initialText)
end

