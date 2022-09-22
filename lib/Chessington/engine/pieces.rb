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
        moves.filter { |element| is_in_board(board, element) }
      end

      def is_in_board(board, square)
        (square.instance_of?(Square) and (square.row >= 0 and square.row < board.get_board_size and square.column >= 0 and square.column < board.get_board_size))
      end

    end

    ##
    # A class representing a chess pawn.
    class Pawn
      include Piece

      def initialize(player)
        super(player)
        @pawn_direction = player.colour == :white ? 1 : -1
      end

      def move_forward_one(board, current_square)
        pawn_is_not_blocked = board.get_piece(Square.at(current_square.row + @pawn_direction, current_square.column)).nil?
        pawn_is_not_blocked ? Square.at(current_square.row + @pawn_direction, current_square.column) : nil
      end

      def move_forward_two(board, current_square)
        pawn_is_in_starting_position = ((@pawn_direction == 1 and current_square.row == 1) or (@pawn_direction == -1 and current_square.row == 6))
        if pawn_is_in_starting_position
          pawn_is_not_blocked = (board.get_piece(Square.at(current_square.row + @pawn_direction, current_square.column)).nil? and board.get_piece(Square.at(current_square.row + @pawn_direction * 2, current_square.column)).nil?)
          if pawn_is_not_blocked
            return Square.at(current_square.row + @pawn_direction * 2, current_square.column)
          end
        end
        nil
      end

      def take_diagonal(board, current_square)
        diagonal_directions = [1, -1]
        diagonal_directions.map! { |diagonal_direction|
          piece = board.get_piece(Square.at(current_square.row + @pawn_direction, current_square.column + diagonal_direction))
          if !piece.nil? and piece.player.colour == player.opponent.colour
            Square.at(current_square.row + @pawn_direction, current_square.column + diagonal_direction)
          else
            nil
          end
        }
      end

      def available_moves(board)
        current_square = board.find_piece(self)
        moves = []
        moves.push(move_forward_one(board, current_square))
        moves.push(move_forward_two(board, current_square))
        moves += take_diagonal(board, current_square)
        moves = constrain_to_board_squares(board, moves)
        moves
      end

    end

    class PieceCanMoveMultiple
      include Piece

      def initialize(player, directions)
        super(player)
        @directions = directions
      end

      def move_in_all_directions(board, current_square)
        moves = []
        @directions.each do |direction|
          (1..board.get_board_size).each do |i|
            potential_move = Square.at(current_square.row + direction[0] * i, current_square.column + direction[1] * i)
            square_occupant = board.get_piece(potential_move)
            if square_occupant.nil?
              moves.push(potential_move)
            elsif square_occupant.player.colour == player.colour
              break
            elsif square_occupant.player.colour == player.opponent.colour
              moves.push(potential_move)
              break
            end
          end
        end
        moves
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
    class Bishop < PieceCanMoveMultiple
      include Piece

      def initialize(player)
        super(player, [[1, 1], [1, -1], [-1, 1], [-1, -1]])
      end

      def available_moves(board)
        moves = []
        current_square = board.find_piece(self)
        moves += move_in_all_directions(board, current_square)
        moves = constrain_to_board_squares(board, moves)
        moves
      end
    end

    ##
    # A class representing a chess rook.
    class Rook < PieceCanMoveMultiple

      def initialize(player)
        super(player, [[0, 1], [0, -1], [1, 0], [-1, 0]])
      end

      def available_moves(board)
        moves = []
        current_square = board.find_piece(self)
        moves += move_in_all_directions(board, current_square)
        moves = constrain_to_board_squares(board, moves)
        moves
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
