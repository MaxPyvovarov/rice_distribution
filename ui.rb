require 'flammarion'
require './flammarion_export_csv'

class UI
  attr_reader :window
  attr_reader :inputs
  attr_reader :actions
  attr_reader :graph
  attr_reader :info

  def initialize(title:)
    @window = Flammarion::Engraving.new
    @window.title(title)

    @inputs = window.subpane('inputs')
    @actions = window.subpane('actions')
    @actions_panes = {}
    @graph = window.subpane('graph')
    @info = window.subpane('info')
  end

  def init_inputs(data)
    init_v_input(data)
    init_sigma_input(data)
    init_size_input(data)

    @inputs
  end

  def init_action(title, reference, &block)
    pane = @actions.subpane("#{title}_pane")
    pane.button(title, {}, &block)
    @actions_panes[reference] = pane
    pane
  end

  def show_alert(text)
    window.alert(text)
  end

  def show_plot(data)
    @graph.clear
    @graph.plot(data)
  end

  def show_info(text)
    @info.clear
    @info.puts(text)
  end

  private

  attr_reader :actions_panes

  def init_v_input(data)
    inputs.input('σ') do |input|
      data.v = input['text'].to_f if !!Float(input['text'])

      show_alert('σ must be bigger than 0') if data.v <= 0
      trigger_input_changed(data)
    rescue TypeError
      show_alert('σ should be a floating number!')
    end
  end

  def init_sigma_input(data)
    inputs.input('∨') do |input|
      data.sigma = input['text'].to_f if !!Float(input['text'])

      show_alert('∨ must be bigger than 0') if data.sigma <= 0
      trigger_input_changed(data)
    rescue TypeError
      show_alert('∨ should be a floating number!')
    end
  end

  def init_size_input(data)
    inputs.input('size') do |input|
      data.size = input['text'].to_i if !!Integer(input['text'])

      show_alert('size must be bigger than 0') if data.size <= 0
      trigger_input_changed(data)
    rescue TypeError
      show_alert('size should be an integer number!')
    end
  end

  def trigger_input_changed(data)
    data.valid? ? actions_panes[:generate].show : actions_panes[:generate].hide
  end
end
