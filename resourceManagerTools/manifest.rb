
#生成manifest.json文件
#Author:    dudehan
#Date:  2018-09-17
 
require_relative 'support'
require 'find'



def manifest_generate (code,version) 
  files_manifest = {}
  addFiles = []
  deleteFiles = []
  modifyFiles = []

  # manifest_all = []
  # files_hash = []

  rootpath = "../package"
  packagePath = rootpath + "/#{code}/#{version}"
  Find.find(packagePath) do |path|

    if File.directory?(path)
      # puts path
    else
      if excluded_file?(File.basename(path)) 
        # puts path
      else
        temPath = path.gsub("#{packagePath}/","")
        addFiles << temPath
    
        # manifest_all << temPath
        # file = {}
        # file["path"] = temPath
        # file["hash"] = gethash("#{path}.hash")
        # files_hash << file

      end
    end
  end 

  files_manifest["rootPath"] = "/"
  files_manifest["addFiles"] = addFiles;
  files_manifest["deleteFiles"] = deleteFiles;
  files_manifest["modifyFiles"] = modifyFiles;

  # puts files

  jsonPath = packagePath + "/manifest.json"
  save_json_file(jsonPath,files_manifest)

  # manifest_hash_path = packagePath + "/manifest_hash.json"
  # save_json_file(manifest_hash_path,files_hash)

  # manifest_all_path = packagePath + "/manifest_all.json"
  # save_json_file(manifest_all_path,manifest_all)
  
end

code = ARGV[0]
version = ARGV[1]

manifest_generate code, version



