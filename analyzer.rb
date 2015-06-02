require 'nokogiri'
require 'selenium-webdriver'
require_relative 'subforum'

class Analyzer
  
  def initialize(sub_forums)
    @sub_forums = sub_forums #list
    @current_subforum = 0
    @session_shortname = extract_session
    @retrieved_subforums = []
    init_selenium
  end
  
  def init_selenium
    profile = Selenium::WebDriver::Firefox::Profile.from_name 'default'
    @driver = Selenium::WebDriver.for :firefox, :profile => profile
  end
  
  
  def extract_session
    @sub_forums[0].scan(/^(.*:)\/\/([A-Za-z0-9\-\.]+)(:[0-9]+)?(.*)$/)[0][3].split('/')[1]
    rescue Exception => e
      puts "--- ERROR: #{e.message} (Invalid link?)"
      raise e
  end
  
  def extract_forum_id
    @sub_forums[@current_subforum].scan(/^(.*:)\/\/([A-Za-z0-9\-\.]+)(:[0-9]+)?(.*)$/)[0][3]
                                  .split('/')[3].split('=')[1].to_i
    rescue Exception => e
      puts "--- ERROR: #{e.message} (Invalid link?)"
      raise e
  end
  
  def next_subforum
    forum_id = extract_forum_id
    new_subforum = Subforum.new(@driver, @sub_forums[@current_subforum], @session_shortname, forum_id)
    new_subforum.analyze if new_subforum
    @current_subforum += 1
    new_subforum
  end
  
  def work
    puts "Running analyzer..."
    puts
    @sub_forums.size.times {
      @retrieved_subforums << next_subforum # Might contain falses.
    }
  end
  
  def stats
    d = Time.now.utc
    puts
    puts "--------------------------------------------------------------------"
    puts " Forum Stats @ #{d}:"
    puts
    threads = 0
    staff_replied = 0
    @retrieved_subforums.each { |subforum|
      threads += subforum.threads
      staff_replied += subforum.staff_replied
      puts "> Sub-forum \"#{subforum.name}\" has #{subforum.threads} threads, " \
            "#{subforum.staff_replied} staff-replied (#{subforum.replies_percentage}%)" unless subforum == false
    }
    coverage = (staff_replied.to_f / threads.to_f * 100).ceil

    puts
    puts " Total: #{threads} threads, #{staff_replied} staff-replied (#{coverage}% coverage)"
    puts "--------------------------------------------------------------------"
    puts
  end
  
end

SUB_FORUMS = 
 ['https://class.coursera.org/design-006/forum/list?forum_id=10015',
  'https://class.coursera.org/design-006/forum/list?forum_id=10016',
  'https://class.coursera.org/design-006/forum/list?forum_id=10017',
  'https://class.coursera.org/design-006/forum/list?forum_id=10018',
  'https://class.coursera.org/design-006/forum/list?forum_id=10019',
  'https://class.coursera.org/design-006/forum/list?forum_id=10020',
  'https://class.coursera.org/design-006/forum/list?forum_id=10021',
  'https://class.coursera.org/design-006/forum/list?forum_id=10023',
  'https://class.coursera.org/design-006/forum/list?forum_id=10024',
  'https://class.coursera.org/design-006/forum/list?forum_id=10026',
  'https://class.coursera.org/design-006/forum/list?forum_id=10027']
  
analyzer = Analyzer.new(SUB_FORUMS)
analyzer.work
analyzer.stats