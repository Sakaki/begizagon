#!/usr/bin/env ruby1.9.1
# -*- coding: utf-8 -*-
#
# This tool fetches Wordnet corpus and load them into the database.

require 'rubygems'
require 'zlib'
require 'open-uri'
require 'groonga'

SOURCE = "http://nlpwww.nict.go.jp/wn-ja/data/1.1/wnjpn-exe.tab.gz"
DEFAULT_DBPATH = "corpus.db"

puts <<END
downloading Wordnet example corpus.
The original copyright is as follows.

   Japanese Wordnet (v1.1) NICT, 2009-2010
   linked to http://nlpwww.nict.go.jp/wn-ja/index.en.html

END

$dbpath = ARGV[0] || DEFAULT_DBPATH
Groonga::Database.create(:path => $dbpath)
Groonga::Schema.define do |schema|
  schema.create_table("Terms",
                      :type => :patricia_trie,
                      :key_normalize => true,
                      :default_tokenizer => "TokenMecab")
  schema.create_table("Corpus", :type => :patricia_trie) do |table|
    table.reference("eng", "Terms", :type => :vector)
    table.reference("jpn", "Terms", :type => :vector)
  end
end

corpus = Groonga["Corpus"]
Zlib::GzipReader.new(open(SOURCE)).each{|l|
  id, n, e, j = l.split(/\t/,4)
  corpus.add(id + n.to_s, :eng => e, :jpn => j)
}
puts "#{corpus.size} records loaded to database '#{$dbpath}'"
