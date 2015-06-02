class ForumParser
  
  attr_writer :url
  
  def initialize(driver, url)
    @driver = driver
    @url = url
    @page = nil
    open_page
  end
  
  def open_page
    opened = false
    begin
      #puts "[Opening #{@url}...]"
      @driver.get @url
      sleep rand(5..7)
      @page = Nokogiri::HTML(@driver.page_source)
      opened = true
    rescue Exception => e
      puts "--- ERROR: #{e.message}"
    end
    opened
  end
    
  def subforum_name
    @page.xpath('//*[@id="spark"]/div/div[2]/div/div[1]/h2').text
  end
  
  def thread_list
    @page.xpath('//*[@id="spark"]/div/div[5]/div/div/table/tbody/tr')
  end
  
  def staff_replied
    @page.xpath('//*[@id="spark"]/div/div[5]/div/div/table/tbody/tr' \
                '/td[1]/div[2]/span[@class="course-forum-profile-badge"]')
  end
  
  def tot_pages
    @page.xpath('//*[@id="spark"]/div/div[5]/div/div/div/ul/li').count
  end
  
  def next_page(current_page)
    if more_pages?
      next_one = current_page + 1
      number = @page.xpath("//*[@id=\"spark\"]/div/div[5]/div/div/div/ul/li[#{next_one}]/a").text.to_i
    end
  end
  
  def more_pages?
    pages = @page.xpath('//*[@id="spark"]/div/div[5]/div/div/div/ul/li/a').last
    if !pages.nil?
      pages.text.include?('Next')
    else
      false
    end
  end
  
end
