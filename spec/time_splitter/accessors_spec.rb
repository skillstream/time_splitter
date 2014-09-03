require 'active_support/all'
require_relative "../../lib/time_splitter/accessors.rb"

describe TimeSplitter::Accessors do
  let(:model) { Model.new }
  before do
    class Model
      extend(TimeSplitter::Accessors)

      attr_accessor :starts_at
      split_accessor(:starts_at)
    end
  end

  describe "split accessor methods" do

    describe "#starts_at" do
      context 'when nil' do
        it "returns nil" do
          expect(model.starts_at).to be_nil
        end

        describe 'when modifying #starts_at_on' do
          it "returns a date when a valid date is supplied" do
            date = Date.new(1970, 1, 1)
            model.starts_at_on = date
            expect(model.starts_at).to eq date
          end

          it "returns a date when a valid datetime is supplied" do
            time = Time.local(1970, 1, 1, 1, 0)
            model.starts_at_on = time
            expect(model.starts_at).to eq time.to_date
          end

          it "returns a date when a valid date string is supplied" do
            date = Date.new(1970, 1, 1)
            model.starts_at_on = date.strftime("%d/%m/%Y")
            expect(model.starts_at).to eq date
          end

          it "returns nil when an invalid date (non existent leap year) is supplied" do
            model.starts_at_on = "29/02/2014" # no leap year in 2014
            expect(model.starts_at).to be_nil
          end

          it "returns nil when an invalid date (non date) is supplied" do
            model.starts_at_on = "foo"
            expect(model.starts_at).to be_nil
          end
        end

        context 'when modifying #starts_at_date' do
          it "returns a date when a valid date is supplied" do
            date = Date.new(1970, 1, 1)
            model.starts_at_date = date
            expect(model.starts_at).to eq date
          end

          it "returns a date when a valid date string is supplied" do
            date = Date.new(1970, 1, 1)
            model.starts_at_date = date.strftime("%d/%m/%Y")
            expect(model.starts_at).to eq date
          end

          it "returns nil when an invalid date (non existent leap year) is supplied" do
            model.starts_at_date = "29/02/2014" # no leap year in 2014
            expect(model.starts_at).to be_nil
          end

          it "returns nil when an invalid date (non date) is supplied" do
            model.starts_at_date = "foo"
            expect(model.starts_at).to be_nil
          end
        end

        context 'when modifying #starts_at_time' do
          it "returns a datetime when a valid time (object) is supplied" do
            time = Time.local(1970, 1, 1, 1, 0)
            model.starts_at_time = time
            expect(model.starts_at).to eq time
          end

          context 'and a valid #start_date is supplied' do
            before { model.starts_at_date = Date.new(1970, 1, 1) }

            it "returns a datetime when a valid time string is supplied" do
              time = Time.local(1970, 1, 1, 1, 0)
              model.starts_at_time = time.strftime("%H:%M")
              expect(model.starts_at).to eq time
            end

            it "returns the date when an invalid time (format) is supplied" do
              model.starts_at_time = "55:55"
              expect(model.starts_at).to eq model.starts_at_on
            end

            it "returns the date (no time) when an invalid time (non time) is supplied" do
              model.starts_at_time = "foo"
              expect(model.starts_at).to eq model.starts_at_on
            end
          end

          context 'and no #start_date is supplied' do
            it "returns nil when a valid time string is supplied" do
              time = Time.local(1970, 1, 1, 1, 0)
              model.starts_at_time = time.strftime("%H:%M")
              expect(model.starts_at).to be_nil
            end

            it "returns nil when an invalid time (format) is supplied" do
              model.starts_at_time = "55:55"
              expect(model.starts_at).to be_nil
            end

            it "returns nil when an invalid date (non date) is supplied" do
              model.starts_at_time = "foo"
              expect(model.starts_at).to be_nil
            end
          end
        end
      end

      context 'when set to a datetime' do
        before { model.starts_at = Time.local(1979, 12, 25, 3, 0) }

        it "returns the datetime" do
          expect(model.starts_at).to eq Time.local(1979, 12, 25, 3, 0)
        end

        describe 'when modifying #starts_at_on' do
          it "returns a date when a valid date is supplied" do
            date = Date.new(1970, 1, 1)
            model.starts_at_on = date
            expect(model.starts_at).to eq date
          end

          it "returns a date when a valid datetime is supplied" do
            time = Time.local(1970, 1, 1, 1, 0)
            model.starts_at_on = time
            expect(model.starts_at).to eq time.to_date
          end

          it "returns a date when a valid date string is supplied" do
            date = Date.new(1970, 1, 1)
            model.starts_at_on = date.strftime("%d/%m/%Y")
            expect(model.starts_at).to eq date
          end

          it "returns the datetime when an invalid date (non existent leap year) is supplied" do
            model.starts_at_on = "29/02/2014" # no leap year in 2014
            expect(model.starts_at).to eq Time.local(1979, 12, 25, 3, 0)
          end

          it "returns nil when an invalid date (non date) is supplied" do
            model.starts_at_on = "foo"
            expect(model.starts_at).to eq Time.local(1979, 12, 25, 3, 0)
          end
        end

        context 'when modifying #starts_at_date' do
          it "returns a date when a valid date is supplied" do
            date = Date.new(1990, 2, 13)
            model.starts_at_date = date
            expect(model.starts_at).to eq date
          end

          it "returns a date when a valid date string is supplied" do
            date = Date.new(1970, 1, 1)
            model.starts_at_date = date.strftime("%d/%m/%Y")
            expect(model.starts_at).to eq date
          end

          it "returns the datetime when an invalid date (non existent leap year) is supplied" do
            model.starts_at_date = "29/02/2014" # no leap year in 2014
            expect(model.starts_at).to eq Time.local(1979, 12, 25, 3, 0)
          end

          it "returns the datetime when an invalid date (non date) is supplied" do
            model.starts_at_date = "foo"
            expect(model.starts_at).to eq Time.local(1979, 12, 25, 3, 0)
          end
        end

        context 'when modifying #starts_at_time' do
          it "returns a datetime when a valid time (object) is supplied" do
            time = Time.local(1971, 2, 2, 4, 30)
            model.starts_at_time = time
            expect(model.starts_at).to eq time
          end

          context 'and a valid #start_date is supplied' do
            before { model.starts_at_date = Date.new(1972, 4, 4) }

            it "returns a datetime when a valid time string is supplied" do
              model.starts_at_time = "01:45"
              expect(model.starts_at).to eq Time.local(1972, 4, 4, 1, 45)
            end

            it "returns the date when an invalid time (format) is supplied" do
              model.starts_at_time = "55:55"
              expect(model.starts_at).to eq model.starts_at_on
            end

            it "returns nil when an invalid date (non date) is supplied" do
              model.starts_at_time = "foo"
              expect(model.starts_at).to eq model.starts_at_on
            end
          end
        end
      end
    end

    describe "#starts_at_on" do
      context 'when nil' do
        it "returns nil" do
          expect(model.starts_at_on).to be_nil
        end

        context 'when modifying #starts_at_date' do
          it "returns a date when a valid date (object) is supplied" do
            date = Date.new(1970, 1, 1)
            model.starts_at_date = date
            expect(model.starts_at_on).to eq date
          end

          it "returns a date when a valid time (object) is supplied" do
            time = Time.local(1970, 1, 2, 3, 45)
            model.starts_at_date = time
            expect(model.starts_at_on).to eq time.to_date
          end

          it "returns a date when a valid date string is supplied" do
            date = Date.new(1970, 1, 1)
            model.starts_at_date = date.strftime("%d/%m/%Y")
            expect(model.starts_at_on).to eq date
          end

          it "returns nil when an invalid date (non existent leap year) is supplied" do
            model.starts_at_date = "29/02/2014" # no leap year in 2014
            expect(model.starts_at_on).to be_nil
          end

          it "returns nil when an invalid date (non date) is supplied" do
            model.starts_at_date = "foo"
            expect(model.starts_at_on).to be_nil
          end
        end

        context 'when modifying #starts_at_time' do
          it "returns a date when a valid time (object) is supplied" do
            time = Time.local(1970, 1, 1, 1, 0)
            model.starts_at_time = time
            expect(model.starts_at_on).to eq time.to_date
          end

          context 'and a valid #start_date is supplied' do
            before { model.starts_at_date = Date.new(1970, 1, 1) }

            it "returns a date when a valid time string is supplied" do
              model.starts_at_time = "09:54"
              expect(model.starts_at_on).to eq Date.new(1970, 1, 1)
            end

            it "returns the date when an invalid time (format) is supplied" do
              model.starts_at_time = "55:55"
              expect(model.starts_at_on).to eq model.starts_at_on
            end

            it "returns the date (no time) when an invalid time (non time) is supplied" do
              model.starts_at_time = "foo"
              expect(model.starts_at_on).to eq model.starts_at_on
            end
          end

          context 'and no #start_date is supplied' do
            it "returns nil when a valid time string is supplied" do
              time = Time.local(1970, 1, 1, 1, 0)
              model.starts_at_time = time.strftime("%H:%M")
              expect(model.starts_at_on).to be_nil
            end

            it "returns nil when an invalid time (format) is supplied" do
              model.starts_at_time = "55:55"
              expect(model.starts_at_on).to be_nil
            end

            it "returns nil when an invalid date (non date) is supplied" do
              model.starts_at_time = "foo"
              expect(model.starts_at_on).to be_nil
            end
          end
        end
      end

      context 'when set to a date' do
        before { model.starts_at_on = Date.new(1975, 3, 4) }

        it "returns the datetime" do
          expect(model.starts_at_on).to eq Date.new(1975, 3, 4)
        end

        context 'when modifying #starts_at_date' do
          it "returns a date when a valid date is supplied" do
            date = Date.new(1976, 4, 5)
            model.starts_at_date = date
            expect(model.starts_at_on).to eq date
          end

          it "returns a date when a valid date string is supplied" do
            date = Date.new(1976, 4, 5)
            model.starts_at_date = date.strftime("%d/%m/%Y")
            expect(model.starts_at_on).to eq date
          end

          it "returns the date when an invalid date (non existent leap year) is supplied" do
            model.starts_at_date = "29/02/2014" # no leap year in 2014
            expect(model.starts_at_on).to eq Date.new(1975, 3, 4)
          end

          it "returns the date when an invalid date (non date) is supplied" do
            model.starts_at_date = "foo"
            expect(model.starts_at).to eq Date.new(1975, 3, 4)
          end
        end

        context 'when modifying #starts_at_time' do
          it "returns the original date when a valid date (object) is supplied" do
            model.starts_at_time = Date.new(1983, 9, 30)
            expect(model.starts_at_on).to eq Date.new(1975, 3, 4)
          end

          context 'and a valid #start_date is supplied' do
            before { model.starts_at_date = Date.new(1983, 11, 16) }

            it "returns a date when a valid time string is supplied" do
              model.starts_at_time = "01:45"
              expect(model.starts_at_on).to eq Date.new(1983, 11, 16)
            end

            it "returns the date when an invalid time (format) is supplied" do
              model.starts_at_time = "55:55"
              expect(model.starts_at_on).to eq Date.new(1983, 11, 16)
            end

            it "returns nil when an invalid date (non date) is supplied" do
              model.starts_at_time = "foo"
              expect(model.starts_at_on).to eq Date.new(1983, 11, 16)
            end
          end
        end
      end
    end

    describe "#starts_at_date" do
      context 'when nil' do
        it "returns nil" do
          expect(model.starts_at_date).to be_nil
        end

        context 'when modifying #starts_at' do
          it "returns a date string when a valid date (object) is supplied" do
            date = Date.new(1982, 6, 7)
            model.starts_at = date
            expect(model.starts_at_date).to eq date.strftime("%d/%m/%Y")
          end

          it "returns a date when a valid time (object) is supplied" do
            time = Time.local(1983, 7, 8, 7, 54)
            model.starts_at = time
            expect(model.starts_at_date).to eq time.strftime("%d/%m/%Y")
          end
        end

        context 'when modifying #starts_at_on' do
          it "returns a date string when a valid date (object) is supplied" do
            date = Date.new(1982, 6, 7)
            model.starts_at_on = date
            expect(model.starts_at_date).to eq date.strftime("%d/%m/%Y")
          end

          it "returns a date when a valid time (object) is supplied" do
            time = Time.local(1983, 7, 8, 7, 54)
            model.starts_at_on = time
            expect(model.starts_at_date).to eq time.strftime("%d/%m/%Y")
          end
        end

        context 'when modifying #starts_at_date' do
          it "returns a date string when a valid date (object) is supplied" do
            date = Date.new(1970, 1, 1)
            model.starts_at_date = date
            expect(model.starts_at_date).to eq date.strftime("%d/%m/%Y")
          end

          it "returns a date string when a valid time (object) is supplied" do
            time = Time.local(1970, 1, 2, 3, 45)
            model.starts_at_date = time
            expect(model.starts_at_date).to eq time.strftime("%d/%m/%Y")
          end

          it "returns a date string when a valid date string is supplied" do
            date = "09/09/2009"
            model.starts_at_date = date
            expect(model.starts_at_date).to eq date
          end

          it "returns the supplied string when an invalid date (non existent leap year) is supplied" do
            invalid_date = "29/02/2014" # no leap year in 2014
            model.starts_at_date = invalid_date
            expect(model.starts_at_date).to eq invalid_date
          end

          it "returns the supplied string when an invalid date (non date) is supplied" do
            invalid_input = "foo"
            model.starts_at_date = invalid_input
            expect(model.starts_at_date).to eq invalid_input
          end

          it "returns an empty string when an empty string is supplied" do
            empty_input = ""
            model.starts_at_date = empty_input
            expect(model.starts_at_date).to eq empty_input
          end
        end

        context 'when modifying #starts_at_time' do
          it "returns nil" do
            model.starts_at_time = "15:53"
            expect(model.starts_at_date).to be_nil
          end
        end
      end

      context 'when set to a value' do
        before { model.starts_at_date = "3/4/2010" }

        it "returns the original value" do
          expect(model.starts_at_date).to eq "3/4/2010"
        end

        context 'when modifying #starts_at' do
          it "returns the original value when a valid date (object) is supplied" do
            model.starts_at = Date.new(1982, 6, 7)
            expect(model.starts_at_date).to eq "3/4/2010"
          end

          it "returns the original value when a valid time (object) is supplied" do
            model.starts_at = Time.local(1983, 7, 8, 7, 54)
            expect(model.starts_at_date).to eq "3/4/2010"
          end
        end

        context 'when modifying #starts_at_on' do
          it "returns the original value when a valid date (object) is supplied" do
            model.starts_at_on = Date.new(1982, 6, 7)
            expect(model.starts_at_date).to eq "3/4/2010"
          end

          it "returns the original value when a valid time (object) is supplied" do
            time = Time.local(1983, 7, 8, 7, 54)
            model.starts_at_on = time
            expect(model.starts_at_date).to eq "3/4/2010"
          end
        end

        context 'when modifying #starts_at_date' do
          it "returns a date string when a valid date (object) is supplied" do
            date = Date.new(1970, 1, 1)
            model.starts_at_date = date
            expect(model.starts_at_date).to eq date.strftime("%d/%m/%Y")
          end

          it "returns a date string when a valid time (object) is supplied" do
            time = Time.local(1970, 1, 2, 3, 45)
            model.starts_at_date = time
            expect(model.starts_at_date).to eq time.strftime("%d/%m/%Y")
          end

          it "returns a date string when a valid date string is supplied" do
            date = "14/05/2012"
            model.starts_at_date = date
            expect(model.starts_at_date).to eq date
          end

          it "returns the supplied string when an invalid date (non existent leap year) is supplied" do
            invalid_date = "29/02/2014" # no leap year in 2014
            model.starts_at_date = invalid_date
            expect(model.starts_at_date).to eq invalid_date
          end

          it "returns the supplied string when an invalid date (non date) is supplied" do
            invalid_input = "foo"
            model.starts_at_date = invalid_input
            expect(model.starts_at_date).to eq invalid_input
          end

          it "returns an empty string when an empty string is supplied" do
            empty_input = ""
            model.starts_at_date = empty_input
            expect(model.starts_at_date).to eq empty_input
          end
        end

        context 'when modifying #starts_at_time' do
          it "returns the original value" do
            model.starts_at_time = "15:53"
            expect(model.starts_at_date).to eq "3/4/2010"
          end
        end
      end
    end

    describe "#starts_at_time" do
      context 'when nil' do
        it "returns nil" do
          expect(model.starts_at_time).to be_nil
        end

        context 'when modifying #starts_at' do
          it "returns the time string of the date supplied when a valid date (object) is supplied" do
            date = Date.new(1992, 5, 19)
            model.starts_at = date
            expect(model.starts_at_time).to eq "00:00"
          end

          it "returns a time string when a valid time (object) is supplied" do
            time = Time.local(1993, 6, 20, 8, 37)
            model.starts_at = time
            expect(model.starts_at_time).to eq time.strftime("%H:%M")
          end
        end

        context 'when modifying #starts_at_on' do
          it "returns the time string of the date supplied when a valid date (object) is supplied" do
            model.starts_at_on = Date.new(1993, 6, 7)
            expect(model.starts_at_time).to eq "00:00"
          end

          it "returns the time string of the date supplied when a valid time (object) is supplied" do
            model.starts_at_on = Time.local(1993, 12, 14, 15, 16)
            expect(model.starts_at_time).to eq "00:00"
          end
        end

        context 'when modifying #starts_at_date' do
          it "returns the time string of the date supplied when a valid date (object) is supplied" do
            model.starts_at_date = Date.new(1970, 1, 1)
            expect(model.starts_at_time).to eq "00:00"
          end

          it "returns the time string of the date supplied when a valid time (object) is supplied" do
            model.starts_at_date = Time.local(1970, 1, 2, 3, 45)
            expect(model.starts_at_time).to eq "00:00"
          end

          it "returns the time string of the date supplied when a valid date string is supplied" do
            model.starts_at_date = "09/09/2009"
            expect(model.starts_at_time).to eq "00:00"
          end

          it "returns nil when an invalid date (non existent leap year) is supplied" do
            model.starts_at_date = "29/02/2014" # no leap year in 2014
            expect(model.starts_at_time).to be_nil
          end

          it "returns nil when an invalid date (non date) is supplied" do
            model.starts_at_date = "foo"
            expect(model.starts_at_time).to be_nil
          end

          it "returns nil when an empty string is supplied" do
            model.starts_at_date = ""
            expect(model.starts_at_time).to be_nil
          end
        end

        context 'when modifying #starts_at_time' do
          it "returns nil when a valid date (object) is supplied" do
            model.starts_at_time = Date.new(1970, 1, 1)
            expect(model.starts_at_time).to be_nil
          end

          it "returns a time string when a valid time (object) is supplied" do
            time = Time.local(1970, 1, 2, 3, 45)
            model.starts_at_time = time
            expect(model.starts_at_time).to eq time.strftime("%H:%M")
          end

          it "returns the string supplied when a valid date string is supplied" do
            date = "09/09/2009"
            model.starts_at_time = "09/09/2009"
            expect(model.starts_at_time).to eq "09/09/2009"
          end

          it "returns the string supplied when an invalid date (non existent leap year) is supplied" do
            invalid_date = "29/02/2014" # no leap year in 2014
            model.starts_at_time = invalid_date
            expect(model.starts_at_time).to eq invalid_date
          end

          it "returns the string supplied when an invalid date (non date) is supplied" do
            invalid_date = "foo"
            model.starts_at_time = invalid_date
            expect(model.starts_at_time).to eq invalid_date
          end

          it "returns an empty string when an empty string is supplied" do
            empty_input = ""
            model.starts_at_time = empty_input
            expect(model.starts_at_time).to eq empty_input
          end

          it "returns a time string when a valid time string is supplied" do
            time = "01:45"
            model.starts_at_time = time
            expect(model.starts_at_time).to eq time
          end

          it "returns the time supplied when an invalid time (format) is supplied" do
            invalid_time = "55:55"
            model.starts_at_time = invalid_time
            expect(model.starts_at_time).to eq invalid_time
          end
        end
      end

      context 'when set to a value' do
        before { model.starts_at_time = "05:05" }

        it "returns the original value" do
          expect(model.starts_at_time).to eq "05:05"
        end

        context 'when modifying #starts_at' do
          it "returns the original value when a valid date (object) is supplied" do
            model.starts_at = Date.new(1982, 6, 7)
            expect(model.starts_at_time).to eq "05:05"
          end

          it "returns the original value when a valid time (object) is supplied" do
            model.starts_at = Time.local(1983, 7, 8, 7, 54)
            expect(model.starts_at_time).to eq "05:05"
          end
        end

        context 'when modifying #starts_at_on' do
          it "returns the original value when a valid date (object) is supplied" do
            model.starts_at_on = Date.new(1982, 6, 7)
            expect(model.starts_at_time).to eq "05:05"
          end

          it "returns the original value when a valid time (object) is supplied" do
            time = Time.local(1983, 7, 8, 7, 54)
            model.starts_at_on = time
            expect(model.starts_at_time).to eq "05:05"
          end
        end

        context 'when modifying #starts_at_date' do
          it "returns the original value when a valid date (object) is supplied" do
            model.starts_at_date = Date.new(1970, 1, 1)
            expect(model.starts_at_time).to eq "05:05"
          end

          it "returns the original value when a valid time (object) is supplied" do
            model.starts_at_date = Time.local(1970, 1, 2, 3, 45)
            expect(model.starts_at_time).to eq "05:05"
          end

          it "returns the original value when a valid date string is supplied" do
            model.starts_at_date = "14/05/2012"
            expect(model.starts_at_time).to eq "05:05"
          end

          it "returns the original value when an invalid date (non existent leap year) is supplied" do
            model.starts_at_date = "29/02/2014" # no leap year in 2014
            expect(model.starts_at_time).to eq "05:05"
          end

          it "returns the original value when an invalid date (non date) is supplied" do
            model.starts_at_date = "foo"
            expect(model.starts_at_time).to eq "05:05"
          end

          it "returns the original value when an empty string is supplied" do
            model.starts_at_date = ""
            expect(model.starts_at_time).to eq "05:05"
          end
        end

        context 'when modifying #starts_at_time' do
          it "returns nil when a valid date (object) is supplied" do
            model.starts_at_time = Date.new(1970, 1, 1)
            expect(model.starts_at_time).to eq "05:05"
          end

          it "returns a time string when a valid time (object) is supplied" do
            time = Time.local(1970, 1, 2, 3, 45)
            model.starts_at_time = time
            expect(model.starts_at_time).to eq time.strftime("%H:%M")
          end

          it "returns the string supplied when a valid date string is supplied" do
            date = "09/09/2009"
            model.starts_at_time = "09/09/2009"
            expect(model.starts_at_time).to eq "09/09/2009"
          end

          it "returns the string supplied when an invalid date (non existent leap year) is supplied" do
            invalid_date = "29/02/2014" # no leap year in 2014
            model.starts_at_time = invalid_date
            expect(model.starts_at_time).to eq invalid_date
          end

          it "returns the string supplied when an invalid date (non date) is supplied" do
            invalid_date = "foo"
            model.starts_at_time = invalid_date
            expect(model.starts_at_time).to eq invalid_date
          end

          it "returns an empty string when an empty string is supplied" do
            empty_input = ""
            model.starts_at_time = empty_input
            expect(model.starts_at_time).to eq empty_input
          end

          it "returns a time string when a valid time string is supplied" do
            time = "01:45"
            model.starts_at_time = time
            expect(model.starts_at_time).to eq time
          end

          it "returns the time supplied when an invalid time (format) is supplied" do
            invalid_time = "55:55"
            model.starts_at_time = invalid_time
            expect(model.starts_at_time).to eq invalid_time
          end
        end
      end
    end
  end
end
