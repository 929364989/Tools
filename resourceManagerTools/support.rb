
# 通用代码
# Author:    dudehan
# Date:  2018-09-17

require 'json'

def excluded_file?(filename)
	[
        /^\.\.?$/,
        /^\d+\.\d+_\d+\.\d$/,
		/^manifest\.json$/,
		/^.*\.hash$/,
		/^history\.json$/,
        /^\.DS_Store$/,
        /^Thumbs\.db$/
	].each { |regex|
		return true if regex =~ filename
	}
	false
end


# 
# 获取文件的hash值
# 
def gethash(path) 
    
    if File.exist?(path)
        File.open(path,"r") do |file|
            line = file.gets
            # puts line
            return line
            # while line = file.gets
            #     return line
            # end
       end
    end
end

# 
# 写数据到json文件（用于生成manifest_all.json）
# 
def writeFileToJson(jsonPath,file)
    # puts jsonPath
    # puts file

    if File.exist?(jsonPath)
        # puts "================="
        manifest_all = loadJson(jsonPath)
        # puts manifest_all
        manifest_all << file
        save_json_file(jsonPath,manifest_all)
    else
        puts "*****************"
        data = []
        data << file
        save_json_file(jsonPath,data)
    end


end

#
# 将数据保存到指定的json文件中
#
def save_json_file(filename, data)
	# puts "writing #{filename}"
	File.write(filename, JSON.pretty_generate(data), :encoding => 'utf-8')
end

#
# 从指定目录下读取json数据
#
def loadJson(path)
	JSON.parse(File.read(path, :encoding => 'utf-8'))
end

# 
# 版本记录
# 
def getVersions(car_type)

    path = "../packages/#{car_type}"
    historyPath = path +"/history.json"
    return loadJson(historyPath)
end 




