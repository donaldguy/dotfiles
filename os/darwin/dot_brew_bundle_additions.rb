
def brew_from_tap(formula_name, tap_name, **options)
  tap tap_name
  brew "#{tap_name}/#{formula_name}", **options
end

def font(name, **kwargs)
  suffix = 
    if kwargs[:nerd_font]
      "-nerd-font"
    else 
      ""
    end

  cask "font-#{name}#{suffix}"
end

def setapp(app_name)
  ## TODO?: actually use the machinary of https://github.com/Homebrew/homebrew-bundle/blob/master/lib/bundle/checker.rb
  ##  at least; ideally maybe actually install
  unless Dir.exist?("/Applications/Setapp/#{app_name}.app")
    Warning.warn "Setapp application #{app_name} does not appear to be installed\n"
  end
end