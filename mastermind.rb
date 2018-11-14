require 'set'
class Array
    def included_in? array
        array.to_set.superset?(self.to_set)
    end
end

class Game
    def initialize
        puts "Hello Player, What is your name?"
        name = gets.chomp
        @human = Player.new(name)
    end
end

class Check
    def check_colour guess, code
        feedback = "****".split("")
        feedback_counter = 0
        guess_copy = guess.clone
        code_copy = code.clone
        4.times do |x|
            4.times do |y|
                if code_copy[x] == guess_copy[y]
                    feedback[feedback_counter] = "O"
                    feedback_counter += 1
                    guess_copy[y] = "*"
                    code_copy[x] = "#"
                end
            end
        end
        feedback_counter = 0
        feedback
    end

    def check_match guess, feedback, code
        feedback_counter = 0 
        4.times do |x|
            if code[x] == guess[x]
                feedback[feedback_counter] = "X"
                feedback_counter += 1
            end
        end
        feedback_counter = 0
        feedback.join
    end
end

class Player
    attr_accessor :player
    def initialize (player)
        @player = player
        print "#{player} Press 1 to be the Codemaker, or Press 2 to be the Codebreaker: "
        @gamemode = gets.chomp
        while @gamemode != "1" && @gamemode != "2"
            puts "That is not a valid option."
            print "#{player} Press 1 to be the Codemaker, or Press 2 to be the Codebreaker: "
            @gamemode = gets.chomp
        end
        create_code if @gamemode == "1"
        instructions if @gamemode == "2"
    end

    def create_code
        colours = "ryogbp".split("") 
        puts "The following colours are available: \n Red (R)\n Yellow (Y)\n Orange (O)\n Green (G)\n Blue (B)\n Purple (P)\n"
        puts "Example Code: RBPO"
        print "Enter your code: "
        @code = gets.chomp.downcase.split("")
        (print "That is not a valid code.  Enter a new code: "; @code = gets.chomp.downcase.split("")) until @code.included_in?(colours) && @code.length == 4
        @computer = Computer.new(@gamemode, @code)
    end 

    def instructions
        puts "The following colours are available: \n Red (R)\n Yellow (Y)\n Orange (O)\n Green (G)\n Blue (B)\n Purple (P)\n"
        puts "The computer will pick a four colour code, and you have 12 guesses to figure it out."
        puts "After each guess the computer will give an X for a colour placed in the right spot, and an O for a colour placed in the wrong spot."
        puts "Example Guess: RBPO"
        @computer = Computer.new(@gamemode)
        guesses
    end

    def guesses
        check = Array.new(12)
        12.times do |guess_number|
            print "##{guess_number+1} Code Guess: "
            guess = gets.chomp.downcase.split("")
            check[guess_number] = Check.new
            p check[guess_number].check_match(guess, check[guess_number].check_colour(guess, @computer.code), @computer.code)
            if check[guess_number].check_match(guess, check[guess_number].check_colour(guess, @computer.code), @computer.code) == "XXXX"
                puts "Congrats! You'be guessed the correct code!"
                break
            end
            puts "Sorry, your 12 guesses are up.  The code was #{@computer.code.join.upcase }" if guess_number == 11
        end
    end
end

class Computer
    attr_accessor :code
    def initialize gamemode, code
        codebreaker(code) if gamemode == "1"
        codemaker if gamemode == "2"
    end

    def codemaker
        colours = "ryogbp".split("")
        @code = []
        4.times do
            @code.push(colours.sample)
        end
        @code
    end

    def codebreaker code
        check = Array.new(12)
        12.times do |guess_number|
            colours = "ryogbp".split("")
            guess = []
            4.times do
              guess.push(colours.sample)
            end 
            puts "##{guess_number+1} Code Guess: #{guess.join.upcase}"
            check[guess_number] = Check.new
            p check[guess_number].check_match(guess, check[guess_number].check_colour(guess, code), code)
            if check[guess_number].check_match(guess, check[guess_number].check_colour(guess, code), code) == "XXXX"
                puts "Congrats! You'be guessed the correct code!"
                break
            end
            puts "Sorry, your 12 guesses are up.  The code was #{code.join.upcase }" if guess_number == 11
        end
    end
end

game = Game.new