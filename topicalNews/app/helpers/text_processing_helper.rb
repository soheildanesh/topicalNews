module TextProcessingHelper    
    #public
    def self.test
        return true
    end
    
    #Description: break text into ngrams and return those that do not contain punctuations and stop words (except for 'of')
    def self.getNgramCounts text
        
        ngramPositions = Hash.new
        stemmap = Hash.new
        countHash = Hash.new

        #BREAK TEXT INTO WORDS
        words = text.split
        
        #GENERATE AND COUNT NGRAMS AT EACH WORD
        for i in 0 .. words.size-1
            ngrams = Array.new()
            ngram = ""
            for j in i .. i + @maxNforGrams-1
                if(j > words.size-1)
                    break
                end
                    
                word = words[j].strip
                
                ngram = ngram+" "+word
                ngram = ngram.strip
                ngram = ngram.downcase
                
                #SKIP NGRAMS CONTAINING STOP WORDS EXCEPT OF OR [ ]CONTAINING PUNCTUATIONS
                if includesStopwords? ngram
                   next 
                end
                #SKIP NGRAMS CONTAINING STOP WORDS EXCEPT OF
                
                
                #STEM NGRAM
                stemmedngram = recStemTerm ngram
                #STEM NGRAM
                
                
                #MAP FROM STEMMED NO NON STEMMED FORMS WITH FREQUENCY FOR EACH
                if not stemmap.nil?
                    #make a map from a stem to all terms that stem to it, and their respective counts ie @stemmap[stem] = { term1:count, term2:count} NOTE that the COUNTS ARE CORPUS WIDE
                    if not stemmap.has_key? stemmedngram
                        stemmap[stemmedngram] = Hash.new
                    end

                    if stemmap[stemmedngram].has_key? ngram        
                        stemmap[stemmedngram][ngram] = @stemmap[stemmedngram][ngram] + 1
                    else
                        stemmap[stemmedngram][ngram] = 1
                    end
                end
                #MAP FROM STEMMED NO NON STEMMED FORMS WITH FREQUENCY FOR EACH
                    

                #RECORD STEMMED NGRAM OCCURRENCE POSITIONS
                if not ngramPositions.nil?
                    if ngramPositions[stemmedngram].nil?
                        ngramPositions[stemmedngram] = Array.new
                    end
                    ngramPositions[stemmedngram] << i
                end
                #RECORD STEMMED NGRAM OCCURRENCE POSITIONS
                
                
                #ADD NGRAM TO NGRAMS FOR THIS WORD
                ngrams << stemmedngram
                #ADD NGRAM TO NGRAMS FOR THIS WORD                
                
            end

            
            #COUNT GENERATED NGRAMS
            for ngram in ngrams
                #if not @removePuncsInCleanNotEliminatePuncs  and ngramHasNonLetterInMiddle ngram
                if ngram.include? "***"  #now that we have  replacePuncs text, " *** " uptop we can do this instead of ngramHasNonLetterInMiddle, which if this works will be obsolete june 10 2014
                    #@outputFile.puts("doing eliminating puncs, deleted #{ngram}")
                    next 
                end
        
                ngram = ngram.downcase
                
                if(countHash.has_key? ngram)
                    countHash[ngram] = countHash[ngram] + 1
                else
                    countHash[ngram] = 1
                end 
            end 
            #COUNT GENERATED NGRAMS
            
        end
        #GENERATE AND COUNT NGRAMS AT EACH WORD
        
    end
    
    def includesStopwords? text, excludedStops = 'of', extraStops = []
        words = ngram.split(" ")
        stopwords = Array.new
        for word in words
            if Stopwords.is? word  or extraStops.include? word #Stopwords.is? is from stopwords gem
                if excludedStops.include? word
                    next
                else
                    stopwords << word
                end
            end
        end
        
        if stopwords.size > 0
            return true
        else
            return false
        end
    end
    
    def addtoNgramCount text, countHash, docPerNgramCountHash = nil, sumLengthNormTfHash= nil, sumLengthNormLogTfHash = nil, ngramFirstOccurencePosition = nil, ngramLastOccurrencePosition = nil, ngramPositions = nil, customizedCount = nil, stemmap = nil
        
        ngramAlreadySeenInDoc = Hash.new
        text = replacePuncs text, " *** "
        words = text.split
        #puts("words = #{words}")
        #for n in 1 .. @maxNforGrams
        
        Hash tf = Hash.new()
        
        
        for i in 0 .. words.size-1

            #generate ngrams at each word
            ngrams = Array.new()
            ngram = ""
            for j in i .. i + @maxNforGrams-1
                if(j > words.size-1)
                    break
                end
                    
                word = words[j].strip

                #word = recStemTerm word >> replaced with recStemTerm ngram below so stemmap which is populated in recStemTerm gets a map of all ngrams not single words
                
                ngram = ngram+" "+word
                ngram = ngram.strip
                ngram = ngram.downcase
                
                #detect and remove ngrams containing stopwords before stemming,
                if ngramIncludesStopword? ngram
                   next 
                end
                
                stemmedngram = recStemTerm ngram
                
                if not stemmap.nil?
                    #make a map from a stem to all terms that stem to it, and their respective counts ie @stemmap[stem] = { term1:count, term2:count} NOTE that the COUNTS ARE CORPUS WIDE
                    if not stemmap.has_key? stemmedngram
                        stemmap[stemmedngram] = Hash.new
                    end

                    if stemmap[stemmedngram].has_key? ngram        
                        stemmap[stemmedngram][ngram] = @stemmap[stemmedngram][ngram] + 1
                    else
                        stemmap[stemmedngram][ngram] = 1
                    end
                end
                
                #record first position of occurrence
                if(not ngramFirstOccurencePosition.nil? and not ngramFirstOccurencePosition.has_key? stemmedngram)
                    ngramFirstOccurencePosition[stemmedngram] = i+1 #+1 since i is zero based
                end
                
                #record last position of occurrence
                if(not ngramLastOccurrencePosition.nil? )
                    ngramLastOccurrencePosition[stemmedngram] = i+1 #+1 since i is zero based
                end
                    
                ngrams << stemmedngram
                
                if not ngramPositions.nil?
                    if ngramPositions[stemmedngram].nil?
                        ngramPositions[stemmedngram] = Array.new
                    end
                    ngramPositions[stemmedngram] << i
                end
                
            end
            
            if not ngramPositions.nil?
                ngramPositions['docLength'] = words.size-1
            end
            
            #>> corpus wide ngramCount doesn't "widespread deploy" but it has widespread deploi, so now i wanna make sure everything actually gets stemmed in here
            #add each ngram to term freuqncy and doc frequency hashes
            for ngram in ngrams
                
                
                #if not @removePuncsInCleanNotEliminatePuncs  and ngramHasNonLetterInMiddle ngram
                if not @removePuncsInCleanNotEliminatePuncs  and ngram.include? "***"  #now that we have  replacePuncs text, " *** " uptop we can do this instead of ngramHasNonLetterInMiddle, which if this works will be obsolete june 10 2014
                    #@outputFile.puts("doing eliminating puncs, deleted #{ngram}")
                    next 
                end
                
                ngram = ngram.downcase
                
                #still gotta clear puncs not in the middle                
                #ngram = replacePuncs ngram.downcase
                
                #puts("ngram = #{ngram}")
                if(countHash.has_key? ngram)
                    countHash[ngram] = countHash[ngram] + 1
                else
                    countHash[ngram] = 1
                end
                
                if not customizedCount.nil?
                    
                    firstOccBefore1000 = false
                    if firstOccBefore1000
                        if ngramFirstOccurencePosition[ngram] < 600
                            if customizedCount.has_key? ngram
                                customizedCount[ngram] = customizedCount[ngram] + 1
                            else
                                customizedCount[ngram] = 1
                            end
                        end
                    end
                    
                    ctfLograithmicPos = false
                    if ctfLograithmicPos
                        
                        if words.size < 25000
                            cutoffPosition = 25000.0
                        else
                            cutoffPosition = words.size * 0.5
                        end

                        if customizedCount.has_key? ngram
                            customizedCount[ngram] = customizedCount[ngram] - 1.0 * Math.log(Float(ngramFirstOccurencePosition[ngram] + 1.0) / cutoffPosition)
                        else
                            customizedCount[ngram] =  - 1.0 * Math.log(Float(ngramFirstOccurencePosition[ngram] + 1.0) / cutoffPosition)
                        end
                    end
                    

                    
                    normalizeByDocLength = false
                    if normalizeByDocLength
                        if customizedCount.has_key? ngram
                            customizedCount[ngram] = Float(customizedCount[ngram] + 1) / Float(words.size)
                        else
                            customizedCount[ngram] = Float(1.0) / Float(words.size) 
                        end
                    end
                    
                end
                
                #calculate term frequency in this doc used later for normalized average term frequency 
                if(tf.has_key? ngram)
                    tf[ngram] = tf[ngram] + 1
                else
                    tf[ngram] = 1
                end
                
                if(not ngramAlreadySeenInDoc.has_key?(ngram) and not docPerNgramCountHash.nil?)
                    if(docPerNgramCountHash.has_key? ngram)
                        docPerNgramCountHash[ngram]['count'] = docPerNgramCountHash[ngram]['count'] + 1
                    else
                        docPerNgramCountHash[ngram] = Hash.new
                        docPerNgramCountHash[ngram]['count'] = 1
                    end
                    ngramAlreadySeenInDoc[ngram] = true
                end
            end
            
            
            #@numWords = @numWords + 1
            
            
        end

        
        if(not sumLengthNormTfHash.nil?)
            #update normalized term frequency
            tf.each do |ngram, avgLengNormal|
               sumLengthNormTfHash[ngram] = Float(tf[ngram]) / Float(words.size)
               sumLengthNormLogTfHash[ngram] = Math.log(Float(tf[ngram])) / Float(words.size)
            end
        end
            
            
    end
end