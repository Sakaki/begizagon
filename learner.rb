#!/usr/bin/env ruby1.9.1
# -*- coding: utf-8 -*-
#

require 'rubygems'
require 'groonga'
require 'pp'

DEFAULT_DBPATH = "corpus.db"
DATAPATH = "begizagon.data"

$dbpath = ARGV[0] || DEFAULT_DBPATH
Groonga::Database.open($dbpath)


#print 'limit :'
#limit = gets.to_i
limit = 1000
size = Groonga["Corpus"].size
limit = size if limit == 0
if(limit > size)
  puts 'Input value is larger than corpus size. No limit set...'
end

#def dump_all_term_id
#  Groonga["Corpus"].each{|rec|
#    eng = rec.eng.collect{|t| t.id}
#    jpn = rec.jpn.collect{|t| t.id}
#    pp [eng, jpn]
#  }
#end

#def dump_all_term
#  Groonga["Corpus"].each{|rec|
#    eng = rec.eng.collect{|t| t.key}
#    jpn = rec.jpn.collect{|t| t.key}
#    pp [eng, jpn]
#  }
#end

#dump_all_term


  count = Hash.new(0)
  score = Hash.new(0)
  total = Hash.new(0)
  i=0
  Groonga["Corpus"].each{|rec|
    i+=1
#    puts "#{i} / #{limit}"
    if(i > limit)
      break
    end
    eng = rec.eng.collect{|t| t.key}
    jpn = rec.jpn.collect{|t| t.key}
    eng.each{|e|
      jpn.each{|j|
        count[[e,j]] += 1
        total[j] += 1
      }
    }
  }

  count.each{|key,value|
    score[key] = value.to_f / total[key[1]]
  }

#  score.each{|key,value|
#    p [key, value]
#  }

for i in 0..5

  puts "#{i}----------- #{Time.now}"

  count = Hash.new(0)
  total = Hash.new(0)
  j=0
  Groonga["Corpus"].each{|rec|
    j+=1
#    puts "#{i} / #{limit}"
    if(j > limit)
      break
    end
    eng = rec.eng.collect{|t| t.key}
    jpn = rec.jpn.collect{|t| t.key}
    stotal = Hash.new(0)
    eng.each{|e|
      jpn.each{|j|
        stotal[e] += score[[e,j]]
      }
    }

    eng.each{|e|
      jpn.each{|j|
        count[[e,j]] += score[[e,j]] / stotal[e]
        total[j] += score[[e,j]] / stotal[e]
      }
    }
  }
  score.each{|key,value|
    score[key] = count[key] / total[key[1]]
#    p [key, format("%8.6f", score[key])]
  }
end

output_file = File.open(DATAPATH, "w")
output_file.write(Marshal.dump(score))

puts '--------------------complete!'
