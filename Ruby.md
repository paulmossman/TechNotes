**<span style="font-size:3em;color:black">Ruby</span>**
***-

TUTORIAL: http://www.math.umd.edu/~dcarrera/ruby/0.3/index.html
QUICK REF: http://www.zenspider.com/Languages/Ruby/QuickRef.html
REFERENCE: http://www.ruby-doc.org/docs/ruby-doc-bundle/Manual/man-1.4/index.html
CLASS DOC: http://www.ruby-doc.org/core/classes/   <<Class>>.html
BUILT_IN FUNCTIONS: http://www.ruby-doc.org/docs/ruby-doc-bundle/Manual/man-1.4/function.html#system


# Syntax

http://docs.huihoo.com/ruby/ruby-man-1.4/syntax.html

## Array
```
a.push(t) --> Puts 't' onto the end of Array 'a'.
a.length
[ "a", "b", "c" ].each_index {|x| print x, " -- " }  #=> "0 -- 1 -- 2 --"
[ "a", "b", "c" ] | [ "c", "d", "a" ]  #=> [ "a", "b", "c", "d" ]
[ "a", "b", "c" ] + [ "c", "d", "a" ]  #=> ["a", "b", "c", "c", "d", "a"]
```

## String
chomp - remove a single record separator (if present) from the end
lstrip - remove leading whitespace
rstrip - remove trailing whitespace
strip - remove leading and trailing whitespace

### String replace / Substitution
```
"hello".gsub(/([aeiou])/, '<\1>')  #=> "h<e>ll<o>"
"hello".gsub(/(ll)/, '<\1>')       #=> "he<ll>o"
str="ll"
"hello".gsub(/(#{str})/, '<\1>')   #=> "he<ll>o"
"---\"---".gsub(/(")/, 'DOUBLE-QUOTE')   #=> "---DOUBLE-QUOTE---"
"fun=45".gsub(/fun=[0-9]+/, "fun=203") #=> "fun=203"
```

One line: `ruby -ne 'puts gsub(/Andrew/, "andy").gsub(/Alexander/, "al")' < snip.sh.in > snip.sh`

### Basic String Output
```
puts("Times: #{foo}")
puts("IPEI: #{"%012d" % ipei}") # Pad to 12 digits, using '0' to lead.
```

### String Index
```
.index --> nil if not found.
```

## Regular expressions
```
re="fun[0-9]"
irb(main):008:0> /#{re}/.match("funA") #=> nil
irb(main):009:0> /#{re}/.match("fun1") #=> ! nil
```

## File

### Write
```
f=File.open('/tmp/fun.txt', 'w') # OR 'a' for Append
f.puts 'Twenty: ' << 20.to_s
f.close
```

### Read
```
input =  File.open( ARGV[0], "r" )
input.readlines.each do |line|
   puts line
end 
```

### Copy
```
require "ftools"
File.copy(src,target)
```

### Name: dir, Base
```
File.dirname("/home/gumby/work/ruby.rb")   #=> "/home/gumby/work"
File.basename("/home/gumby/work/ruby.rb")          #=> "ruby.rb"
File.basename("/home/gumby/work/ruby.rb", ".rb")   #=> "ruby"
```


## Function 
```
def fun(arg1)
   puts arg1
end
```

A Ruby function returns the last thing that was evaluated in it.
```
def fact(n)
  if n == 0
    1
  else
    n * fact(n-1)
  end
end
puts fact(ARGV[0].to_i)
```

## SSL

### Handy SSL check script
https://github.com/rubygems/ruby-ssl-check/blob/master/check.rb

## `net/http` library

TODO


### Debug hack
Don't do this is production...
```
Net::HTTP.module_eval do
    alias_method '__initialize__', 'initialize'

    def initialize(*args,&block)
    __initialize__(*args, &block)
    ensure
    @debug_output = $stderr ### if ENV['HTTP_DEBUG']
    end
end
```

## MISC

EACH/DO
-------
[ 'cat', 'dog', 'horse' ].each do |animal|
  print animal, " -- "
end
-----
ls -l /usr/lib/jvm | ruby -e 'STDIN.readlines.each {|line| puts line[40..-1]}'


ONE LINE LOOP
-------------
(1..10).each { |i| puts i }


WHILE LOOP
----------
i = 0
while i < 5 do
   puts i
   i += 1
end


UNTIL LOOP
----------
i = 0
until i == 4
   puts i
   i += 1
end


FOR LOOP
--------
for line_index in (1..num_lines)
   puts line_index
end


EACH LOOP
---------
input.readlines.each do |line|
   puts line
end 


IF/THEN/ELSE
------------
if <<>> 
then # ==> Optional here...
  ...
elsif <<>>
  ...
else
  ...
end


CMD LINE ARGUMENTS
------------------
ARGV.size
ARGV[4]
CATCH: ARGV[0] is the FIRST argument.  ($0 is the name of the current program...)


CASE
----
*** Output is stderr, or a specified file...
case ARGV.size
  when 0, 1
    out = $stdout
  else
    out = File.open( ARGV.slice!(-1,1)[0], "w" )
end


EXECTE A SHELL COMMAND
----------------
file='t.txt'
`ls #{file}`

-- OR --
system("ls *.txt")  --> Returns true or false....
puts $?.exitstatus   ---> The actual return code.


PRINT A PROGRESS INDICATION IN THE SAME SPOT ON THE SCREEN - LOOP
-----------------------------------------------------------------
0.step(100, 10) do |i|
    printf((i < 100 ? "\rProgress:  %02d\%" : "\rProgress: %3d\%"), i)
    $stdout.flush
    sleep(0.3)
end
puts 


PRINT TO STDERR
---------------
STDERR << 'STDERR output' << "\n"


MISC COMMAND LINE SCRIPTS - One Liners one-liners
-------------------------------------------------
*** Get the basename of a file path.
echo fun/no/t.sh | ruby  -e 'puts File.basename(STDIN.readline); puts "next line"'

*** Chop grep -R output, and filter out .svn, ~, and .swp...
  grep -Rni USER_PROCESS_RESTART ../sipXpbx/ | ruby -e 'STDIN.readlines.each {|x| if nil == x.index(".svn") && nil == x.index("~") && nil == x.index(".swp") then puts " - " << x[14..-1] end }'

*** For each file path read from input, whether or not some part of the dir path is a symbolic link.
  ruby -e 'puts ""; STDIN.readlines.each {|line| comps=File.dirname(line).split("/"); go=""; comps.each {|comp| go<<comp; if File.symlink?(go) then puts "Symlink #{go}!!" end; go<<"/"; }; puts "";}'

cat just.txt | ruby -e 'STDIN.readlines.each {|line| if nil == line.index("-devel-") then puts line end}'

*** Format and Print the SIP messages containing "47.135.152.76" from sipX sipXproxy.log
grep "Read SIP message" sipXproxy.log | grep "47.135.152.76" | ruby -e 'STDIN.readlines.each {|line| puts line.split("Read SIP message:")[1][0..-3].gsub(/\\n/, "\n").gsub(/\\r/, "").gsub(/\\/, "")}'

**** Translate MAC into format expected by sipXconfig.
ruby -e 'puts "00:40:5A:17:CB:31".downcase.tr_s(":","")'
ruby -e 'puts ARGV[0].downcase.tr_s(":","")' 00:40:5A:17:CB:31
   # --> 00405a17cb31

**** Find and replace a string ****
cat in | ruby -e 'STDIN.readlines.each {|line|puts line.gsub(/(trace.xml)/, "trace.str") }' > out

**** Find and replace a string in a file, making a copy of the original ****
ruby -e 'require "ftools"; live=#{ARGV[0]; orig="#{ARGV[0]}.ORIG"; File.copy(live,orig); output=File.open(live,"w"); File.open(orig,"r").readlines.each {|line| output.puts line.gsub(/FUN="0"/, "FUN=\"1\"")}; output.close' <MAC>

**** Run a command until it fails, then print the date.
ruby -e 'while `ls fun` != ""; end; puts Time.now' 
   PWM --> NOPE!!!

**** CPU load
ruby -e 'i=0; while i < 5 do {} end'

**** Print ... X second indications
ruby -e '1.step(20,1){|i| print "."; $stdout.flush; sleep 1}'
ruby -e 'while true; print "."; $stdout.flush; sleep 120; end'


SAVE A WORD DOC IN RTF FORMAT
-----------------------------
1.upto(countOfFoundFiles){|i| 
  @docname = msword.FileSearch.FoundFiles(i)
  msword.documents.open(@docname)
  @rtfname = String.new(@docname)
  #Remove the .doc from the end
  @rtfname.chop!
  @rtfname.chop!
  @rtfname.chop!
  @rtfname.chop!
  #Append the .rtf extension
  @rtfname << '.rtf'
  #Save the RTF file
  #In VBA, the constant wdFormatRTF is 6
  msword.ActiveDocument.SaveAs(@rtfname, 6)
  msword.ActiveDocument.Close
}


FIND AND REPLACE A WORD OR PHRASE IN A BATCH OF WORD DOCS
---------------------------------------------------------
require 'win32ole'
msword = WIN32OLE.new('Word.Application')
msword.Visible = true
msword.FileSearch.NewSearch
msword.FileSearch.LookIn = 'C:\test'
msword.FileSearch.SearchSubFolders = true
msword.FileSearch.FileName = '*.doc'
# In VBA, the constant msoFileTypeAllFiles is 1
msword.FileSearch.FileType = 1
msword.FileSearch.Execute
countOfFoundFiles = msword.FileSearch.FoundFiles.Count
#Open all the found Word documents.
1.upto(countOfFoundFiles){|i| 
  @docname = msword.FileSearch.FoundFiles(i)
  msword.documents.open(@docname)
  #Replace the old word with the new word
  msword.Selection.Find.Text = 'VBA'
  msword.Selection.Find.Replacement.Text = 'Ruby'
  msword.Selection.Find.Execute
  msword.ActiveDocument.Save
  msword.ActiveDocument.Close
} 


DATE/TIME MANIPULATION
----------------------
require 'date' #at the top of the script



aNewDate=Date::new(2004,8,12) #year,month,day

aNewDate::to_s #gives u the saved date as a string, UGLY!!

aNewDate=aNewDate::+1 #increases by 1 day

aNewDate=aNewDate::-1 #decreases by 1 day

day=aNewDate::wday() # gives the day of the week as a number, sun=0, mon=1....
week=aNewDate::cweek() #gives the week of year as a number
   
toDaysDate=Date::today() #creates a Date object with todays date

Date._parse("2008-01-10T13:58:22.260676") #heuristics to parse the date...


** TIME is better!! **

irb(main):008:0> Time.now
=> Wed Jun 25 10:50:43 -0400 2008

  tmp = Time.parse(line[1..26])

  utc_time = Time.utc(tmp.year,tmp.month,tmp.day,tmp.hour,tmp.min,tmp.sec,tmp.usec)
  local_time = utc_time.localtime

  format_str = "%I:%M:%S."
  if false
  then
    format_str = "%b %d " + format_str # Include Month & Day
  end

  alt_line = local_time.strftime(format_str) << local_time.usec.to_s[0..2] << alt_line


HTTP - Over-ride 'User-Agent'
-----------------------------
In class HTTPGenericRequest, method initialize, line: "self['User-Agent'] ||= 'Ruby'"


HTTP - Download a binary file
-----------------------------
require 'net/http'
URL = 'http://www.nortelscs.com/scs/sites/default/files/DEMO_scs_3.10.1_008630_012233_i386.iso'
Net::HTTP.start("www.nortelscs.com") { |http|
  resp = http.get("/scs/sites/default/files/DEMO_scs_3.10.1_008630_012233_i386.iso")
  open("tmp.iso.jpg", "wb") { |file|
    file.write(resp.body)
   }
}
puts "Yay!!"


HTTP - wget equivalent
----------------------
require 'open-uri'
puts open('http://cbc.ca/news').read

  
TAR
----
# REQUIRES: sudo gem install archive-tar-external
#!/usr/bin/env ruby

require 'rubygems'
require 'archive/tar_external'

# Create
#tar = Archive::Tar::External.new("flipper.tar", "*.txt")

# Expand
tar = Archive::Tar::External.new("flipper.tar")
puts tar.info
tar.expand_archive


FTP
---
require 'net/ftp'
ftp = Net::FTP.new(FTP_SERVER)
ftp.login(id, password)
ftp.list("file.txt") --> may throw Net::FTPError
ftp.chdir(DIR_NAME)
ftp.list.each { |i| puts i }
etc.


HASH
----
h = {}
h["one"] = 1
h["two"] = 2
sorted_nested_array = h.sort


REST CLIENT
-----------
   ---> NEEDS "gem install rest-client"  (Run under "root", using "sudo" doesn't seem to do it....)
   ---> http://rest-client.heroku.com/rdoc/
[sipxchange@bcmsl2125 sipXivr]$ ruby -e "require 'rubygems'; require 'rest_client'; puts RestClient.get('https://200:1234@bcmsl2125.ca.nortel.com:8443/sipxconfig/rest/my/phonebook', :accept=>'text/xml')"
<phonebook/>

   [sipxchange@bcmsl2125 sipXivr]$ ruby -e "require 'rubygems'; require 'rest_client'; puts RestClient.post('https://200:1234@bcmsl2125.ca.nortel.com:8443/sipxconfig/rest/my/phonebook', '<phonebook><entry><first-name>Penguin</first-name><last-name>Emporer</last-name><number>happyfeet@southpole.org</number></entry></phonebook>')"
[NOTHING]


SFTP with publickey (no passwords) 
----------------------------------

#!/usr/bin/env ruby

# http://net-ssh.rubyforge.org/chapter-2.html#s1  yup!!!!

require 'rubygems'

# Beforehand:  (not as root, as the user!!)  ---> MAYBE NOT!!!! (i.e. no "gem"!!!)
#  sudo gem install -y net-ssh --no-rdoc
#  sudo gem install -y net-sftp --no-rdoc

#gem 'net-ssh'
#gem 'net-sftp'

require 'net/ssh'
require 'net/sftp'

Net::SSH.start('zcarh0xd.ca.nortel.com',
               'mossmanp',
               :auth_methods => [ "publickey" ]) do |session|
  session.sftp.connect do |sftp|
    sftp.get_file("remote_flipper", "local_flipper")
  end
end


SEND MAIL
---------
If you have a SMTP server avaliable you can use the script below:

require 'net/smtp'

class SendMail < Net::SMTP
     def initialize(options)
         super
         @user     = options["user"]  
         @from     = options["from"] 
         @to       = options["to"].to_a 
         @pass     = options["pass"]  
         @server   = options["server"]
         @subject  = options["subject"]
     end

     def body=(mail_body)
         # BUILD HEADERS
         @body =  "From: #{@from} <#{@from}>\n" 
         @body << "To: #{@to}<#{@to}>\n"
         @body << "Subject: #{@subject}\n"
         @body << "Date: #{Time.now}\n"
         @body << "Importance:high\n"
         @body << "MIME-Version:1.0\n"
         @body << "\n\n\n"

         # MESSAGE BODY
         @body << mail_body
     end

     def send
       @to.each do | to |
          Net::SMTP.start(@server, 25 , @from , @user , @pass , :login)  do |smtp|
            smtp.send_message(@body,@from,to)
          end
       end
     end
end

if __FILE__ == $0
    print  %^USAGE:
    o=Hash.new    
    o["user"]    = "userid"
    o["from"]    = "rodrigo.bermejo / ae.ge.com"
    o["pass"]    = "neverguess"
    o["server"]  = "smtp server"
    o["subject"] = "TEST MESSAGE"
    mail=SendMail.new(o)
    mail.body="Hi buddy"
    mail.send
    ^
end

JSON PARSE
----------
ruby -rjson -e 'j = JSON.parse(File.read("test.json")); puts j["Instances"][0]["ImageId"]'


XML PARSE
---------
/etc/sipxpbx/resource-lists.xml:
 <?xml version="1.0" encoding="UTF-8"?>
 <lists xmlns="http://www.sipfoundry.org/sipX/schema/xml/resource-lists-00-00">
   <list user="~~rl~6">
     <name>205</name>
     <resource uri="sip:201@example.com">
       <name>201</name>
     </resource>
   </list>
   <list user="~~rl~2">
     <name>201</name>
     <resource uri="sip:200@example.com">
       <name>200</name>
     </resource>
     <resource uri="sip:201@example.com">
       <name>201</name>
     </resource>
     <resource uri="sip:202@example.com">
       <name>202</name>
     </resource>
   </list>
 </lists>

ruby -e 'require "rexml/document"; include REXML; file = File.new("/etc/sipxpbx/resource-lists.xml"); doc = Document.new(file); doc.elements[1].elements.each {|x| if x.elements["name"].text==ARGV[0] then puts "   RLS URI for #{ARGV[0]}: #{x.attributes["user"]}@<SIP Domain>" end}' 201
 \-->    RLS URI for 201: ~~rl~2@<SIP Domain>


XML PRETTY PRINT
----------------
ruby -e 'require "rexml/document"; include REXML; Document.new(File.new("227.xml")).write($stdout,3);'

FILE:
ruby -e 'require "rexml/document"; include REXML; formatter = REXML::Formatters::Pretty.new; formatter.compact = true; doc = Document.new(File.new("227.xml")); puts formatter.write(doc.root,"The whole XML document: ")'
 
STDIN:
 curl .... 2> /dev/null | ruby -e 'require "rexml/document"; include REXML; formatter = REXML::Formatters::Pretty.new; formatter.compact = true; doc = Document.new(STDIN); puts formatter.write(doc.root,"The whole XML document: ")'


INCLUDING OTHER FILES
---------------------
load "go_settings.rb" # --> includes the named Ruby source file every time the method is executed
require "go_settings" # --> loads any given file only once (and can load shared binary libraries)


# Misc

## General

## "reflection": Print an array of methods
```rb
Greeter.instance_methods
```



