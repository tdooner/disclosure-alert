require 'mailgun-ruby'
require 'haml'
require 'premailer'

class DisclosureEmailer
  def initialize(date)
    @date = date
  end

  def send_email
    puts '==================================================================='
    puts 'Emailing:'
    puts
    puts "Filings in date range: #{filings_in_date_range.length}"
    puts '==================================================================='
    return if filings_in_date_range.none?

    AlertSubscriber.subscribed.find_each do |subscriber|
      AlertMailer
        .daily_alert(subscriber, @date, filings_in_date_range, notices_in_date_range)
        .deliver_now
    end
  end

  private

  def filings_in_date_range
    Filing.filed_on_date(@date)
  end

  def notices_in_date_range
    Notice.find_by(date: @date)
  end
end
