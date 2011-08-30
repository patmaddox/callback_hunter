class CallbackHunterGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.template "controller", "app/controllers/#{plural_name}_controller.rb"
      m.directory "app/views/#{plural_name}"
      m.template "index", "app/views/#{plural_name}/index.html.erb"
      m.template "show", "app/views/#{plural_name}/show.html.erb"
    end
  end
end
