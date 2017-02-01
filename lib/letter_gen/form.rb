require 'Qt'
require_relative 'form_field'

# Basic Form class
class Form < Qt::Frame
  attr_accessor :form_fields

  slots 'reset_form()'

  BUTTON_X_SIZE = 80
  BUTTON_Y_SIZE = 20

  def initialize(form_name = 'Default')
    super()
    @form_name = form_name
    @form_fields = {}
    @status_bar = Qt::Label.new(form_name)
    @status_bar.setFont Qt::Font.new(@status_bar.font.family, 12)

    @reset = Qt::PushButton.new(tr('Reset'))
    @reset.setFixedSize(BUTTON_X_SIZE, BUTTON_Y_SIZE)
    connect(@reset, SIGNAL('clicked()'), SLOT('reset_form()'))

    @layout = Qt::VBoxLayout.new
    @layout.addWidget @status_bar
    @layout.addWidget @reset
    setFrameStyle(1)
  end

  def reset_form
    @form_fields.each_value(&:reset)
    @status_bar.text = @form_name
    @status_bar.setFont Qt::Font.new(@status_bar.font.family, 12)
  end
  alias reset reset_form

  def validate_form
    @form_fields.each_value do |value|
      unless value.validate
        @status_bar.text = value.error_message
        @status_bar.setFont Qt::Font.new(@status_bar.font.family, 9)
        return false
      end
    end
    true
  end
  alias validate validate_form

  def print_form
    @form_fields.each_value(&:print)
  end

  def to_dict
    form_dict = {}

    @form_fields.each { |key, value| form_dict[key] = value.to_s }

    form_dict
  end
end

# Company's secretary information
class FormSecretary < Form
  def initialize
    super('Jednatel')

    @form_fields = {
      secretary_name: TextField.new('Jméno jednatele'),
      secretary_street: TextField.new('Ulice'),
      secretary_city: TextField.new('Město'),
      secretary_zip: TextField.new('PSČ')
    }

    @form_fields.each_value { |value| @layout.addWidget(value) }
    setLayout @layout
  end
end

# Company information
class FormCompany < Form
  def initialize
    super('Společnost')

    @form_fields = {
      company_name: TextField.new('Název společnosti'),
      company_street: TextField.new('Sídlo společnosti - ulice'),
      company_city: TextField.new('Sídlo společnosti - město'),
      company_zip: TextField.new('PSČ společnosti'),
      company_id: TextField.new('IČO')
    }

    @form_fields.each_value { |value| @layout.addWidget(value) }
    setLayout @layout
  end
end

# Finance bureau information
class FormGov < Form
  def initialize
    super('Úřady')

    @form_fields = {
      local_office: TextField.new('Územní pracoviště'),
      finance_address: TextField.new('Sídlo FÚ - ulice'),
      finance_office: TextField.new('Sídlo FÚ - město'),
      finance_zip: TextField.new('PSČ FÚ')
    }

    @form_fields.each_value { |value| @layout.addWidget(value) }
    setLayout @layout
  end
end
