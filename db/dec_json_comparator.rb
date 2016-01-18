# Compares two json files for differences using HashDiff. Order of arrays does not matter.
# No output will be given if no differences were found.
require "json"
require "hashdiff"

# Deep sorts jsons by id's
def sort!(json)
  if json.respond_to?("sort!")
    json.sort! { |x, y| x["id"] <=> y["id"] }
    json.each { |h| sort!(h) }
  end
  if json.respond_to?("each_pair")
    json.each_pair { |k, _v| sort!(json[k]) }
  end
end

file1_path = ARGV[0]
file2_path = ARGV[1]
unless File.exist?(file1_path)
  fail "'#{file1_path}' not found."
end

unless File.exist?(file2_path)
  fail "'#{file2_path}' not found."
end

file1 = File.read(file1_path)
json1 = JSON.parse(file1)
sort!(json1)
file2 = File.read(file2_path)
json2 = JSON.parse(file2)
sort!(json2)

diff = HashDiff.diff(json1, json2)
if diff.any?
  print "HashDiff of '#{file1_path}' and '#{file2_path}':\n"
  print HashDiff.diff(json1, json2)
  print "\n"
end
