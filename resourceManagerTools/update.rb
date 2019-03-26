# 素材处理，将更新的文件打包
# Author:    dudehan
# Date:  2018-09-17

require "fileutils"
require 'os'    # gem install os
require_relative 'support'

def createUpdatePackage(code,version)

    path = "../package/#{code}"
    historyPath = path +"/history.json"
    versions = loadJson(historyPath)

    newVersion = ""
    lastVersion = ""

    if versions.size > 1

        preVersion = versions[versions.size - 2]
        curVersion = versions[versions.size - 1]
        #旧版本不再做更新包
        if curVersion != version    
            return
        end

        manifest_path_pre = path + "/#{preVersion}/manifest.json"
        manifest_path_cur = path + "/#{curVersion}/manifest.json"

        manifest_pre = loadJson(manifest_path_pre)
        manifest_cur = loadJson(manifest_path_cur)

        allFiles_pre = manifest_pre["addFiles"]
        allFiles_cur = manifest_cur["addFiles"]

        manifest_add = allFiles_cur - (allFiles_pre & allFiles_cur)
        manifest_delete = allFiles_pre - (allFiles_pre & allFiles_cur)
        manifest_modify = []

        manifest_public = allFiles_cur - manifest_add - manifest_delete

        manifest_public.each do |filename| 
            oldFilePath = "#{path}/#{preVersion}/#{filename}.hash" 
            curFilePath = "#{path}/#{curVersion}/#{filename}.hash" 

            old_hash = gethash(oldFilePath)
            new_hash = gethash(curFilePath)
            if old_hash != new_hash
                # puts filename
                manifest_modify << filename
            end
        end

        data_diff = []
        # data_diff = allFiles_cur - manifest_public
        # manifest_diff_handle(data_diff,code,preVersion,curVersion)
        data_diff = manifest_add + manifest_modify
        manifest_diff_handle(data_diff,code,preVersion,curVersion)
        
        #生成manifest.json
        files_manifest = {}
        files_manifest["rootPath"] = "/"
        files_manifest["addFiles"] = manifest_add;
        files_manifest["deleteFiles"] = manifest_delete;
        files_manifest["modifyFiles"] = manifest_modify;

        savepath = "#{path}/#{curVersion}_#{preVersion}/manifest.josn"
        save_json_file(savepath,files_manifest)

    end
end


def manifest_diff_handle(data,code,preVersion,lastVersion)

    data.each { |file|
        # file_lastPath = file
        file_path = "../package/#{code}/#{lastVersion}/#{file}"
        filename = File.basename(file_path)

        filePath_new = "../package/#{code}/#{lastVersion}_#{preVersion}/"+file
        file_dir = File.dirname(filePath_new)

        if File.exist?(file_dir)
            # 复制文件到新目录下
            FileUtils.cp file_path,filePath_new
        else
            # 创建文件夹再复制文件
            if OS.windows?
                cmd = "mkdir #{file_dir.gsub('/', '\\')}"
            else    
                cmd = "mkdir -p #{file_dir}"
            end
            puts cmd
            `#{cmd}`
            # 复制文件到新目录下
            FileUtils.cp file_path,filePath_new
        end
    }
    
end

code = ARGV[0]
version = ARGV[1]
createUpdatePackage code, version
