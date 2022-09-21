module Chessington
  module Engine
    ##
    # An abstract base class from which all pieces inherit.
    module Piece
      attr_reader :player

      def initialize(player)
        @player = player
      end

      ##
      #  Get all squares that the piece is allowed to move to.
      def available_moves(board)
        raise "Not implemented"
      end

      ##
      # Move this piece to the given square on the board.
      def move_to(board, new_square)
        current_square = board.find_piece(self)
        board.move_piece(current_square, new_square)
      end

      def constrain_to_board_squares(board, moves)
        return moves.filter { |element| (element.row >= 0 and element.row < board.get_board_size and element.column >= 0 and element.column < board.get_board_size) }
      end

    end

    ##
    # A class representing a chess pawn.
    class Pawn
      include Piece

      def available_moves(board)
        #refactor todo
        moves = []
        current_square = board.find_piece(self)
        pawn_direction = (self.player.colour == :white) ? 1 : -1
        moves.push(Square.at(current_square.row + pawn_direction, current_square.column))
        if (pawn_direction == 1 and current_square.row == 1) or (pawn_direction == -1 and current_square.row == 6) then
          if board.get_piece(Square.at(current_square.row + pawn_direction * 2, current_square.column)).nil? == true then
            moves.push(Square.at(current_square.row + pawn_direction * 2, current_square.column))
          end
        end
        if board.get_piece(Square.at(current_square.row + pawn_direction, current_square.column)).nil? == false then
          moves = []
        end
        moves = constrain_to_board_squares(board, moves)

        diagonal_directions = [1, -1]
        diagonal_directions.each { |diagonal_direction|
          piece = board.get_piece(Square.at(current_square.row + pawn_direction, current_square.column + diagonal_direction))
          if not piece.nil? and piece.player.colour == self.player.opponent.colour then
            moves.push(Square.at(current_square.row + pawn_direction, current_square.column + diagonal_direction))
          end
        }
        return moves
      end
    end

    ##
    # A class representing a chess knight.
    class Knight
      include Piece

      def available_moves(board)
        []
      end
    end

    ##
    # A class representing a chess bishop.
    class Bishop
      include Piece

      def available_moves(board)
        moves = []
        current_square = board.find_piece(self)
        directions = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
        directions.each do |direction|
          (1..board.get_board_size).each do |i|
            potential_move = Square.at(current_square.row + direction[0] * i, current_square.column + direction[1] * i)
            # check if there is an opponent piece, and exit adding that piece, or if it is friendly piece, exit without adding the move
            square_occupant = board.get_piece(potential_move)
            if square_occupant.nil?
              moves.push(potential_move)
            elsif square_occupant.player.colour == self.player.colour
              break
            elsif square_occupant.player.colour == self.player.opponent.colour
              moves.push(potential_move)
              break
            end
          end
        end
        moves = constrain_to_board_squares(board, moves)
        return moves
      end
    end

    ##
    # A class representing a chess rook.
    class Rook
      include Piece

      def available_moves(board)
        moves = []
        current_square = board.find_piece(self)
        directions = [[0, 1], [0, -1], [1, 0], [-1, 0]]
        directions.each do |direction|
          (1..board.get_board_size).each do |i|
            potential_move = Square.at(current_square.row + direction[0] * i, current_square.column + direction[1] * i)
            square_occupant = board.get_piece(potential_move)
            if square_occupant.nil?
              moves.push(potential_move)
            elsif square_occupant.player.colour == self.player.colour
              break
            elsif square_occupant.player.colour == self.player.opponent.colour
              moves.push(potential_move)
              break
            end
          end
        end
        moves = constrain_to_board_squares(board, moves)
        return moves
      end
    end

    ##
    # A class representing a chess queen.
    class Queen
      include Piece

      def available_moves(board)
        []
      end
    end

    ##
    # A class representing a chess king.
    class King
      include Piece

      def available_moves(board)
        []
      end
    end
  end
end
