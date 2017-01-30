require 'net/http'

def get_xml(uri)
  uri = URI(uri)
  res = Net::HTTP.get_response(uri)
end

def save_xml_to_file(xml, filename)
  macbeth = File.new(filename, "w+")
  macbeth.puts(xml.body)
  macbeth.close
end

def count_lines(filename)

  speakers = {}
  current_speaker = ""

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
    end
  end

  return speakers

end

def pretty_print_hash(hash)

  hash = hash.sort_by {|_key, value| value}.reverse.to_h
  hash.delete("ALL")
  hash.delete_if {|key, value| value == 0 }

  hash.each do |key, value|
    puts value.to_s + " " + key.downcase.split(" ").map(&:capitalize).join(" ")
  end

end

macbeth_uri = 'http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml'
macbeth_xml = get_xml(macbeth_uri)
save_xml_to_file(macbeth_xml, 'macbeth.txt')
macbeth_speakers = count_lines('macbeth.txt')
pretty_print_hash(macbeth_speakers)
