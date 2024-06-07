# frozen_string_literal: true

require './pawan'

describe 'Pawan' do
  let(:obj1) { Pawan.new([0, 0]) }
  let(:obj2) { Pawan.new([5, 0]) }
  describe '#start' do
    it 'when start with [0, 0] cordinates' do
      data = { 'start' => [0, 0], 'E' => [0, 3], 'SW' => [2, 1], 'SE' => [4, 3], 'N' => [1, 3],
               'W' => [1, 0], 'S' => [4, 0], 'NE' => [2, 2], 'NW' => [0, 0] }
      expect(obj1.start).to eq(data)
    end

    it 'when start with [5, 0] cordinates' do
      data = { 'start' => [5, 0], 'N' => [2, 0], 'NE' => [0, 2], 'E' => [0, 5], 'SW' => [2, 3],
               'NW' => [0, 1], 'S' => [3, 1], 'SE' => [5, 3], 'W' => [5, 0] }
      expect(obj2.start).to eq(data)
    end
  end

  describe '#set_next_move' do
    it 'when start with [0, 0] cordinates' do
      expect(obj1.set_next_move).to eq([0, 3])
    end

    it 'when start with [5, 0] cordinates' do
      expect(obj2.set_next_move).to eq([2, 0])
    end
  end

  describe '#next_move' do
    it 'when start with [0, 0] cordinates' do
      expect(obj1.next_move).to eq([[0, 3], [2, 2], [3, 0]])
    end

    it 'when start with [5, 0] cordinates' do
      expect(obj2.next_move).to eq([[2, 0], [3, 2], [5, 3], [7, 2], [8, 0]])
    end
  end

  describe '#available_moves' do
    it 'when start with [0, 0] cordinates' do
      data = { 'E' => [0, 3], 'S' => [3, 0], 'SE' => [2, 2] }
      expect(obj1.available_moves).to eq(data)
    end

    it 'when start with [5, 0] cordinates' do
      data = { 'E' => [5, 3], 'N' => [2, 0], 'NE' => [3, 2], 'S' => [8, 0], 'SE' => [7, 2] }
      expect(obj2.available_moves).to eq(data)
    end
  end

  describe '#direction_hash' do
    it 'when start with [0, 0] cordinates' do
      data = { 'E' => [0, 3], 'N' => nil, 'NE' => nil, 'NW' => nil, 'S' => [3, 0], 'SE' => [2, 2], 'SW' => nil,
               'W' => nil }
      expect(obj1.direction_hash).to eq(data)
    end

    it 'when start with [5, 0] cordinates' do
      data = { 'E' => [5, 3], 'N' => [2, 0], 'NE' => [3, 2], 'NW' => nil, 'S' => [8, 0], 'SE' => [7, 2], 'SW' => nil,
               'W' => nil }
      expect(obj2.direction_hash).to eq(data)
    end
  end

  describe '#validate?' do
    it 'when start with valid cordinates' do
      expect(obj1.validate?([0, 3])).to eq(true)
    end

    it 'when start with invalid cordinates' do
      expect(obj2.validate?([9, 10])).to eq(false)
    end
  end

  describe '#cordinate?' do
    it 'when start with valid cordinate' do
      expect(obj1.cordinate?(0)).to eq(true)
    end

    it 'when start with invalid cordinate' do
      expect(obj2.cordinate?(10)).to eq(false)
    end
  end

  describe '#north' do
    it 'when start with [0, 0] cordinate' do
      expect(obj1.north).to eq(nil)
    end

    it 'when start with [5, 0] cordinate' do
      expect(obj2.north).to eq([2, 0])
    end
  end

  describe '#north_west' do
    it 'when start with [0, 0] cordinate' do
      expect(obj1.north_west).to eq(nil)
    end

    it 'when start with [5, 0] cordinate' do
      expect(obj2.north_west).to eq(nil)
    end
  end

  describe '#west' do
    it 'when start with [0, 0] cordinate' do
      expect(obj1.west).to eq(nil)
    end

    it 'when start with [5, 0] cordinate' do
      expect(obj2.west).to eq(nil)
    end
  end

  describe '#south_west' do
    it 'when start with [0, 0] cordinate' do
      expect(obj1.south_west).to eq(nil)
    end

    it 'when start with [5, 0] cordinate' do
      expect(obj2.south_west).to eq(nil)
    end
  end

  describe '#south' do
    it 'when start with [0, 0] cordinate' do
      expect(obj1.south).to eq([3, 0])
    end

    it 'when start with [5, 0] cordinate' do
      expect(obj2.south).to eq([8, 0])
    end
  end

  describe '#south_east' do
    it 'when start with [0, 0] cordinate' do
      expect(obj1.south_east).to eq([2, 2])
    end

    it 'when start with [5, 0] cordinate' do
      expect(obj2.south_east).to eq([7, 2])
    end
  end

  describe '#east' do
    it 'when start with [0, 0] cordinate' do
      expect(obj1.east).to eq([0, 3])
    end

    it 'when start with [5, 0] cordinate' do
      expect(obj2.east).to eq([5, 3])
    end
  end

  describe '#north_east' do
    it 'when start with [0, 0] cordinate' do
      expect(obj1.north_east).to eq(nil)
    end

    it 'when start with [5, 0] cordinate' do
      expect(obj2.north_east).to eq([3, 2])
    end
  end

  describe '#evaluate' do
    context 'when start with [0, 0] cordinate' do
      it 'with North direction' do
        expect(obj1.evaluate(-3, 0, 'N')).to eq(nil)
      end

      it 'with North West direction' do
        expect(obj1.evaluate(-2, -2, 'NW')).to eq(nil)
      end

      it 'with West direction' do
        expect(obj1.evaluate(0, -3, 'W')).to eq(nil)
      end

      it 'with South West direction' do
        expect(obj1.evaluate(2, -2, 'SW')).to eq(nil)
      end

      it 'with South direction' do
        expect(obj1.evaluate(3, 0, 'S')).to eq([3, 0])
      end

      it 'with South East direction' do
        expect(obj1.evaluate(2, 2, 'SE')).to eq([2, 2])
      end

      it 'with East direction' do
        expect(obj1.evaluate(0, 3, 'E')).to eq([0, 3])
      end

      it 'with North East direction' do
        expect(obj1.evaluate(-2, 2, 'NE')).to eq(nil)
      end
    end

    context 'when start with [5, 5] cordinate' do
      it 'with North direction' do
        expect(obj2.evaluate(-3, 0, 'N')).to eq([2, 0])
      end

      it 'with North West direction' do
        expect(obj2.evaluate(-2, -2, 'NW')).to eq(nil)
      end

      it 'with West direction' do
        expect(obj2.evaluate(0, -3, 'W')).to eq(nil)
      end

      it 'with South West direction' do
        expect(obj2.evaluate(2, -2, 'SW')).to eq(nil)
      end

      it 'with South direction' do
        expect(obj2.evaluate(3, 0, 'S')).to eq([8, 0])
      end

      it 'with South East direction' do
        expect(obj2.evaluate(2, 2, 'SE')).to eq([7, 2])
      end

      it 'with East direction' do
        expect(obj2.evaluate(0, 3, 'E')).to eq([5, 3])
      end

      it 'with North East direction' do
        expect(obj2.evaluate(-2, 2, 'NE')).to eq([3, 2])
      end
    end
  end

  describe '#available?' do
    context 'when start with [0, 0] cordinate' do
      it 'with North direction' do
        expect(obj1.available?('N')).to eq(true)
      end

      it 'with North West direction' do
        expect(obj1.available?('NW')).to eq(true)
      end

      it 'with West direction' do
        expect(obj1.available?('W')).to eq(true)
      end

      it 'with South West direction' do
        expect(obj1.available?('SW')).to eq(true)
      end

      it 'with South direction' do
        expect(obj1.available?('S')).to eq(true)
      end

      it 'with South East direction' do
        expect(obj1.available?('SE')).to eq(true)
      end

      it 'with East direction' do
        expect(obj1.available?('E')).to eq(true)
      end

      it 'with North East direction' do
        expect(obj1.available?('NE')).to eq(true)
      end
    end

    context 'when start with [5, 5] cordinate' do
      it 'with North direction' do
        expect(obj2.available?('N')).to eq(true)
      end

      it 'with North West direction' do
        expect(obj2.available?('NW')).to eq(true)
      end

      it 'with West direction' do
        expect(obj2.available?('W')).to eq(true)
      end

      it 'with South West direction' do
        expect(obj2.available?('SW')).to eq(true)
      end

      it 'with South direction' do
        expect(obj2.available?('S')).to eq(true)
      end

      it 'with South East direction' do
        expect(obj2.available?('SE')).to eq(true)
      end

      it 'with East direction' do
        expect(obj2.available?('E')).to eq(true)
      end

      it 'with North East direction' do
        expect(obj2.available?('NE')).to eq(true)
      end
    end
  end

  describe '#eval_cordinates' do
    context 'when start with [0, 0] cordinate' do
      it 'with North direction' do
        expect(obj1.eval_cordinates(-3, 0)).to eq([-3, 0])
      end

      it 'with North West direction' do
        expect(obj1.eval_cordinates(-2, -2)).to eq([-2, -2])
      end

      it 'with West direction' do
        expect(obj1.eval_cordinates(0, -3)).to eq([0, -3])
      end

      it 'with South West direction' do
        expect(obj1.eval_cordinates(2, -2)).to eq([2, -2])
      end

      it 'with South direction' do
        expect(obj1.eval_cordinates(3, 0)).to eq([3, 0])
      end

      it 'with South East direction' do
        expect(obj1.eval_cordinates(2, 2)).to eq([2, 2])
      end

      it 'with East direction' do
        expect(obj1.eval_cordinates(0, 3)).to eq([0, 3])
      end

      it 'with North East direction' do
        expect(obj1.eval_cordinates(-2, 2)).to eq([-2, 2])
      end
    end

    context 'when start with [5, 5] cordinate' do
      it 'with North direction' do
        expect(obj2.eval_cordinates(-3, 0)).to eq([2, 0])
      end

      it 'with North West direction' do
        expect(obj2.eval_cordinates(-2, -2)).to eq([3, -2])
      end

      it 'with West direction' do
        expect(obj2.eval_cordinates(0, -3)).to eq([5, -3])
      end

      it 'with South West direction' do
        expect(obj2.eval_cordinates(2, -2)).to eq([7, -2])
      end

      it 'with South direction' do
        expect(obj2.eval_cordinates(3, 0)).to eq([8, 0])
      end

      it 'with South East direction' do
        expect(obj2.eval_cordinates(2, 2)).to eq([7, 2])
      end

      it 'with East direction' do
        expect(obj2.eval_cordinates(0, 3)).to eq([5, 3])
      end

      it 'with North East direction' do
        expect(obj2.eval_cordinates(-2, 2)).to eq([3, 2])
      end
    end
  end
end
