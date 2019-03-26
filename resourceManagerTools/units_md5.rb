

#md5码生成
#Author:    dudehan
#Date:  2018-09-17

require 'os'    # gem install os
require_relative 'support'

# //生成hash值
def units_md5_file(filename)
    hash_filename = "#{filename}.hash"
    # puts hash_filename
	if not File.exist?(hash_filename) or File.mtime(filename) > File.mtime(hash_filename)
		absolute_name = File.absolute_path(filename)

		if OS.windows?
			cmd = "md5sum -l #{absolute_name} | gawk \"{print $1}\" > #{hash_filename}"
		else
            cmd = "md5 -r #{absolute_name} | gawk '{print $1}' > #{hash_filename}"
        end
        
		puts cmd
        `#{cmd}`
	end
end

# //遍历文件夹
def units_md5_dir(path) 
   
    Dir.foreach(path) { |filename|

    next if excluded_file?(filename)
    
    full_path = "#{path}/#{filename}"
    if File.directory?(full_path)
        units_md5_dir(full_path)
    else
        units_md5_file full_path
        # file = {}
        # file["path"] = full_path
        # hash_filePath = full_path + '.hash'
        # file["hash"] = gethash(hash_filePath)

        # writeFileToJson(full_path,file)

        # # puts file["hash"]
        # allFiles << file
    end
        # puts filename
    }
end


def units_md5(code,verison) 

    path = "../package/#{code}/#{verison}"
    # puts car_type
    units_md5_dir(path)
end

code = ARGV[0]
verison = ARGV[1]
units_md5 code, verison
