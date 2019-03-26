


require_relative 'support'

def history_versions(code) 

    path = "../package/#{code}"
    versions = []
    Dir.foreach(path) { |filename|
        next if excluded_file?(filename)
        if (/^\d+\.\d+\.\d+$/ =~ filename)
            puts filename
            versions << filename
        end
    }
    
    sortedVersions = sortVersion(versions)
    savePath = path + "/history.json"
    puts savePath
    save_json_file(savePath,sortedVersions);

end

def sortVersion(versions) 
    if versions.length < 2
       return versions 
    end

    count = versions.length-1
    for i in 0..count
        j = 0
        while j < versions.length-1-i do
            
            if compareVersion(versions[j],versions[j+1])
                temp = versions[j]
                versions[j] = versions[j+1]
                versions[j+1] = temp
                
            end
            j = j+1
         end
    end
    puts versions
    return versions
end

def compareVersion(version_1,version_2) 

    array_version_1 = version_1.split('.')
    array_version_2 = version_2.split('.')

    for i in 0..2
        a = array_version_1[i].to_i
        b = array_version_2[i].to_i
        if a != b
            return a > b ? true:false
        end
     end
    return false
end

# vvvv = ['1.3.1','1.1.11','1.1.10','1.1.1','1.1.12','1.1.2','4.2.4','5.3.2']
# sortVersion(vvvv)
# compareVersion('1.4.2','1.9.5')
code = ARGV[0]
history_versions code