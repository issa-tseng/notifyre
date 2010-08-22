require 'open-uri'
require 'cgi'
class Tropo
  TROPO_API = "http://api.tropo.com/1.0/sessions?action=create&token=d7447f93a65fbd4ea669e0e32d973adb39631abc1fe148ffccd8f539bf6f5e00a690e5c77f75d13358e004ec"
  def self.send_text(to, msg)
    open(TROPO_API + "&to=" + to + "&msg=" + CGI.escape(msg))
  end
end
  
