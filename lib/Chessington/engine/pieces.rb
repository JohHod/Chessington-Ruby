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
    end

    ##
    # A class representing a chess pawn.
    class Pawn
      include Piece

      def available_moves(board)
        moves = []
        current_square = board.find_piece(self)
        pawn_direction = (self.player.colour == :white) ? 1 : -1
        moves.push(Square.at(current_square.row + pawn_direction, current_square.column))
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
        []
      end
    end

    ##
    # A class representing a chess rook.
    class Rook
      include Piece

      def available_moves(board)
        []
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
