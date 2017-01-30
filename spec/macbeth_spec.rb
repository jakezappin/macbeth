require 'spec_helper'
require 'nokogiri'
require './macbeth'

describe "#get_xml" do

  let(:note) { get_xml('http://www.w3schools.com/xml/note.xml')}
  let(:macbeth) { get_xml('http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml') }

  #General Tests
  it "accepts one argument, a uri" do
    expect { get_xml('http://www.w3schools.com/xml/note.xml') }.to_not raise_error
  end

  it "should return text" do
    expect(note).to be_truthy
  end

  it "should contain 'Don't forget me this weekend!' in the returned text" do
    expect(note.body).to include("Don't forget me this weekend!")
  end

  #Macbeth Specific Tests
  it "should return the text" do
    expect(macbeth).to be_truthy
  end

  it "should contain '<SPEAKER>MACBETH</SPEAKER>' in the returned text during runtime of macbeth.rb" do
    expect(macbeth.body).to include("<SPEAKER>MACBETH</SPEAKER>")
  end

end

describe "#save_xml_to_file" do

  #General Tests
  it "should create 'note.txt'" do
    xml_test = get_xml('http://www.w3schools.com/xml/note.xml')
    new_filename = 'note.txt'
    save_xml_to_file(xml_test, new_filename)
    exists = File.exists?("note.txt")
    expect(exists).to eq(true)
  end

  it "should contain 'Don't forget me this weekend!' in the text" do
    test_note = File.read("note.txt")
    expect(test_note).to include("Don't forget me this weekend")
  end

  #Macbeth Specific Tests
  it "should create 'macbeth.txt' during runtime of macbeth.rb" do
    exists = File.exists?("macbeth.txt")
    expect(exists).to eq(true)
  end

  it "should contain '<SPEAKER>MACDUFF</SPEAKER>' in the text save" do
    macbeth_text = File.read("macbeth.txt")
    expect(macbeth_text).to include("<SPEAKER>MACDUFF</SPEAKER>")
  end

end

describe "#count_lines" do

  #General Tests
  it "should have 3 lines for Jake and 4 lines for Kristen" do
    test_hash = count_lines('jakeplay.txt')
    expect(test_hash['Jake']).to eq(3)
    expect(test_hash['Kristen']).to eq(4)
  end

  #Macbeth Tests
  it "should have 718 lines for Macbeth, 265 lines for Lady Macbeth and 11 lines for Old Man" do
    macbeth_hash = count_lines('macbeth.txt')
    expect(macbeth_hash["MACBETH"]).to eq(718)
    expect(macbeth_hash["LADY MACBETH"]).to eq(265)
    expect(macbeth_hash["Old Man"]).to eq(11)
  end

end
