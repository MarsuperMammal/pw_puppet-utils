require 'puppet'
require 'rugged'
require 'fileutils'
require 'json'
require 'erb'

@config = YAML.load_file("../conf/config.yml")

module PwPuppet
  class Wrapper

    attr_accessor :author, :author_email, :base_path, :skel_path

    def dir(@module_name="testdir")
      moduledir = @config["git"]["workspace"]+@module_name
      FileUtils.mkdir(moduledir)
    end

    def skelurl
      provider = @config["git"]["provider"]
      if provider == 'GitHub'
        if protocol == 'ssh'
          @skeluri = "git@github.com:"+@config["git"]["handle"]+"/pw_puppet_generate_skeleton.git"
        elseif protocol == 'https'
          if @config["git"]["private"] == true
            if @config["git"]["oath"].nil?
              @skeluri = "https://"+@config["git"]["handle"]+":"+@config["git"]["password"]+"@github.com/"+@config["git"]["handle"]+"/pw_puppet_generate_skeleton.git"
            else
              @skeluri = "https://"+@config["git"]["oath"]+":x-oauth-basic"+"@github.com:"+@config["git"]["handle"]+"/pw_puppet_generate_skeleton.git"
          elseif
            @skeluri = "https://github.com/"+@config["git"]["handle"]+"/pw_puppet_generate_skeleton.git"
            end
          end
        end
      end
    end

    def clone
      skeldir = @config["puppet"]["skeldir"]
      Rugged::Repository.clone_at(@skeluri, skeldir)
    end

    def template_binding
      binding
    end

  end
  params_file = File.open(@config["git"]["workspace"]+@module_name+"/manifests/params.pp")
  template = File.read("../templates/params.pp.erb")
  params = Wrapper.new
  params.author = @config["git"]["author"]
  params.author_email = @config["git"]["email"]
  params.moduledir = @config["git"]["workspace"]+@module_name
  params.skel_path = @config["puppet"]["skelpath"]
  params_file << ERB.new(template).result(Wrapper.template_binding)
  params_file.close
end
