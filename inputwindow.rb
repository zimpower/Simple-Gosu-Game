require 'gosu'
require './textinput'

class NameInput < Gosu::Window
  def initialize
    super(640, 480,false)
    self.caption = "Text Your Name"
    font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    # Set up one text field
    @text_field =  TextField.new(self, font, 50, 30 + index * 50)

    @cursor = Gosu::Image.new(self, "media/Cursor.png", false) 
  end

  def needs_cursor?
    true
  end

  def draw
    @text_field.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape || id == Gosu::KbEnter then
      # Escape key will not be 'eaten' by text fields; use for deselecting.
      if self.text_input then
        self.text_input = nil
      else
        close
      end
    elsif id == Gosu::MsLeft then
      # Mouse click: Select text field based on mouse position.
      self.text_input = @text_field.under_point?(mouse_x, mouse_y)
      # Advanced: Move caret to clicked position
      self.text_input.move_caret(mouse_x) unless self.text_input.nil?
    end
  end
end
