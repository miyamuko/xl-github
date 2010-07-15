require "uri"
require "erb"

DEVELOP_GIT_URL = URI("http://github.com/develop/develop.github.com.git")
LOCAL_GIT_DIR = File.basename(DEVELOP_GIT_URL.path).sub(/\.git$/, "")
POST_DIR = File.join(LOCAL_GIT_DIR, "_posts")

GETAPI_ERB = ERB.new(File.read("getapi.erb"), nil, "<>")
POSTAPI_ERB = ERB.new(File.read("postapi.erb"), nil, "<>")
HEADER_ERB = ERB.new(File.read("header.erb"), nil, "<>")

IGNORE_FILE = %W(general libraries)


unless File.exist?(LOCAL_GIT_DIR)
  system("git clone #{DEVELOP_GIT_URL}")
end

api_count = Hash.new{|h,k| h[k] = 0 }
file_api = Hash.new{|h,k| h[k] = [] }
section = nil
description = nil
Dir["#{POST_DIR}/*.markdown"].each do |md|
  basename = File.basename(md, ".*").gsub(/[0-9-]/, "")
  next if IGNORE_FILE.include?(basename)

  outfile = File.join("../site-lisp/github/api", "#{basename}.l")
  open(outfile, "w") do |w|
    $stdout = w
    spec = File.readlines(md)[4..-1]
    puts HEADER_ERB.result(binding)
    spec.each do |line|
      line.chomp!
      line.sub!(/\s+$/, "")
      case line
      when /\A\s*\z/
        puts
      when /^(#+) +(.+) +#+/
        section = $2.strip
        description = nil
        puts "#{';' * $1.length} #{line}"
      when /^\s*\/?[a-z_]+(\/[:*]?[a-z_]+)+(\s|\z)/
        api = line.strip
        path_template = api.sub(/ .*$/, "").sub(/^\//, "")
        name = "github-" + path_template.gsub(/[:*]\w+/, "").gsub(/\/+/, "-").sub(/^-/, "").sub(/-$/, "")
        args = path_template.scan(/[:*](\w+)/).flatten.map{|e| e.gsub(/_/, "-") }
        arg_list = (args | [nil]) * " "
        if api =~ /POST/ or description =~ /POST/
          puts POSTAPI_ERB.result(binding)
        else
          puts GETAPI_ERB.result(binding)
        end
        api_count[name] += 1
        file_api[basename] << name
      else
        puts "; #{line}"
      end
    end

    puts
    puts
    puts "(provide \"github/api/#{basename}\")"
    puts
    puts ";;; End"
  end

end

$stdout = STDOUT

puts "== Number of API"
puts api_count.keys.length

puts
puts "== API in file"
file_api.keys.sort.each do |file|
  puts "=== #{file}.l"
  puts file_api[file].sort
end

puts
puts "== Conflict API Names"
api_count.each_pair do |k,v|
  p [k, v] if v > 1
end
