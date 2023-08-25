class Player < ActiveRecord::Base
  attr_accessor :name
  # add your associations and methods here
  has_many :pokemons
  belongs_to :game
end
