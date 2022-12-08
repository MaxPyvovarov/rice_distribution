require 'csv'
require 'histogram/array'

require './rice_distribution'
require './ui'

InputData = Struct.new(:v, :sigma, :size) do
  def valid?
    !v.nil? && v > 0 && !sigma.nil? && sigma > 0 && !size.nil? && size > 0
  end
end
input_data = InputData.new(nil, nil, nil)

ui = UI.new(title: 'Розподіл Райса')

ui.init_inputs(input_data)

instruction_action = ui.init_action('Інструкція', :instruction) do
  ui.show_alert("Для того, щоб змоделювати графік випадкових величин з розподілом Райса потрібно ввести значення:\n\n"
                                                                "σ - очікуване значення функції (floating number)\n" 
                                                                "v - очікуване значення функції (floating number)\n"
                                                                "size - кількість випадкових величин (integer)\n\n"
                                                                "Після чого потрібно натиснути кнопку 'Згенерувати' і перед вами з'явиться графік\n\n"
                                                                "Для експорту значень у таблицю формату .csv потрібно натиснути кнопку 'Експорт у .csv' після генерації графіку\n\n\n"
                                                                "Розробник: \n\n"
                                                                "Пивоваров Максим,\n"
                                                                "студент групи КС-44\n")
end

generate_action = ui.init_action('Згенерувати', :generate) do
  distribution = RiceDistribution.new(input_data)
  @random_values = distribution.rvs
  pdf_arrange = distribution.pdf_arrange(@random_values)
  pdf = distribution.pdf(pdf_arrange)

  (bins, freqs) = @random_values.to_a.histogram(10)
  freqs = freqs.map { |freqs| freqs / input_data.size }

  ui.show_plot([
    { x: bins, y: freqs, name: 'data distribution' },
    { x: pdf_arrange.to_a, y: pdf.to_a, name: 'pdf' }
  ])
  @export_action.show

  ui.show_info("cdf: #{distribution.cdf.round(2)} \n"\
               "mean calculated: #{distribution.mean.round(2)} \n"\
               "mean from values: #{distribution.numpy_mean(@random_values).round(2)} \n"\
               "variance calculated: #{distribution.var.round(2)}\n"\
               "variance from values: #{distribution.numpy_var(@random_values).round(2)}")
end
generate_action.hide

@export_action = ui.init_action('Експорт', :export) do
  CSV.open(ui.window.get_export_save_path, 'w') do |csv|
    @random_values.each { |row| csv << [row] }
  end
end
@export_action.hide

ui.window.wait_until_closed
