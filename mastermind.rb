class Game
    def initialize
        puts "Hello Player, What is your name?"
        name = gets.chomp
        @player = Player.new(name)
        @computer = Computer.new
        instructions
        p @computer.code
        guesses
    end

    def instructions
        puts "The following colours are available: \n Red (R)\n Yellow (Y)\n Orange (O)\n Green (G)\n Blue (B)\n Purple (P)\n"
        puts "The computer will pick a four colour code, and you have 12 guesses to figure it out."
        puts "After each guess the computer will give an X for a colour placed in the right spot, and an O for a colour placed in the wrong spot."
        puts "Example Guess: RBPO"
    end

    def guesses
        12.times do |guess_number|
            print "Put guess number #{guess_number+1}: "
            guess = gets.chomp.downcase.split("")
            p check_match(guess, check_colour(guess))
            if check_match(guess, check_colour(guess)) == "XXXX"
                puts "Congrats! You'be guessed the correct code!"
                break
            end
            puts "Sorry, your 12 guesses are up.  The code was #{@computer.code.join.upcase }" if guess_number == 11
        end
    end

    def check_colour guess
        feedback = "****".split("")
        feedback_counter = 0
        guess_copy = guess.clone
        code_copy = @computer.code.clone
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

    def check_match guess, feedback
        feedback_counter = 0 
        4.times do |x|
            if @computer.code[x] == guess[x]
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
    end
end

class Computer
    attr_accessor :code
    def initialize
        colours = "ryogbp".split("")
        @code = []
        4.times do
            @code.push(colours.sample)
        end
        @code
    end
end

game = Game.new