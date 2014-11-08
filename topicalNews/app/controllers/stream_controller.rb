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
    
    def digest stream
        # [ ]get current stream posts e.g.
        @stream = Feedjira::Feed.fetch_and_parse('file:///home/feedzirra/examples/feed.rss')
        
        
        #DIGEST EACH POST
        # for each post
        for entry in  @stream.entries
        
            #GET POST TEXT
            title = entry.title
            summary = entry.summary
            text = title + " " + summary
            #GET POST TEXT
            
            #get ngram count
        
            #RECORD EACH NGRAM
            #for each ngram
                
                #ADD NEW NGRAM TO NGRAM TABLE    
                #if in memory NGRAM does not have key for ngram
                    #ngramTable[ngram] = {'today' => count from get ngram count}
                #else
                    #if ngramTable[ngram].has_key? for today
                        #ngramTable[ngram][today] += ngramCount 
                        #ngramTable[ngram][total] += ngramCount
                        #ngramTable[ngram][docCount] += ngramCount
                    #else
                        #ngramTable[ngram][today] = ngramCOunt 
                        #@ngramTable[ngram][total] = ngramCOunt
                    #end
                #end
                #ADD NEW NGRAM TO NGRAM TABLE
                
                #DELETE THIS NGRAM'S COUNTS THAT ARE TOO OLD
                #ngramTable.each |day, weight|
                    #if day < today - 30
                        #remove key value from hash
                    #end
                #end
                #DELETE THIS NGRAM'S COUNTS THAT ARE TOO OLD
                
            #end
            #RECORD EACH NGRAM  
            
            #[ ]get keyphrases with their weights (maybe in weight calculation have to normalize tf by doc length? for comparbility later on)
            
            #RECORD EACH KEYPHRASE
            #for each keyphrase
                
                #ADD NEW KEYPHRASE TO KEYPHRASE TABLE    
                #if in memory keyphraseTable does not have key for keyphrase
                    #keyphraseTable[keyphrase] = {'today' => weight from get keyphrase}
                #else
                    #if keyphraseTable[keyphrase].has_key? for today
                        #keyphraseTable[keyphrase][today] += keyphrase weight from get keyphrase in this post 
                    #else
                        #keyphraseTable[keyphrase][today] = keyphrase weight from get keyphrase in this post 
                    #end
                #end
                #ADD NEW KEYPHRASE TO KEYPHRASE TABLE
                
                #DELETE THIS KEYPHRASE'S COUNTS THAT ARE TOO OLD
                #keyphraseTable.each |day, weight|
                    #if day < today - 30
                        #remove key value from hash
                    #end
                #end
                #DELETE THIS KEYPHRASE'S COUNTS THAT ARE TOO OLD
                
            #end
            #RECORD EACH KEYPHRASE  
            
        end
        #DIGEST EACH POST  
    end
    
    def index
        if not  TextProcessingHelper::test
            throw 'helper method not working'
        end
        
        #get what is in the stream now#
        @stream = Feedjira::Feed.fetch_and_parse('http://feeds.bbci.co.uk/news/rss.xml')
        #get what is in the stream now#
        
        
        
    end
    
end