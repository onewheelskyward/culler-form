require_relative 'what.rb'
describe "tests" do
	it "should give me stuff when I piece apart a listing" do
		listing_html = '<span class="i">&nbsp;</span> <span class="pl"> <span class="itemdate">Apr 16</span> <a href="http://portland.craigslist.org/mlt/apa/3748006047.html">Bay windows-May move in available</a> </span> <span class="itempnr"> $635 / 1br - 769ft&sup2; -  <span class="itempp"></span> <font size="-1"> (Portland)</font> </span>  <span class="itempx"> <span class="p"> img&nbsp;<a href="#" class="maptag" data-pid="3748006047">map</a></span></span> <br class="c">'
		listing = disassemble listing_html
		listing[:date].should == "Apr 16"
		listing[:link_url].should == "http://portland.craigslist.org/mlt/apa/3748006047.html"
		listing[:link_text].should == "Bay windows-May move in available"
		listing[:price].should == 635
		listing[:sqft].should == 769
		listing[:location].should == "Portland"
	end
	it "should give me a Listing when I piece apart a listing" do
		listing_html = '<span class="i">&nbsp;</span> <span class="pl"> <span class="itemdate">Apr 16</span> <a href="http://portland.craigslist.org/mlt/apa/3748006047.html">Bay windows-May move in available</a> </span> <span class="itempnr"> $635 / 1br - 769ft&sup2; -  <span class="itempp"></span> <font size="-1"> (Portland)</font> </span>  <span class="itempx"> <span class="p"> img&nbsp;<a href="#" class="maptag" data-pid="3748006047">map</a></span></span> <br class="c">'
		listing = Listing.create(disassemble listing_html)
		listing[:date].should == "Apr 16"
		listing[:link_url].should == "http://portland.craigslist.org/mlt/apa/3748006047.html"
		listing[:link_text].should == "Bay windows-May move in available"
		listing.price.should == 635
		listing[:sqft].should == 769
		listing[:location].should == "Portland"
	end
end
