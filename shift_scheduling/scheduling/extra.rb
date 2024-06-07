# frozen_string_literal: true

$LOAD_PATH << '.'
require 'byebug'
require 'range'

shift = {
  availability: 8..16,
  positions: { 'cook' => 1, 'shipper' => 1 }
}

$workers = {
  'a' => { availability: 8..16, positions: %w[cook shipper], 'work_hours' => '' },
  'b' => { availability: 10..12, positions: ['cook'], 'work_hours' => '' }
}

$shift_schedule = {
  'cook' => { 'status' => 'Vacant', 'workers' => {} },
  'shipper' => { 'status' => 'Vacant', 'workers' => {} }
}

def can_replace_with_another_one(position, id)
  worker_id = $shift_schedule[position]['workers'].keys.first
  $workers[worker_id][:positions].each do |worker_position|
    next unless worker_position != position && $shift_schedule[worker_position]['status'] == 'Vacant'

    can_do = true
    latest_position = worker_position
    $shift_schedule[position]['workers'].delete(worker_id)
    $shift_schedule[worker_position]['workers'][worker_id] = $workers[worker_id][:availability]
    $shift_schedule[worker_position]['status'] = 'Scheduled'
    $workers[worker_id]['work_hours'] = $workers[worker_id][:availability]

    $shift_schedule[position]['workers'][id] = $workers[id][:availability]
    $shift_schedule[position]['status'] = 'Scheduled'
    $workers[id]['work_hours'] = $workers[id][:availability]
    break
  end
end

$workers.each do |id, worker|
  range = worker[:availability] & shift[:availability]
  worker[:positions].each do |position|
    next unless $shift_schedule[position]['status'] == 'Vacant'

    $shift_schedule[position]['workers'][id.to_s] = range
    $shift_schedule[position]['status'] = 'Scheduled'
    worker['work_hours'] = range
    break
  end
  # check worker is assigned hour or need we can replace somebody else

  next unless worker['work_hours'] == ''

  worker[:positions].each do |position|
    can_replace_with_another_one(position, id)
  end
end

byebug
a = ''
