require_relative 'forum_parser'

class Subforum
  
  attr_reader :name
  attr_reader :threads
  attr_reader :staff_replied
  attr_reader :replies_percentage
  
  def initialize(driver, url, session_shortname, forum_id)
    @parser = ForumParser.new(driver, url)
    @page = 1
    @name = nil
    @threads = 0
    @staff_replied = 0
    @replies_percentage = 0
    @session_shortname = session_shortname
    @forum_id = forum_id
    parser_ok?
  end
  
  def parser_ok?
    @parser ? true : false  # Parsing somehow failed.
  end
  
  def analyze
    begin
      @name = get_name
      puts "[Analizing #{@name}...]"
      loop do
        @threads += count_threads
        @staff_replied += count_staff_replied
        @replies_percentage = compute_replies_percentage
        #puts "Subforum \"#{@name}\", page #{@page}: #{@threads} threads, " \
        #     "#{@staff_replied} staff-replied [#{@replies_percentage}%]" if parser_ok?
        break if !next_page
      end
    rescue Exception => e
      puts "--- ERROR: #{e.message} (Are you logged in?)"
      raise e
    end
    #puts
  end
  
  def get_name
    @parser.subforum_name
  end
  
  def next_page
    more = false
    page_num = @parser.next_page(@page)
    if !page_num.nil?
      next_url = "https://class.coursera.org/#{@session_shortname}/forum/list?" \
                 "forum_id=#{@forum_id}#forum-threads-all-#{@forum_id}-state-page_num=#{page_num}"
      @parser.url = next_url
      @parser.open_page
      @page += 1
      more = true
    end
    more
  end
  
  def count_threads
    @parser.thread_list.count
  end
  
  def count_staff_replied
    @parser.staff_replied.count
  end
  
  def ended
    @parser.more_pages?
  end
  
  def compute_replies_percentage
    (@staff_replied.to_f / @threads.to_f * 100).ceil
  end
  
end
