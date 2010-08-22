#
# This file is hosted on Tropo's servers
#
if $action == "create"
    if defined? $msg || defined? $to || $msg == "" || $to == ""
        log("Something blank")
    else
        message($msg, {
            :to => $to,
            :network => "SMS"})
    end
else
    log("Message from " + $currentCall.callerID + ": " + $currentCall.initialText)
end
