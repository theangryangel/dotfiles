#!/usr/bin/env ruby

require 'date'
puts ((DateTime.parse('2015-07-01')-DateTime.now()).to_f/7).round(1).to_s + ' weeks remaining'
