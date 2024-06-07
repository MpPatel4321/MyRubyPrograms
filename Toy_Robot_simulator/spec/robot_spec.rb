# frozen_string_literal: true

require './robot'

describe 'Robot' do
  describe '#is_board_place?' do
    let(:robot) { Robot.new(5, 5) }

    it 'should returns true when X and Y are valid' do
      x = 3
      y = 2
      expect(robot.is_board_place?(x, y)).to be true
    end

    it 'should returns false when X is negative' do
      x = -1
      y = 2
      expect(robot.is_board_place?(x, y)).to be false
    end

    it 'should returns false when Y is negative' do
      x = 1
      y = -2
      expect(robot.is_board_place?(x, y)).to be false
    end

    it 'should returns false when X and Y both are negative' do
      x = -1
      y = -2
      expect(robot.is_board_place?(x, y)).to be false
    end

    it 'should returns false when X is greater than board size' do
      x = 7
      y = 3
      expect(robot.is_board_place?(x, y)).to be false
    end

    it 'should returns false when Y is greater than board size' do
      x = 3
      y = 7
      expect(robot.is_board_place?(x, y)).to be false
    end

    it 'should returns false when X and Y  both are greater than board size' do
      x = 7
      y = 7
      expect(robot.is_board_place?(x, y)).to be false
    end
  end

  describe '#placed?' do
    let(:robot) { Robot.new(5, 5) }

    it 'should returns false when no command has executed' do
      expect(robot.placed?).to be false
    end

    it 'should returns false when invalid place command has executed' do
      robot.execute_command('PLACE 6,7,NORTH')
      expect(robot.placed?).to be false
    end

    it 'should returns true when atleast one valid place command has executed' do
      robot.execute_command('PLACE 2,3,NORTH')
      expect(robot.placed?).to be true
    end
  end

  describe '#execute_command' do
    let(:robot) { Robot.new(5, 5) }

    context 'after execute valid place command' do
      it 'run PLACE command with valid place' do
        robot.execute_command('PLACE 1,1,NORTH')
        robot.execute_command('PLACE 2,3,NORTH')
        expect(robot.current_place).to eq('2, 3, NORTH')
      end

      it 'run PLACE command with invalid place' do
        robot.execute_command('PLACE 1,1,NORTH')
        robot.execute_command('PLACE 6,7,NORTH')
        expect(robot.current_place).to eq('1, 1, NORTH')
      end

      it 'run MOVE command it should move forward when valid board place' do
        robot.execute_command('PLACE 3,3,EAST')
        robot.execute_command('MOVE')
        expect(robot.current_place).to eq('4, 3, EAST')
      end

      it 'run MOVE command it should not move forward when invalid board place' do
        robot.execute_command('PLACE 4,4,EAST')
        robot.execute_command('MOVE')
        expect(robot.current_place).to eq('4, 4, EAST')
      end

      it 'run LEFT command it rotate left' do
        robot.execute_command('PLACE 1,1,EAST')
        robot.execute_command('LEFT')
        expect(robot.current_place).to eq('1, 1, NORTH')
      end

      it 'run RIGHT command it rotate left' do
        robot.execute_command('PLACE 1,1,NORTH')
        robot.execute_command('RIGHT')
        expect(robot.current_place).to eq('1, 1, EAST')
      end
    end

    context 'initial run invalid place command' do
      it 'run MOVE command' do
        robot.execute_command('PLACE 5,5,EAST')
        robot.execute_command('MOVE')
        expect(robot.current_place).to eq('not in place')
      end

      it 'run LEFT command' do
        robot.execute_command('PLACE 5,5,EAST')
        robot.execute_command('LEFT')
        expect(robot.current_place).to eq('not in place')
      end

      it 'run RIGHT command' do
        robot.execute_command('PLACE 5,5,NORTH')
        robot.execute_command('RIGHT')
        expect(robot.current_place).to eq('not in place')
      end
    end

    context 'run without place command' do
      it 'run MOVE command' do
        robot.execute_command('MOVE')
        expect(robot.current_place).to eq('not in place')
      end

      it 'run LEFT command' do
        robot.execute_command('LEFT')
        expect(robot.current_place).to eq('not in place')
      end

      it 'run RIGHT command' do
        robot.execute_command('RIGHT')
        expect(robot.current_place).to eq('not in place')
      end
    end
  end

  describe '#rotate_left' do
    let(:robot) { Robot.new(5, 5) }
    it 'when rotate left direction should be change NORTH to WEST' do
      robot.execute_command('PLACE 2,2,NORTH')
      robot.rotate_left
      expect(robot.current_place).to eq('2, 2, WEST')
    end

    it 'when rotate left direction should be change WEST to SOUTH' do
      robot.execute_command('PLACE 2,2,WEST')
      robot.rotate_left
      expect(robot.current_place).to eq('2, 2, SOUTH')
    end

    it 'when rotate left direction should be change SOUTH to EAST' do
      robot.execute_command('PLACE 2,2,SOUTH')
      robot.rotate_left
      expect(robot.current_place).to eq('2, 2, EAST')
    end

    it 'when rotate left direction should be change EAST to NORTH' do
      robot.execute_command('PLACE 2,2,EAST')
      robot.rotate_left
      expect(robot.current_place).to eq('2, 2, NORTH')
    end
  end

  describe '#rotate_right' do
    let(:robot) { Robot.new(5, 5) }
    it 'when rotate right direction should be change NORTH to EAST' do
      robot.execute_command('PLACE 2,2,NORTH')
      robot.rotate_right
      expect(robot.current_place).to eq('2, 2, EAST')
    end

    it 'when rotate right direction should be change EAST to SOUTH' do
      robot.execute_command('PLACE 2,2,EAST')
      robot.rotate_right
      expect(robot.current_place).to eq('2, 2, SOUTH')
    end

    it 'when rotate right direction should be change SOUTH to WEST' do
      robot.execute_command('PLACE 2,2,SOUTH')
      robot.rotate_right
      expect(robot.current_place).to eq('2, 2, WEST')
    end

    it 'when rotate right direction should be change WEST to NORTH' do
      robot.execute_command('PLACE 2,2,WEST')
      robot.rotate_right
      expect(robot.current_place).to eq('2, 2, NORTH')
    end
  end

  describe '#move_forward' do
    let(:robot) { Robot.new(5, 5) }
    it 'move forward with NORTH direction' do
      robot.execute_command('PLACE 2,2,NORTH')
      robot.move_forward
      expect(robot.current_place).to eq('2, 3, NORTH')
    end

    it 'move forward with SOUTH direction' do
      robot.execute_command('PLACE 2,2,SOUTH')
      robot.move_forward
      expect(robot.current_place).to eq('2, 1, SOUTH')
    end

    it 'move forward with EAST direction' do
      robot.execute_command('PLACE 2,2,EAST')
      robot.move_forward
      expect(robot.current_place).to eq('3, 2, EAST')
    end

    it 'move forward with WEST direction' do
      robot.execute_command('PLACE 2,2,WEST')
      robot.move_forward
      expect(robot.current_place).to eq('1, 2, WEST')
    end
  end
end
