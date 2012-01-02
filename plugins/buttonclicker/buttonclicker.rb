
# Just a vanilla GUI-plugin class:
class ButtonClicker < GUIPlugin
  
  # appends the text into the results value
  def append_result( msg, result_text )
    value = get_ses( msg, :results )
    old_data = value.data
    new_data = old_data + "\n------\n" + result_text
    value.set( msg, new_data )
  end

  def script_button_handler( msg, value, script_path, script_args=[] )
    button_state = value.data
    if button_state == 1 # button has been clicked
      # expand the path relative to whatever the location of this plugin bundle is:
      abs_path = bundle_path( script_path )
      if not File.exists?( abs_path )
        result = "Doesn't exist: #{abs_path}"
      elsif not File.file?( abs_path )
        result = "Not a file: #{abs_path}"
      elsif not File.readable?( abs_path )
        result = "Not readable: #{abs_path}"
      elsif not File.executable?( abs_path )
        result = "Not executable: #{abs_path}"
      else
        # join the arguments with space as the delimitter:
        args = script_args.join(' ')
        # run the script and append its standard output to the results value:
        result = `#{abs_path} #{args}`
      end
      append_result( msg, result )
    end
    value.set( msg, 0 ) # reset the button's value to 0
    true # return true to prevent a retry until true
  end

  # Wrappers to differentiate the different button values (see values.yaml):
  def button1_responder( msg, value )
    script_button_handler( msg, value, 'bin/foo1.sh' )
  end
  def button2_responder( msg, value )
    script_button_handler( msg, value, 'bin/foo2.sh' )
  end

  # Just returns the value of 'uname -a'
  def get_uname
    `uname -a`
  end
end
