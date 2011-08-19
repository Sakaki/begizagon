#!/usr/bin/env ruby1.9.1
# -*- coding: utf-8 -*-
#

DATAPATH = "begizagon.data"

result = Marshal.load(File.open(DATAPATH, "r"))

tosearch = ARGV[0]
puts tosearch

temp_string = tosearch
temp_value = 0

result.each {|key,value|
  key.each {|string|
    if(string == tosearch)
      if(temp_value < value)
        if(key[0] == string)
          temp_string = key[1]
        else
          temp_string = key[0]
        end
        temp_value = value
      end
    end
  }
}

puts temp_string
