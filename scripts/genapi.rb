require "erb"
require "fileutils"
require "uri"

DEVELOP_GIT_URL = URI("https://github.com/github/developer.github.com.git")
LOCAL_GIT_DIR = File.basename(DEVELOP_GIT_URL.path).sub(/\.git$/, "")
CONTENT_DIR = File.join(LOCAL_GIT_DIR, "content/v3")
TEMPLATE_ERB = ERB.new(File.read("template.erb"), nil, "<>")
IGNORE_FILE = %W(v3/mimes v3/oauth)


unless File.exist?(LOCAL_GIT_DIR)
  system("git clone #{DEVELOP_GIT_URL}")
end

api_count = Hash.new{|h,k| h[k] = 0 }
file_api = Hash.new{|h,k| h[k] = [] }
section = nil
description = nil
Dir["#{CONTENT_DIR}/**/*.md"].each do |md|
  basename = md.sub(/^.*v3/, "v3").sub(/\.md$/, "")
  next if IGNORE_FILE.include?(basename)

  spec = File.read(md)
  contents = []
  spec.split(/^## /).each do |sec|
    apis = sec.scan(/^\s+(GET|POST|PUT|PATCH|DELETE)\s+(\S+)/)
    if apis.empty?
      sec.gsub!(/^/, "; ")
      sec.gsub!(/^;\s+$/, "")
      contents << sec
    else
      apis.each do |(verb, template)|
        api = template.gsub(/:/, "$").gsub(/_/, "-")
        args = template.scan(/[:*](\w+)/).flatten.map{|e| e.gsub(/_/, "-") }
        arg_list = args * " "
        desc = sec.gsub(/\"/, "\\\"")
        contents << "(define-github-core :#{verb} \"#{template}\" \"\n## #{desc}\")\n\n"
      end
    end
  end

  outfile = File.join("../site-lisp/github/api", "#{basename}.l")
  FileUtils.mkdir_p(File.dirname(outfile))
  open(outfile, "w") do |w|
    w.puts TEMPLATE_ERB.result(binding)
    puts outfile
  end
end
