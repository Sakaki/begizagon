#!/usr/bin/env ruby1.9.1
# -*- coding: utf-8 -*-
#

require 'rubygems'
require 'groonga'
require 'pp'

DEFAULT_DBPATH = "/tmp/wnjpn.db"

$dbpath = ARGV[0] || DEFAULT_DBPATH
Groonga::Database.open($dbpath)

def dump_all_term_id
  Groonga["Corpus"].each{|rec|
    eng = rec.eng.collect{|t| t.id}
    jpn = rec.jpn.collect{|t| t.id}
    pp [eng, jpn]
  }
end

def dump_all_term
  Groonga["Corpus"].each{|rec|
    eng = rec.eng.collect{|t| t.key}
    jpn = rec.jpn.collect{|t| t.key}
    pp [eng, jpn]
  }
end

dump_all_term
