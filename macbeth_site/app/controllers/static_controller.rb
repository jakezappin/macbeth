require 'net/http'

class StaticController < ApplicationController

  def index
    render "index"
  end

  def display
    text = get_xml(params[:uri])
    save_xml_to_file(text, 'current_play.txt')
    @speakers = count_lines('current_play.txt')
    render "display"
  end


  def get_xml(uri_input)
    uri_address = URI(uri_input)
    res = Net::HTTP.get_response(uri_address)
  end

  def save_xml_to_file(xml_text, filename)
    new_file = File.new(filename, "w+")
    new_file.puts(xml_text.body)
    new_file.close
  end

  def count_lines(filename)

    speakers = {}
    current_speaker = ""
    found_title = false

    File.readlines(filename).each do |line|

      if line.include?("<SPEAKER>")
        current_speaker = line.gsub("<SPEAKER>", "").gsub("</SPEAKER>", "").gsub("\n", "")
      elsif line.include?("<LINE>") && current_speaker
        if speakers[current_speaker]
          speakers[current_speaker] += 1
        else
          speakers[current_speaker] = 1
        end
      elsif line.include?("</SPEECH>")
        current_speaker = ""
      elsif line.include?("<TITLE>") && !found_title
        @title = line.gsub("<TITLE>", "").gsub("</TITLE>", "").gsub("\n", "")
        found_title = true
      end
    end

    speakers.delete("ALL")
    speakers.delete_if {|key, value| value == 0 }
    speakers = speakers.sort_by {|_key, value| value}.reverse.to_h
    return speakers

  end

end
