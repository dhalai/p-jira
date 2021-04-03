namespace :payments do
  task :create_daily_payments => :environment do
    Payments::CreateDailyPayments.new.call
  end
end
