# a ruby script that logins downloads a specified file on a https website using mechanize gem. have fun, do what you wish with it.

require 'rubygems'
require 'mechanize'
require 'io/console'

class AutomotonDownloader

  def initialize  
    @a = Mechanize.new
  end

  def launcher
    # load certificate
    @a.agent.http.ca_file = 'file path of certificate .pem or .crt'

    # use this if ssl certificate not required
    #@a.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    # save cookies start session
    @a.cookie_jar.save_as 'dl_cookies', :session => true, :format => :yaml

    # logins with userid and password
    page = @a.get('url of main page with login & password form') do |page|

      # use the 'action' from the form to login
      my_page = page.form_with(:action => 'form action') do |f|
        # use the form id or names for the login and password
        f.userid      = ARGV[0]
        f.pwd         = ARGV[1]
      end.click_button
    
    # download
    @a.pluggable_parser.default = Mechanize::Download
    # file download url
    @a.get('url of file to download').save('desired name to save as')
    
    # to download all file types in a directory use this instead
    #@a.pluggable_parser.pdf = Mechanize::FileSaver
    #@a.get 'https://cmsreports.csus.edu/psreports/HSACPRD/*/*.pdf'
    #Dir['cmsreports.csus.edu/psreports/HSACPRD/*/*']

    # error case for when a user name and password are not entered when running the script
    abort "Error: Enter Login name and Password!" if (ARGV.size != 2)
  end

  end

end

AutomotonDownloader.new.launcher
