# frozen_string_literal: true

require './toy'

describe 'Toy' do
  describe '#check_valid_command?' do
    let(:toy) { Toy.new(0, 0, 'EAST') }
    it 'should returns true when input are valid' do
      expect(toy.check_valid_command?('PLACE,2,2,NORTH')).to be true
      expect(toy.position).to eq([2, 2, 'NORTH'])
    end
    it 'should returns false when input are invalid' do
      expect(toy.check_valid_command?('PLACE,2,2')).to be false
      expect(toy.position).to eq([0, 0, 'EAST'])
    end
    it 'should return false when X is negative' do
      expect(toy.check_valid_command?('PLACE,-2,2,NORTH')).to be false
      expect(toy.position).to eq([0, 0, 'EAST'])
    end
    it 'should return false when Y is negative' do
      expect(toy.check_valid_command?('PLACE,2,-2,NORTH')).to be false
      expect(toy.position).to eq([0, 0, 'EAST'])
    end
    it 'should return false when X and Y both are negative' do
      expect(toy.check_valid_command?('PLACE,-2,-2,NORTH')).to be false
      expect(toy.position).to eq([0, 0, 'EAST'])
    end
    it 'should return false when X is greater than board size' do
      expect(toy.check_valid_command?('PLACE,8,2,NORTH')).to be false
      expect(toy.position).to eq([0, 0, 'EAST'])
    end
    it 'should return false when Y is greater than board size' do
      expect(toy.check_valid_command?('PLACE,2,8,NORTH')).to be false
      expect(toy.position).to eq([0, 0, 'EAST'])
    end
    it 'should return false when X and Y both are greater than board size' do
      expect(toy.check_valid_command?('PLACE,8,8,NORTH')).to be false
      expect(toy.position).to eq([0, 0, 'EAST'])
    end
  end

  describe '#move' do
    let(:toy) { Toy.new(3, 3, 'EAST') }
    it 'when current direction north' do
      toy.current_direction = 'NORTH'
      toy.execute_command('MOVE')
      expect(toy.position).to eq([4, 3, 'NORTH'])
    end
    it 'when current direction SOUTH' do
      toy.current_direction = 'SOUTH'
      toy.execute_command('MOVE')
      expect(toy.position).to eq([2, 3, 'SOUTH'])
    end
    it 'when current direction EAST' do
      toy.current_direction = 'EAST'
      toy.execute_command('MOVE')
      expect(toy.position).to eq([3, 2, 'EAST'])
    end
    it 'when current direction WEST' do
      toy.current_direction = 'WEST'
      toy.execute_command('MOVE')
      expect(toy.position).to eq([3, 4, 'WEST'])
    end
    it 'when X and Y in last place' do
      toy.current_direction = 'NORTH'
      toy.x = 5
      toy.y = 5
      toy.execute_command('MOVE')
      expect(toy.position).to eq([5, 5, 'NORTH'])
    end
    it 'when X and Y in first place' do
      toy.current_direction = 'SOUTH'
      toy.x = 0
      toy.y = 0
      toy.execute_command('MOVE')
      expect(toy.position).to eq([0, 0, 'SOUTH'])
    end
  end

  describe '#execute_command' do
    let(:toy) { Toy.new(3, 3, 'EAST') }
    it 'when run MOVE command' do
      toy.execute_command('MOVE')
      expect(toy.position).to eq([3, 2, 'EAST'])
    end
    it 'when run LEFT command' do
      toy.execute_command('LEFT')
      expect(toy.position).to eq([3, 3, 'NORTH'])
    end
    it 'when run RIGHT command' do
      toy.execute_command('RIGHT')
      expect(toy.position).to eq([3, 3, 'SOUTH'])
    end
  end

  describe '#rotate_left' do
    let(:toy) { Toy.new(3, 3, 'EAST') }
    it 'when rotate left direction should be change NORTH to WEST' do
      toy.current_direction = 'NORTH'
      toy.rotate_left
      expect(toy.position).to eq([3, 3, 'WEST'])
    end
    it 'when rotate left direction should be change WEST to SOUTH' do
      toy.current_direction = 'WEST'
      toy.rotate_left
      expect(toy.position).to eq([3, 3, 'SOUTH'])
    end
    it 'when rotate left direction should be change SOUTH to EAST' do
      toy.current_direction = 'SOUTH'
      toy.rotate_left
      expect(toy.position).to eq([3, 3, 'EAST'])
    end
    it 'when rotate left direction should be change EAST to NORTH' do
      toy.current_direction = 'EAST'
      toy.rotate_left
      expect(toy.position).to eq([3, 3, 'NORTH'])
    end
  end

  describe '#rotate_right' do
    let(:toy) { Toy.new(3, 3, 'EAST') }
    it 'when rotate right direction should be change NORTH to EAST' do
      toy.current_direction = 'NORTH'
      toy.rotate_right
      expect(toy.position).to eq([3, 3, 'EAST'])
    end
    it 'when rotate right direction should be change EAST to SOUTH' do
      toy.current_direction = 'EAST'
      toy.rotate_right
      expect(toy.position).to eq([3, 3, 'SOUTH'])
    end
    it 'when rotate right direction should be change SOUTH to WEST' do
      toy.current_direction = 'SOUTH'
      toy.rotate_right
      expect(toy.position).to eq([3, 3, 'WEST'])
    end
    it 'when rotate right direction should be change WEST to NORTH' do
      toy.current_direction = 'WEST'
      toy.rotate_right
      expect(toy.position).to eq([3, 3, 'NORTH'])
    end
  end
end
