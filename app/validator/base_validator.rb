# frozen_string_literal: true

module BaseValidator
  def self.included(base)
    base.extend(ClassMethods)

    base.define_singleton_method(:included) do |klass|
      klass.extend(ClassMethods)

      klass.instance_variable_set(
        :@validations,
        base.instance_variable_get(:@validations)&.dup || []
      )
      klass.instance_variable_set(
        :@custom_validations,
        base.instance_variable_get(:@custom_validations)&.dup || []
      )
    end
  end

  def validate!
    self.class.validate_attributes(self)
    self.class.run_custom_validations(self)
  end

  module ClassMethods
    def validate(method_name)
      @custom_validations ||= []
      @custom_validations << method_name
    end

    def validates(*attributes, **options)
      @validations ||= []

      attributes.each do |attribute|
        @validations << { attribute: attribute, options: options }
      end
    end

    def validate_attributes(instance)
      @validations&.each do |validation|
        attribute = validation[:attribute]
        options = validation[:options]
        value = instance.send(attribute)

        validate_attribute(instance, attribute, value, options)
      end
    end

    def run_custom_validations(instance)
      @custom_validations&.each do |method_name|
        instance.send(method_name)
      end
    end

    private

    def validate_attribute(instance, attribute, value, options)
      # Handle presence validation
      if options[:presence] && (value.nil? || value.to_s.strip.empty?)
        raise ArgumentError, "#{attribute.capitalize} cannot be blank"
      end

      # Handle numericality validation
      validate_numericality(instance, attribute, value, options[:numericality]) if options[:numericality]

      return unless options[:value_in]

      validate_value_in(instance, attribute, value, options)
    end

    def validate_numericality(_instance, attribute, value, options)
      raise ArgumentError, "#{attribute.capitalize} must be an integer" unless value.match?(/\A-?\d+\z/)

      numeric_value = value.to_i

      # Check greater_than constraint
      if options[:greater_than] && (numeric_value <= options[:greater_than])
        raise ArgumentError, "#{attribute.capitalize} must be greater than #{options[:greater_than]}"
      end

      # Check greater_than_or_equal_to constraint
      if options[:greater_than_or_equal_to] && (numeric_value < options[:greater_than_or_equal_to])
        raise ArgumentError,
              "#{attribute.capitalize} must be greater than or equal to #{options[:greater_than_or_equal_to]}"
      end

      # Check only_integer constraint
      return unless options[:only_integer] && !numeric_value.is_a?(Integer)

      raise ArgumentError, "#{attribute.capitalize} must be an integer"
    end

    def validate_value_in(_instance, attribute, value, options)
      raise ArgumentError, "#{attribute.capitalize} cannot be blank" if options[:in].include?(value)
    end
  end
end
