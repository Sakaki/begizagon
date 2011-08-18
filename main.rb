# -*- coding: utf-8 -*-

bitexts = [
           {"e" => ["this","pen"],
            "j" => ["この","ペン"]},
           {"e" => ["this","book"],
            "j" => ["この","本"]},
           {"e" => ["that","book"],
            "j" => ["あの","本"]}
]

enumbers = {}
jnumbers = {}

require 'pp'
pp bitexts

#convert strings to numbers
n=0
m=0
j=0
through = false

i=0
bitexts.each do |bitext|
  bitexts[i].keys.each do |key|
    j=0
    terms = bitext[key]
    terms.each do |term|
      if(key == "e")

        enumbers.keys.each do |number|
          if(number == term)
            through = true
            bitexts[i]["e"][j] = enumbers[number]
            break
          end
        end
        if(through == false)
          bitexts[i]["e"][j] =n
          enumbers[term] = n
          n+=1
        else
          through = false
        end

      else

        jnumbers.keys.each do |number|
          if(number == term)
            through = true
            bitexts[i]["j"][j] = jnumbers[number]
            break
          end
        end
        if(through == false)
          bitexts[i]["j"][j] =m
          jnumbers[term] = m
          m+=1
        else
          through = false
        end
      end

      j+=1
    end
  end
  i+=1
end

pp bitexts

include = {}
enumbers.size.times do |i|
  bitexts.size.times do |j|
    bitexts[j]["e"].each do |k|
      if(i == k)
        include[i] ||= []
        include[i] << j
      end
    end
  end
end

pp include
