require 'open-uri'
require 'cgi'

class Tropo
  TEXT_URL = "http://api.tropo.com/1.0/sessions?action=create&token=d7447f93a65fbd4ea669e0e32d973adb39631abc1fe148ffccd8f539bf6f5e00a690e5c77f75d13358e004ec"
  CALL_URL = "http://api.tropo.com/1.0/sessions?action=create&token=5c66ee5e29545747823de7c3e707873e96f8152bc0fdb312ba58f0a30c81d32deb051cee98d0611a2ab16a22"

  def self.send_text(to,msg)
    open(TEXT_URL + "&to=" + to + "&msg=" + CGI.escape(msg))
  end

  def self.make_call(to,msg)
    open(CALL_URL + "&to=" + CGI.escape(to) + "&msg=" + CGI.escape(msg))
  end
end

