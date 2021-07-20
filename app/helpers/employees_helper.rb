module EmployeesHelper

  def empl_short(empl)
    "#{empl.last_name}, #{empl.first_name}, #{empl.email}, #{empl.department}"
  end
end
