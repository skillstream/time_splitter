module TimeSplitter
  module Accessors
    def split_accessor(*attrs)
      opts = { format: "%F" }.merge!(attrs.extract_options!)

      attrs.each do |attr|
        attr_accessible "#{attr}_date",
                        "#{attr}_time",
                        "#{attr}_hour",
                        "#{attr}_min" if defined?(ActiveModel::MassAssignmentSecurity)

        # Maps the setter for #{attr}_time to accept multipart-parameters for Time
        composed_of "#{attr}_time".to_sym, class_name: 'DateTime' if self.respond_to?(:composed_of)

        define_method("#{attr}_or_new") do
          self.send(attr) || Time.new(0)
        end

        define_method("#{attr}_date=") do |date|
          return unless date.present?
          date = Date.parse(date.to_s)
          self.send("#{attr}=", self.send("#{attr}_or_new").change(year: date.year, month: date.month, day: date.day))
        end

        define_method("#{attr}_hour=") do |hour|
          return unless hour.present?
          self.send("#{attr}=", self.send("#{attr}_or_new").change(hour: hour, min: self.send("#{attr}_or_new").min))
        end

        define_method("#{attr}_min=") do |min|
          return unless min.present?
          self.send("#{attr}=", self.send("#{attr}_or_new").change(min: min))
        end

        define_method("#{attr}_time=") do |time|
          return unless time.present?
          time = Time.parse(time) unless time.is_a?(Date) || time.is_a?(Time)
          self.send("#{attr}=", self.send("#{attr}_or_new").change(hour: time.hour, min: time.min))
        end

        # Readers
        define_method("#{attr}_date") do
          self.send(attr).try :strftime, opts[:format]
        end

        define_method("#{attr}_hour") do
          self.send(attr).try :hour
        end

        define_method("#{attr}_min") do
          self.send(attr).try :min
        end

        define_method("#{attr}_time") do
          self.send(attr).try :to_time
        end
      end
    end
  end
end
