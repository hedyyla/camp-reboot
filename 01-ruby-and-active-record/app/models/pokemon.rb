require 'json'
require 'rest-client'
require 'sinatra/activerecord'

class Pokemon < ActiveRecord::Base
  # add your associations and methods here
  belongs_to :player

  def attack
    # random = rand(20) - 10
    # damage + random
    min = -10
    max = 10
    damage + rand(min..max)
  end

  def take_damage(attack)
    defence = rand(self.defence)
    damage_taken = attack - defence
    if self.health > damage_taken
      self.health -= damage_taken
    else
      self.health = 0
    end
  end

  def miss?
    # chances = []
    # num = @speed
    # num.times do
    #   chances << 'miss'
    # end
    # (200 - num).times do
    #   chances << 'hit'
    # end
    # chances[rand(200)] == 'miss'
    rand(200) < speed
  end

  def ko?
    health.zero?
  end

  def self.find_stat(stats, key)
    target_hash = stats.find { |hash| hash['stat']['name'] == key }
    target_hash['base_stat']
  end

  def self.details(name)
    url = "https://pokeapi.co/api/v2/pokemon/#{name}"
    serialized_pokemon = RestClient.get(url)
    pokemon = JSON.parse(serialized_pokemon)
    stats = pokemon['stats']
    {
      name: pokemon['name'],
      health: find_stat(stats, 'hp'),
      damage: find_stat(stats, 'attack'),
      defence: find_stat(stats, 'defense'),
      speed: find_stat(stats, 'speed'),
      image: pokemon['sprites']['front_default']
    }
  end
end

puts Pokemon.details('chikorita')
