# frozen_string_literal: true

module Data_store
  def data
    @shifts << Shift.new(@shifts.length).initialize_dummy(['night', [0, 8], { 'cook' => 1, 'shipper' => 1 }])
    @shifts << Shift.new(@shifts.length).initialize_dummy(['morning', [8, 16], { 'cook' => 1, 'shipper' => 1 }])
    @shifts << Shift.new(@shifts.length).initialize_dummy(['evening', [16, 24], { 'cook' => 1, 'shipper' => 1 }])

    worker = Worker.new(@workers.length, 1)
    worker.initialize_dummy({ name: 'user1', current_positions: %w[cook shipper], availablities: [
                              { day: '0', available: 'Y', start_t: [8, 16] },
                              { day: '1', available: 'n', start_t: [1, 23] },
                              { day: '2', available: 'n', start_t: [16, 24] },
                              { day: '3', available: 'n', start_t: [0, 22] },
                              { day: '4', available: 'n', start_t: [5, 14] },
                              { day: '5', available: 'n', start_t: [9, 15] },
                              { day: '6', available: 'n', start_t: [9, 15] }
                            ] })
    @workers << worker
    check_schedule(worker)

    worker = Worker.new(@workers.length, 1)
    worker.initialize_dummy({ name: 'use2', current_positions: ['cook'], availablities: [
                              { day: '0', available: 'Y', start_t: [8, 16] },
                              { day: '1', available: 'n', start_t: [9, 18] },
                              { day: '2', available: 'n', start_t: [9, 15] },
                              { day: '3', available: 'n', start_t: [9, 18] },
                              { day: '4', available: 'n', start_t: [9, 15] },
                              { day: '5', available: 'n', start_t: [9, 15] },
                              { day: '6', available: 'n', start_t: [9, 15] }
                            ] })
    @workers << worker
    check_schedule(worker)

    # worker = Worker.new(@workers.length, 1)
    # worker.initialize_dummy({ name: 'user5', current_positions: ['cook'], availablities: [
    #                           { day: '0', available: 'Y', start_t: [2, 8] },
    #                           { day: '1', available: 'Y', start_t: [9, 18] },
    #                           { day: '2', available: 'n', start_t: [9, 15] },
    #                           { day: '3', available: 'n', start_t: [9, 18] },
    #                           { day: '4', available: 'n', start_t: [9, 15] },
    #                           { day: '5', available: 'n', start_t: [9, 15] },
    #                           { day: '6', available: 'n', start_t: [9, 15] }
    #                         ] })
    # @workers << worker
    # check_schedule(worker)

    # worker = Worker.new(@workers.length, 1)
    # worker.initialize_dummy({ name: 'user3', current_positions: ['shipper'], availablities: [
    #                           { day: '0', available: 'n', start_t: [12, 14] },
    #                           { day: '1', available: 'Y', start_t: [12, 16] },
    #                           { day: '2', available: 'n', start_t: [9, 15] },
    #                           { day: '3', available: 'n', start_t: [9, 18] },
    #                           { day: '4', available: 'n', start_t: [9, 15] },
    #                           { day: '5', available: 'n', start_t: [9, 15] },
    #                           { day: '6', available: 'n', start_t: [9, 15] }
    #                         ] })
    # @workers << worker
    # check_schedule(worker)

    # worker = Worker.new(@workers.length, 1)
    # worker.initialize_dummy({ name: 'user4', current_positions: ['shipper'], availablities: [
    #                           { day: '0', available: 'n', start_t: [8, 12] },
    #                           { day: '1', available: 'Y', start_t: [8, 10] },
    #                           { day: '2', available: 'n', start_t: [9, 15] },
    #                           { day: '3', available: 'n', start_t: [9, 18] },
    #                           { day: '4', available: 'n', start_t: [9, 15] },
    #                           { day: '5', available: 'n', start_t: [9, 15] },
    #                           { day: '6', available: 'n', start_t: [9, 15] }
    #                         ] })
    # @workers << worker
    # check_schedule(worker)

    # worker = Worker.new(@workers.length, 1)
    # worker.initialize_dummy({ name: 'user6', current_positions: ['shipper'], availablities: [
    #                           { day: '0', available: 'n', start_t: [8, 12] },
    #                           { day: '1', available: 'Y', start_t: [10, 12] },
    #                           { day: '2', available: 'n', start_t: [9, 15] },
    #                           { day: '3', available: 'n', start_t: [9, 18] },
    #                           { day: '4', available: 'n', start_t: [9, 15] },
    #                           { day: '5', available: 'n', start_t: [9, 15] },
    #                           { day: '6', available: 'n', start_t: [9, 15] }
    #                         ] })
    # @workers << worker
    # check_schedule(worker)
  end
end
