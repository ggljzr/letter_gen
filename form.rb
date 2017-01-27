require 'Qt'
require_relative 'form_field'

class Form < Qt::Frame
	attr_accessor :form_fields

	slots 'reset_form()'

    BUTTON_X_SIZE = 80
    BUTTON_Y_SIZE = 20

	def initialize(form_name = "Default")
		super()
		@form_name = form_name
		@form_fields = {}
		@status_bar = Qt::Label.new(form_name)
		@status_bar.setFont Qt::Font.new "Purisa", 12

		@reset = Qt::PushButton.new(tr("Reset"))
		@reset.setFixedSize(BUTTON_X_SIZE, BUTTON_Y_SIZE)
        connect(@reset, SIGNAL('clicked()'), SLOT('reset_form()'))

        @layout = Qt::VBoxLayout.new
        @layout.addWidget @status_bar
        @layout.addWidget @reset
        self.setFrameStyle(1);
	end

	def reset_form
        @form_fields.each { |key, value| value.reset }
        @status_bar.text = @form_name
        @status_bar.setFont Qt::Font.new "Purisa", 12
    end
    alias reset reset_form

    def validate_form
    	@form_fields.each do |key, value|
    		unless value.validate
    			@status_bar.text = value.error_message
    			@status_bar.setFont Qt::Font.new "Purisa", 9
    			return false
    		end
    	end
    	true
    end
    alias validate validate_form

    def print_form
    	@form_fields.each { |key, value| value.print }
    end

    def to_dict
    	form_dict = {}

    	@form_fields.each { |key, value| form_dict[key] = value.to_s}

    	form_dict
    end
end

class FormSecretary < Form

	def initialize
		super(form_name = "Jednatel")

		@form_fields = {
            :secretary_name => TextField.new("Jméno jednatele"),
            :secretary_street => TextField.new("Ulice"),
            :secretary_city => TextField.new("Město"),
            :secretary_zip => TextField.new("PSČ"),
        }

        @form_fields.each { |key, value| @layout.addWidget(value)}
        setLayout @layout

	end
end

class FormCompany < Form
	def initialize
		super(form_name = "Společnost")

		@form_fields = {
			:company_name => TextField.new("Název společnosti"),
			:company_street => TextField.new("Sídlo společnosti - ulice"),
			:company_city => TextField.new("Sídlo společnosti - město"),
			:company_zip => TextField.new("PSČ společnosti"),
			:company_id => TextField.new("IČO"),
		}

		@form_fields.each { |key, value| @layout.addWidget(value)}
        setLayout @layout
    end
end

class FormGov < Form
	def initialize
		super(form_name = "Úřady")

		@form_fields = {
			:local_office => TextField.new("Územní pracoviště"),
			:finance_address => TextField.new("Sídlo FÚ - ulice"),
			:finance_office => TextField.new("Sídlo FÚ - město"),
			:finance_zip => TextField.new("PSČ FÚ")
		}

		@form_fields.each { |key, value| @layout.addWidget(value)}
        setLayout @layout
	end
end