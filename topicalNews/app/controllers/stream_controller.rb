class StreamController < ApplicationController
    
    @listOfStreams = 
    [
        {"name" => "npr-headlines", "url" => "http://www.npr.org/rss/rss.php?id=1001"}
    ]
    
    def show
        
        #get what is in the stream now#
        @stream = Feedjira::Feed.fetch_and_parse('file:///home/feedzirra/examples/feed.rss')
        #get what is in the stream now#
        
        
        
    end
    
    def index
        
        #get what is in the stream now#
        @stream = Feedjira::Feed.fetch_and_parse('http://feeds.bbci.co.uk/news/rss.xml')
        #get what is in the stream now#
        
        
        
    end
    
end