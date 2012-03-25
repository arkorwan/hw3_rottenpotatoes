# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    s_movie = Hash[movie.map{|k,v| [k.intern, v]}]
    Movie.create!(s_movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  titles = page.all(:xpath, "//table[@id='movies']/tbody/tr/td[1]").map{|movie| movie.text}
  assert titles.index(e2.strip) > titles.index(e1.strip)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(',')
  if uncheck
    ratings.each{|rating| uncheck "ratings_#{rating.strip}" }
  else
    ratings.each{|rating| check "ratings_#{rating.strip}" }
  end
end

When /I submit ratings/ do
  click_button "ratings_submit" 
end

When /I sort movies by (.*)/ do |sort_by|
  click_link "#{sort_by}_header"
end

Then /I should( not)? see the following movies: (.*)/ do |hide, movie_list|
  titles = page.all(:xpath, "//table[@id='movies']/tbody/tr/td[1]").map{|movie| movie.text}
  movies = movie_list.split(',')
  if hide
    movies.each{|movie| assert !titles.include?(movie.strip)}
  else
    movies.each{|movie| assert titles.include?(movie.strip)}
  end
end

Then /I should see all of the movies/ do
  titles_from_db = Movie.all.map{|movie| movie[:title]}.sort
  titles_from_page = page.all(:xpath, "//table[@id='movies']/tbody/tr/td[1]").map{|movie| movie.text}.sort  
  assert_equal titles_from_db, titles_from_page
end

Then /I should not see any movies/ do
  movies = page.all(:xpath, "//table[@id='movies']/tbody/tr")
  assert movies.empty?
end

Then /the director of "(.*)" should be "(.+)"/ do |movie_title, movie_director|
  director = Movie.find_by_title(movie_title).director
  assert_equal movie_director, director
end
