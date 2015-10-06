# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

module Seeder

  extend self

  def run
    puts "\n"
    puts '  ***********************'
    puts '  *                     *'
    puts '  *   Database Seeder   *'
    puts '  *                     *'
    puts '  ***********************'
    puts "\n"
    puts "WARNING: this will clear the database!" 

    print "Continue (Y/N) > "

    return if not STDIN.gets =~ /\s*y/i

    puts "clearing DB"
    User.destroy_all

    puts "done."
    report_db
  end

  def report_db
    models = [ User ]

    models.each do |m|
      puts "  #{m.table_name}: #{m.count}"
    end
  end

  def user
    return @user if @user

    @user = User.where( email: 'user@example.com' ).first

    @user ||= User.new do |u|
      u.email = 'user@example.com'
      u.password = 'password'
      u.password_confirmation = 'password'
      u.save!
    end
    
  end

end


Seeder.run
