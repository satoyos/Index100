# -*- coding: utf-8 -*-
Given /^I am on the StartScreen$/ do
  element_exists("view")
end

Then /^I select (\d+)$/ do |row_number|
  query("view:'UIPickerView'", [{selectRow: row_number}, {inComponent: 0}, {animated: 1}])
end

Then /^I input correct kimariji$/ do
  kimari_ji = query("view:'GameView'", "poem", "kimari_ji").first
  puts "決まり字 => #{kimari_ji}, 文字数 => #{kimari_ji.split("").size}"
  kimari_ji.split("").each do |char|
    puts "tap => #{char}"
#    touch("view marked:'#{char}'")
#noinspection RubyArgCount
    tap "#{char}"
    sleep 0.7
  end
end
