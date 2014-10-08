module PayTypesHelper

  def set_pay_types
    @pay_types = PayType.all
  end
  
end
