module SelectedStatusHandler
  def save_selected_status(status_array)
#    puts '- saving [selected_status]'
#    puts "  selected_status => #{@status100.status_array}, number_of(true) => #{@status100.selected_num}"
#    UIApplication.sharedApplication.delegate.settings.selected_status = @status100.status_array
    UIApplication.sharedApplication.delegate.settings[:selected_status] = status_array
  end

  def loaded_selected_status
#    puts '- loading [selected_status]'
    status_array = UIApplication.sharedApplication.delegate.settings.selected_status
    case status_array
      when nil ; nil
      else
#        puts "  loaded_status_array => #{status_array}"
        status_array.dup
    end
  end

end