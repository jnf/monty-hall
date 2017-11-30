class Contestant
  attr_reader :switches, :choice, :record
  def initialize(opts = {})
    # keeper by default
    @switches = opts[:switches] || false
    @choice = nil
    @record = {
      wins: 0,
      losses: 0,
      plays: 0,
    }
  end

  def first_choice(doors)
    @choice = doors.keys.sample
  end

  def final_choice(doors)
    switches ? (doors.keys - [choice]).first : choice

    # puts([doors, choice, switches].inspect) if switches
  end

  def record_outcome(win)
    record[win ? :wins : :losses] += 1
    record[:plays] += 1
    record
  end
end
