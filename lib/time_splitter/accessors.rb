module TimeSplitter
  module Accessors
    def split_accessor(*attrs)
      options = attrs.extract_options!

      # defaults
      options[:date_format] = "%d/%m/%Y" unless options[:date_format]
      options[:time_format] = "%H:%M" unless options[:time_format]

      attrs.each do |attr|

        # Writers
        define_method("#{attr}_on=") do |date|
          return unless date.present?
          begin
            # create a date object from a string or Time onbject if supplied
            date = DateTime.strptime(date, options[:date_format]) if date.is_a?(String) # string to date
            date = date.to_date if date.is_a?(Time) # time to date

            # set the attr_at value to the Date object
            self.send("#{attr}_at=", date)
          rescue ArgumentError
            # invalid date format
          end
        end

        define_method("#{attr}_date=") do |date|
          return if date.nil?

          # grab the date string if a Date or Time object is supplied
          date = date.strftime(options[:date_format]) if date.is_a?(Date) || date.is_a?(Time)

          # store the string value in an instance var.
          instance_variable_set "@#{attr}_date", date

          # attempt to update the Time/Date object from the string values provided
          self.send("update_#{attr}")
        end

        define_method("#{attr}_time=") do |time|
          return if time.nil? || time.is_a?(Date)

          # set the date if supplied
          self.send("#{attr}_date=", time.strftime(options[:date_format])) if time.is_a?(Time)

          # grab the time string if a Time object is supplied
          time = time.strftime(options[:time_format]) if time.is_a?(Time)

          # store the string value in an instance var.
          instance_variable_set "@#{attr}_time", time

          # attempt to update the Time/Date object from the string values provided
          self.send("update_#{attr}")
        end

        # Readers
        define_method("#{attr}_on") do
          self.send("#{attr}_at").try(:to_date)
        end

        define_method("#{attr}_date") do
          date = instance_variable_get("@#{attr}_date")
          date = self.send("#{attr}_at").strftime(options[:date_format]) if date.nil? && self.send("#{attr}_at").present?
          date
        end

        define_method("#{attr}_time") do
          time = instance_variable_get("@#{attr}_time")
          time = self.send("#{attr}_at").strftime(options[:time_format]) if time.nil? && self.send("#{attr}_at").present?
          time
        end

        define_method("update_#{attr}") do
          begin
            date_str = instance_variable_get("@#{attr}_date")
            time_str = instance_variable_get("@#{attr}_time")
            if date_str
              if time_str
                self.send("#{attr}_at=", DateTime.strptime([date_str,time_str].join(" "), [options[:date_format],options[:time_format]].join(" ")))
              else
                self.send("#{attr}_on=", DateTime.strptime(date_str, options[:date_format]))
              end
            end
          rescue ArgumentError
            # invalid date format supplied
          end
        end

      end
    end
  end
end
