module Brood
  class Repo
    attr_reader :url, :path, :branch

    def self.default
      new(github: "ndlib/honeycomb-brood")
    end

    def initialize(github:, branch: :master)
      @branch = branch
      set_github_url(github)
    end

    def grow!
      clone_and_pull
      set = Brood::Set.new(path)
      set.grow!
    end

    def clone_and_pull
      clone
      pull
    end

    def clone
      unless File.directory?(path) && File.directory?(File.join(path, ".git"))
        FileUtils.mkdir_p(path)
        `git clone #{Shellwords.escape(url)} #{Shellwords.escape(path)}`
      end
    end

    def checkout_branch
      git_command("checkout #{branch}")
    end

    def pull
      checkout_branch
      git_command("pull")
    end

    def git_command(command)
      `cd #{Shellwords.escape(path)} && git #{command}`
    end

    def set_path(path_segment)
      @path = Rails.root.join("tmp/brood", path_segment)
    end

    def set_github_url(repo_name)
      @url = "https://github.com/#{repo_name}.git"
      set_path(repo_name)
    end
  end
end
