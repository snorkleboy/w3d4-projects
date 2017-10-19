def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
  Movie.select(:title, 'movies.id')
  .joins(:actors)
  .where('actors.name in (?)', those_actors)
  .group(movies: {id})
  .having('count(actors.id)= ?', those_actors.length)
end

def golden_age
  # Find the decade with the highest average movie score.

  Movie.select('yr / 10', 'avg(score)')
  .group('yr / 10')
  .order('avg(score) desc')
  .limit(1)
  .pluck('yr / 10').first.to_i * 10

end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery
  a=Movie.select(:id)
  .joins(:actors)
  .where('actors.name=?',name)

  Actor.select(:name)
  .joins(:movies)
  .where('movies.id in (?)', a).where.not('actors.name = ?', name)
  .distinct
  .pluck(:name)
end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie

  Actor.select('count(actors.name) as count')
  .joins('LEFT OUTER JOIN castings on castings.actor_id=actors.id')
  .where('castings.movie_id is NULL')
  .pluck('count(actors.name)').first


end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"
  whazz='%'+whazzername.split(' ').join.chars.join('%')+'%'
  puts whazz
  Movie.select('movies.id').joins(:actors).where("lower(name) like \'#{whazz}\'")
  .order('movies.title desc')


end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.

  Actor.select(:id ,:name , 'MAX(movies.yr)-MIN(movies.yr) as career')
  .joins(:movies)
  .group('actors.id')
  .order('career desc, actors.name')
  .limit(3)

end
